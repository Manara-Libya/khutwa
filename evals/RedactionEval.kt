// Used by evals/run.py: reads one message per line on stdin, prints the redacted text per line.
import ly.manara.khutwa.privacy.LibyanRedactor

fun main() {
    val redactor = LibyanRedactor()
    generateSequence(::readLine).forEach { println(redactor.redact(it).redacted) }
}
