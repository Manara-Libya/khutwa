package ly.manara.khutwa.data

import org.json.JSONArray
import org.json.JSONObject
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL

/** One earlier turn, already redacted (user) or as Khutwa wrote it (assistant). Sent, never stored. */
data class Turn(val role: String, val text: String)

data class Analysis(
    val urgent: Boolean,
    val risk: String,
    val reflection: String?,
    val supportReady: Boolean,
    val suggestions: List<Option>,
)

class ApiException(message: String, val unauthorized: Boolean = false) : IOException(message)

/**
 * The Khutwa API. Only redacted text is ever passed in (the caller enforces it by passing what the
 * redactor returned). The server URL changes when the laptop restarts the tunnel, so it is read from
 * the published gist, with the build-time URL as a fallback.
 */
class KhutwaApi(
    private val apiKey: String,
    private val fallbackUrl: String,
    private val gistRawUrl: String,
) {
    @Volatile private var baseUrl: String? = fallbackUrl.ifBlank { null }

    fun analyze(redactedText: String, history: List<Turn>): Analysis {
        val body = JSONObject()
            .put("text", redactedText)
            .put("history", JSONArray().apply {
                history.takeLast(12).forEach { put(JSONObject().put("role", it.role).put("text", it.text)) }
            })
        val first = baseUrl ?: discover() ?: throw ApiException("no server URL")
        return try {
            parse(post(first, body))
        } catch (e: ApiException) {
            if (e.unauthorized) throw e
            retryOnNewUrl(first, body)
        } catch (e: IOException) {
            retryOnNewUrl(first, body)
        }
    }

    private fun retryOnNewUrl(tried: String, body: JSONObject): Analysis {
        val fresh = discover() ?: throw ApiException("server unreachable")
        if (fresh == tried) throw ApiException("server unreachable")
        return parse(post(fresh, body))
    }

    /** Reads the current URL from the gist's raw link (no rate limit), skipping its 5-minute cache. */
    fun discover(): String? {
        if (gistRawUrl.isBlank()) return null
        return try {
            val conn = (URL("$gistRawUrl?t=${System.currentTimeMillis() / 1000}").openConnection() as HttpURLConnection).apply {
                connectTimeout = 8000; readTimeout = 8000
            }
            val url = conn.inputStream.bufferedReader().use { JSONObject(it.readText()).optString("url") }
            url.takeIf { it.startsWith("https://") }?.trimEnd('/')?.also { baseUrl = it }
        } catch (e: Exception) {
            null
        }
    }

    private fun post(base: String, body: JSONObject): String {
        val conn = (URL("$base/v1/analyze").openConnection() as HttpURLConnection).apply {
            requestMethod = "POST"
            connectTimeout = 10_000
            readTimeout = 40_000
            doOutput = true
            setRequestProperty("Authorization", "Bearer $apiKey")
            setRequestProperty("Content-Type", "application/json; charset=utf-8")
        }
        conn.outputStream.use { it.write(body.toString().toByteArray(Charsets.UTF_8)) }
        val code = conn.responseCode
        if (code == 401 || code == 403) throw ApiException("unauthorized", unauthorized = true)
        if (code != 200) throw ApiException("HTTP $code")
        return conn.inputStream.bufferedReader(Charsets.UTF_8).use { it.readText() }
    }

    companion object {
        /** Parses AnalyzeOut. Unknown support types are skipped; urgent drops any AI text. */
        fun parse(json: String): Analysis {
            val o = JSONObject(json)
            val risk = o.optString("risk", "unknown")
            val urgent = o.optBoolean("urgent", true) || risk != "none"
            if (urgent) return Analysis(true, risk, null, false, emptyList())
            val list = o.optJSONArray("suggestions") ?: JSONArray()
            val options = (0 until list.length()).mapNotNull { i ->
                val s = list.optJSONObject(i) ?: return@mapNotNull null
                val type = s.optString("type")
                if (type !in Texts.TYPE_LABELS) return@mapNotNull null
                Option(type, s.optString("why"), s.optString("draft")).takeIf { it.why.isNotBlank() && it.draft.isNotBlank() }
            }
            return Analysis(
                urgent = false,
                risk = risk,
                reflection = o.optString("reflection").ifBlank { null },
                supportReady = o.optBoolean("support_ready", true),
                suggestions = options.take(3),
            )
        }
    }
}
