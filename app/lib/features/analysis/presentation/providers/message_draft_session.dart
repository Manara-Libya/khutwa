/// Actions on a draft message. Deliberately no "send": the user sends it
/// themselves (#54).
abstract interface class MessageDraftSession {
  Future<void> copy(String text);
}
