package ly.manara.khutwa.data

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/** One saved line: [text] as shown on the phone, [wire] as the server saw it (redacted), [a2ui] the options surface. */
data class SavedLine(val mine: Boolean, val text: String, val wire: String? = null, val a2ui: String? = null)

/** A saved chat, with the placeholder -> real word mapping so it can be continued with the same placeholders. */
data class SavedChat(
    val id: Long,
    val startedAt: Long,
    val updatedAt: Long,
    val lines: List<SavedLine>,
    val names: Map<String, String>,
)

/**
 * Saved chats and the notes Khutwa keeps across chats, only for users who turn this on in settings.
 * Everything lives in one file in the app's no-backup folder, encrypted with an AES key that the Android
 * Keystore holds and never lets out of the phone. Turning it off deletes the file and the key.
 */
class ChatStore(context: Context) {
    private val file = File(context.noBackupFilesDir, "chats.bin")

    var chats: List<SavedChat> = emptyList()
        private set
    var memory: String = ""
        private set

    @Synchronized fun load() {
        val (c, m) = runCatching { decode(String(decrypt(file.readBytes()), Charsets.UTF_8)) }.getOrDefault(emptyList<SavedChat>() to "")
        chats = c; memory = m
    }

    @Synchronized fun put(chat: SavedChat) {
        chats = listOf(chat) + chats.filter { it.id != chat.id }
        write()
    }

    @Synchronized fun delete(id: Long) {
        chats = chats.filter { it.id != id }
        write()
    }

    @Synchronized fun setMemory(text: String) {
        memory = text
        write()
    }

    /** Deletes every saved chat, the notes, the file and the key. */
    @Synchronized fun clear() {
        chats = emptyList(); memory = ""
        file.delete()
        runCatching { keyStore().deleteEntry(ALIAS) }
    }

    private fun write() {
        if (chats.isEmpty() && memory.isBlank()) { file.delete(); return }
        runCatching {
            val tmp = File(file.parentFile, file.name + ".tmp")
            tmp.writeBytes(encrypt(encode().toByteArray(Charsets.UTF_8)))
            tmp.renameTo(file)
        }
    }

    private fun encode(): String = JSONObject()
        .put("memory", memory)
        .put("chats", JSONArray().apply {
            chats.forEach { c ->
                put(JSONObject().put("id", c.id).put("startedAt", c.startedAt).put("updatedAt", c.updatedAt)
                    .put("names", JSONObject(c.names))
                    .put("lines", JSONArray().apply {
                        c.lines.forEach { l ->
                            put(JSONObject().put("mine", l.mine).put("text", l.text).putOpt("wire", l.wire).putOpt("a2ui", l.a2ui))
                        }
                    }))
            }
        }).toString()

    private fun decode(json: String): Pair<List<SavedChat>, String> {
        val o = JSONObject(json)
        val list = o.optJSONArray("chats") ?: JSONArray()
        val chats = (0 until list.length()).mapNotNull { i ->
            val c = list.optJSONObject(i) ?: return@mapNotNull null
            val names = c.optJSONObject("names")?.let { n -> n.keys().asSequence().associateWith { n.optString(it) } }.orEmpty()
            val ls = c.optJSONArray("lines") ?: JSONArray()
            val lines = (0 until ls.length()).mapNotNull { k ->
                val l = ls.optJSONObject(k) ?: return@mapNotNull null
                SavedLine(l.optBoolean("mine"), l.optString("text"),
                    l.optString("wire").ifEmpty { null }, l.optString("a2ui").ifEmpty { null })
            }
            SavedChat(c.optLong("id"), c.optLong("startedAt"), c.optLong("updatedAt"), lines, names)
        }
        return chats to o.optString("memory")
    }

    // --- encryption: AES-256-GCM, key in the Android Keystore; the file holds the 12-byte IV, then the ciphertext ---
    private fun keyStore() = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }

    private fun key(): SecretKey {
        (keyStore().getKey(ALIAS, null) as? SecretKey)?.let { return it }
        val gen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        gen.init(KeyGenParameterSpec.Builder(ALIAS, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .build())
        return gen.generateKey()
    }

    private fun encrypt(plain: ByteArray): ByteArray {
        val cipher = Cipher.getInstance(TRANSFORMATION).apply { init(Cipher.ENCRYPT_MODE, key()) }
        return cipher.iv + cipher.doFinal(plain)
    }

    private fun decrypt(data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, data, 0, 12))
        return cipher.doFinal(data, 12, data.size - 12)
    }

    private companion object {
        const val ALIAS = "khutwa_chats"
        const val TRANSFORMATION = "AES/GCM/NoPadding"
    }
}
