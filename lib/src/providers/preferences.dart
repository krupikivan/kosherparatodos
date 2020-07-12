import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instancia = new Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  Preferences._internal();

  SharedPreferences _prefs;

  void initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  bool get needData {
    return _prefs.getBool('need_data') ?? false;
  }

  set needData(bool value) {
    _prefs.setBool('need_data', value);
  }
}
