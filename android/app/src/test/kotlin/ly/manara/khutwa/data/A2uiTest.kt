package ly.manara.khutwa.data

import org.json.JSONArray
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** The JSON below is exactly what the backend's a2ui.support_surface() returns (copied from the server). */
class A2uiTest {
    private val sample = """[{"surfaceUpdate": {"surfaceId": "support-test", "components": [{"id": "title", "component": {"Text": {"text": {"literalString": "ناس ممكن تحكي معاهم"}, "usageHint": "h3"}}}, {"id": "subtitle", "component": {"Text": {"text": {"literalString": "اختار اللي تحس روحك مرتاح معاه، عدّل الرسالة، وابعتها بنفسك."}, "usageHint": "caption"}}}, {"id": "opt0-label", "component": {"Text": {"text": {"literalString": "صاحب تثق فيه"}, "usageHint": "h4"}}}, {"id": "opt0-why", "component": {"Text": {"text": {"literalString": "صاحبك [اسم1] يسمعك."}, "usageHint": "body"}}}, {"id": "opt0-draft", "component": {"TextField": {"label": {"literalString": "رسالتك"}, "text": {"path": "/drafts/opt0"}, "textFieldType": "longText"}}}, {"id": "opt0-share-label", "component": {"Text": {"text": {"literalString": "ابعتها بنفسك"}}}}, {"id": "opt0-copy-label", "component": {"Text": {"text": {"literalString": "انسخ"}}}}, {"id": "opt0-share", "component": {"Button": {"child": "opt0-share-label", "primary": true, "action": {"name": "khutwa.share", "context": [{"key": "text", "value": {"path": "/drafts/opt0"}}]}}}}, {"id": "opt0-copy", "component": {"Button": {"child": "opt0-copy-label", "primary": false, "action": {"name": "khutwa.copy", "context": [{"key": "text", "value": {"path": "/drafts/opt0"}}]}}}}, {"id": "opt0-buttons", "component": {"Row": {"children": {"explicitList": ["opt0-share", "opt0-copy"]}}}}, {"id": "opt0-body", "component": {"Column": {"children": {"explicitList": ["opt0-label", "opt0-why", "opt0-draft", "opt0-buttons"]}}}}, {"id": "opt0-card", "component": {"Card": {"child": "opt0-body"}}}, {"id": "opt1-label", "component": {"Text": {"text": {"literalString": "أستاذ أو مرشد"}, "usageHint": "h4"}}}, {"id": "opt1-why", "component": {"Text": {"text": {"literalString": "يقدر يساعدك."}, "usageHint": "body"}}}, {"id": "opt1-draft", "component": {"TextField": {"label": {"literalString": "رسالتك"}, "text": {"path": "/drafts/opt1"}, "textFieldType": "longText"}}}, {"id": "opt1-share-label", "component": {"Text": {"text": {"literalString": "ابعتها بنفسك"}}}}, {"id": "opt1-copy-label", "component": {"Text": {"text": {"literalString": "انسخ"}}}}, {"id": "opt1-share", "component": {"Button": {"child": "opt1-share-label", "primary": true, "action": {"name": "khutwa.share", "context": [{"key": "text", "value": {"path": "/drafts/opt1"}}]}}}}, {"id": "opt1-copy", "component": {"Button": {"child": "opt1-copy-label", "primary": false, "action": {"name": "khutwa.copy", "context": [{"key": "text", "value": {"path": "/drafts/opt1"}}]}}}}, {"id": "opt1-buttons", "component": {"Row": {"children": {"explicitList": ["opt1-share", "opt1-copy"]}}}}, {"id": "opt1-body", "component": {"Column": {"children": {"explicitList": ["opt1-label", "opt1-why", "opt1-draft", "opt1-buttons"]}}}}, {"id": "opt1-card", "component": {"Card": {"child": "opt1-body"}}}, {"id": "root", "component": {"Column": {"children": {"explicitList": ["title", "subtitle", "opt0-card", "opt1-card"]}}}}]}}, {"dataModelUpdate": {"surfaceId": "support-test", "path": "/drafts", "contents": [{"key": "opt0", "valueString": "يا [اسم1]، فاضي نحكوا شوية؟"}, {"key": "opt1", "valueString": "يا استاذ، نبي نصيحتك."}]}}, {"beginRendering": {"surfaceId": "support-test", "catalogId": "https://a2ui.org/specification/v0_8/standard_catalog_definition.json", "root": "root"}}]"""

    @Test fun parsesTheServerSurface() {
        val s = A2ui.parse(JSONArray(sample))
        assertNotNull(s); s!!
        assertEquals("root", s.root)
        val root = s.components["root"] as A2ui.Column
        assertEquals(listOf("title", "subtitle", "opt0-card", "opt1-card"), root.children)
        val field = s.components["opt0-draft"] as A2ui.TextField
        assertEquals("/drafts/opt0", field.path)
        val share = s.components["opt0-share"] as A2ui.Button
        assertEquals("khutwa.share", share.action); assertEquals("/drafts/opt0", share.textPath); assertTrue(share.primary)
        assertEquals("يا [اسم1]، فاضي نحكوا شوية؟", s.data["/drafts/opt0"])
    }

    @Test fun restoresNamesInTextsAndData() {
        val s = A2ui.parse(JSONArray(sample)) { it.replace("[اسم1]", "سند") }!!
        assertEquals("صاحبك سند يسمعك.", (s.components["opt0-why"] as A2ui.Text).text)
        assertEquals("يا سند، فاضي نحكوا شوية؟", s.data["/drafts/opt0"])
    }

    @Test fun noSurfaceWithoutBeginRendering() {
        val partial = JSONArray(sample).apply { remove(2) }
        assertNull(A2ui.parse(partial))
    }

    @Test fun unknownComponentsAreSkipped() {
        val json = """[{"surfaceUpdate":{"surfaceId":"s","components":[{"id":"root","component":{"Column":{"children":{"explicitList":["x","v"]}}}},{"id":"x","component":{"Text":{"text":{"literalString":"hi"}}}},{"id":"v","component":{"Video":{"url":{"literalString":"http://x"}}}}]}},{"beginRendering":{"surfaceId":"s","root":"root"}}]"""
        val s = A2ui.parse(JSONArray(json))!!
        assertTrue("x" in s.components); assertTrue("v" !in s.components)
    }

    @Test fun localFallbackHasTheSameShape() {
        val s = A2ui.local(Texts.GENERIC_OPTIONS)
        assertEquals(3, (s.components["root"] as A2ui.Column).children.count { it.endsWith("-card") })
        assertEquals(Texts.GENERIC_OPTIONS[0].draft, s.data["/drafts/opt0"])
    }
}
