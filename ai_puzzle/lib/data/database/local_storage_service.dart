import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String keyXP = 'player_total_xp';
  static const String keyStreak = 'daily_streak';
  static const String keyHighestStreak = 'highest_streak';
  static const String keyLastPlayedDate = 'last_played_date';
  static const String keyOnboardingDone = 'onboarding_completed';
  static const String keyThemeMode = 'app_theme_mode';
  static const String keySolvedList = 'solved_puzzle_ids';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  bool get isOnboardingCompleted => _prefs.getBool(keyOnboardingDone) ?? false;
  Future<void> setOnboardingCompleted(bool val) => _prefs.setBool(keyOnboardingDone, val);

  int get totalXP => _prefs.getInt(keyXP) ?? 0;
  Future<void> addXP(int amount) async {
    final current = totalXP;
    await _prefs.setInt(keyXP, current + amount);
  }

  int get streak => _prefs.getInt(keyStreak) ?? 0;
  int get highestStreak => _prefs.getInt(keyHighestStreak) ?? 0;

  Future<void> recordDailyPlay() async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastDate = _prefs.getString(keyLastPlayedDate);

    if (lastDate == null) {
      await _prefs.setInt(keyStreak, 1);
      await _prefs.setInt(keyHighestStreak, 1);
      await _prefs.setString(keyLastPlayedDate, todayStr);
      return;
    }

    if (lastDate == todayStr) {
      return; // Already played today
    }

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr = '${yesterday.year}-${yesterday.month}-${yesterday.day}';

    if (lastDate == yesterdayStr) {
      final newStreak = streak + 1;
      await _prefs.setInt(keyStreak, newStreak);
      if (newStreak > highestStreak) {
        await _prefs.setInt(keyHighestStreak, newStreak);
      }
    } else {
      // Streak broken
      await _prefs.setInt(keyStreak, 1);
    }
    await _prefs.setString(keyLastPlayedDate, todayStr);
  }

  List<String> get solvedPuzzleIds => _prefs.getStringList(keySolvedList) ?? [];
  Future<void> markPuzzleSolved(String puzzleId) async {
    final list = List<String>.from(solvedPuzzleIds);
    if (!list.contains(puzzleId)) {
      list.add(puzzleId);
      await _prefs.setStringList(keySolvedList, list);
    }
  }

  String get themeMode => _prefs.getString(keyThemeMode) ?? 'system';
  Future<void> setThemeMode(String mode) => _prefs.setString(keyThemeMode, mode);

  Future<void> resetProgress() async {
    await _prefs.setInt(keyXP, 0);
    await _prefs.setInt(keyStreak, 0);
    await _prefs.setStringList(keySolvedList, []);
  }
}
