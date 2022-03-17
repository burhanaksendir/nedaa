import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(SharedPreferences sharedPerf) : _sharedPref = sharedPerf;

  final SharedPreferences _sharedPref;

  getString(String key) {
    return _sharedPref.getString(key);
  }

  setString(String key, String value) async {
    await _sharedPref.setString(key, value);
  }
}
