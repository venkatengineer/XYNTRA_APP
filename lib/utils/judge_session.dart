class JudgeSession {
  static String? judgeId;
  static String? judgeName;

  static bool get isLoggedIn => judgeId != null;

  static void logout() {
    judgeId = null;
    judgeName = null;
  }
}
