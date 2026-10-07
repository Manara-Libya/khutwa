package ly.manara.khutwa.data

import org.json.JSONArray
import org.json.JSONObject

/**
 * A2UI v0.8 (https://a2ui.org/specification/v0.8-a2ui/): the server describes a surface with standard-catalog
 * components and the app renders it. Only the components Khutwa uses are supported; anything else is skipped.
 * Every text passes through [transform] first (the phone restores real names there).
 */
object A2ui {
    sealed interface Component
    data class Text(val text: String, val hint: String) : Component
    data class Button(val child: String, val primary: Boolean, val action: String, val textPath: String?) : Component
    data class Card(val child: String) : Component
    data class Column(val children: List<String>) : Component
    data class Row(val children: List<String>) : Component
    data class TextField(val label: String, val path: String) : Component

    data class Surface(
        val id: String,
        val root: String,
        val components: Map<String, Component>,
        /** The data model, flattened to paths ("/drafts/opt0" -> text). */
        val data: Map<String, String>,
    )

    /** Builds the surface from a list of A2UI messages; null until a beginRendering arrives. */
    fun parse(messages: JSONArray, transform: (String) -> String = { it }): Surface? {
        var id: String? = null
        var root: String? = null
        val components = linkedMapOf<String, Component>()
        val data = linkedMapOf<String, String>()
        for (i in 0 until messages.length()) {
            val m = messages.optJSONObject(i) ?: continue
            m.optJSONObject("surfaceUpdate")?.let { u ->
                id = u.optString("surfaceId")
                val list = u.optJSONArray("components") ?: JSONArray()
                for (k in 0 until list.length()) {
                    val c = list.optJSONObject(k) ?: continue
                    component(c.optJSONObject("component"), transform)?.let { components[c.optString("id")] = it }
                }
            }
            m.optJSONObject("dataModelUpdate")?.let { u ->
                val base = u.optString("path", "").trimEnd('/')
                val contents = u.optJSONArray("contents") ?: JSONArray()
                for (k in 0 until contents.length()) {
                    val e = contents.optJSONObject(k) ?: continue
                    if (e.has("valueString")) data["$base/${e.optString("key")}"] = transform(e.optString("valueString"))
                }
            }
            m.optJSONObject("beginRendering")?.let { root = it.optString("root") }
        }
        val r = root ?: return null
        if (r !in components) return null
        return Surface(id ?: "surface", r, components, data)
    }

    private fun bound(o: JSONObject?, transform: (String) -> String): String =
        o?.optString("literalString")?.takeIf { it.isNotEmpty() }?.let(transform) ?: ""

    private fun list(o: JSONObject?): List<String> {
        val a = o?.optJSONObject("children")?.optJSONArray("explicitList") ?: return emptyList()
        return (0 until a.length()).map { a.optString(it) }
    }

    private fun component(c: JSONObject?, transform: (String) -> String): Component? {
        if (c == null || c.length() != 1) return null
        val kind = c.keys().next()
        val p = c.optJSONObject(kind) ?: return null
        return when (kind) {
            "Text" -> Text(bound(p.optJSONObject("text"), transform), p.optString("usageHint", "body"))
            "Button" -> {
                val action = p.optJSONObject("action") ?: return null
                val ctx = action.optJSONArray("context")
                val path = (0 until (ctx?.length() ?: 0)).firstNotNullOfOrNull { i ->
                    ctx!!.optJSONObject(i)?.takeIf { it.optString("key") == "text" }?.optJSONObject("value")?.optString("path")
                }
                Button(p.optString("child"), p.optBoolean("primary", false), action.optString("name"), path)
            }
            "Card" -> Card(p.optString("child"))
            "Column" -> Column(list(p))
            "Row" -> Row(list(p))
            "TextField" -> TextField(bound(p.optJSONObject("label"), transform), p.optJSONObject("text")?.optString("path") ?: return null)
            else -> null
        }
    }

    /** The same surface, built on the phone from fixed options when the server has none. */
    fun local(options: List<Option>): Surface {
        val comps = linkedMapOf<String, Component>(
            "title" to Text(Texts.OPTIONS_TITLE, "h3"),
            "subtitle" to Text(Texts.OPTIONS_SUB, "caption"),
        )
        val data = linkedMapOf<String, String>()
        val cards = options.mapIndexed { i, o ->
            val p = "opt$i"
            comps["$p-label"] = Text(Texts.TYPE_LABELS[o.type] ?: o.type, "h4")
            comps["$p-why"] = Text(o.why, "body")
            comps["$p-draft"] = TextField("رسالتك", "/drafts/$p")
            comps["$p-share-label"] = Text(Texts.DRAFT_SHARE, "body")
            comps["$p-copy-label"] = Text("انسخ", "body")
            comps["$p-share"] = Button("$p-share-label", true, "khutwa.share", "/drafts/$p")
            comps["$p-copy"] = Button("$p-copy-label", false, "khutwa.copy", "/drafts/$p")
            comps["$p-buttons"] = Row(listOf("$p-share", "$p-copy"))
            comps["$p-body"] = Column(listOf("$p-label", "$p-why", "$p-draft", "$p-buttons"))
            comps["$p-card"] = Card("$p-body")
            data["/drafts/$p"] = o.draft
            "$p-card"
        }
        comps["root"] = Column(listOf("title", "subtitle") + cards)
        return Surface("support-local", "root", comps, data)
    }
}
