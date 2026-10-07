package com.example.khutwa_app

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import ly.manara.khutwa.privacy.IdentifierType
import ly.manara.khutwa.privacy.RedactionResult
import ly.manara.khutwa.privacy.Redactor
import ly.manara.khutwa.privacy.Span

/**
 * Exposes the Kotlin [Redactor] to Flutter. The Dart side is
 * lib/features/privacy/data/repositories/channel_redactor.dart.
 *
 * Messages: a result is `{"original": String, "spans": [{"start", "end", "type"}]}`
 * where `type` is the [IdentifierType] name.
 */
class RedactorChannel(messenger: BinaryMessenger, private val redactor: Redactor) {
    init {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, reply ->
            try {
                when (call.method) {
                    "redact" -> reply.success(redactor.redact(call.argument<String>("text")!!).toMap())
                    "toggle" -> reply.success(
                        redactor.toggle(
                            call.resultArgument(),
                            call.argument<Int>("start")!!,
                            call.argument<Int>("end")!!,
                        ).toMap(),
                    )
                    else -> reply.notImplemented()
                }
            } catch (e: Exception) {
                reply.error("redaction_failed", e.message, null)
            }
        }
    }

    private fun MethodCall.resultArgument(): RedactionResult {
        @Suppress("UNCHECKED_CAST")
        val spans = argument<List<Map<String, Any>>>("spans")!!.map {
            Span(it["start"] as Int, it["end"] as Int, IdentifierType.valueOf(it["type"] as String))
        }
        return RedactionResult(argument<String>("original")!!, spans)
    }

    private fun RedactionResult.toMap(): Map<String, Any> = mapOf(
        "original" to original,
        "spans" to spans.map { mapOf("start" to it.start, "end" to it.end, "type" to it.type.name) },
    )

    companion object {
        const val NAME = "ly.manara.khutwa/redactor"
    }
}
