import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String isToken = "isToken";

  // Simpan status login
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  // Simpan token JWT setelah login sukses
  static saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(isToken, value);
  }

  // Ambil status login
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  // Ambil token JWT
  static getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isToken);
  }

  // Hapus status login
  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }

  // Hapus token pada saat logout
  static removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isToken);
  }
}
