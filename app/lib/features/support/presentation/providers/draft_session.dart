/// Actions available on a draft. There is deliberately no "send": Khutwa
/// never sends anything on the user's behalf.
abstract interface class DraftSession {
  Future<void> copy(String text);
}
