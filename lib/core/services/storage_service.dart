import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/model/user_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _authKey = 'is_logged_in';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Save user model to storage
  Future<void> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
    await _prefs.setBool(_authKey, true);
  }

  /// Retrieve user model from storage
  UserModel? getUser() {
    final String? userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_authKey) ?? false;
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _prefs.remove(_userKey);
    await _prefs.setBool(_authKey, false);
  }
}
