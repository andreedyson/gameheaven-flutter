import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String?>> getUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username') ?? '';
  String? fullname = prefs.getString('full_name') ?? '';
  String? email = prefs.getString('email') ?? '';
  String? role = prefs.getString('role') ?? '';

  var userData = {
    "username": username,
    "full_name": fullname,
    "email": email,
    "role": role
  };

  return userData;
}

Future<void> clearUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('full_name');
  await prefs.remove('email');
  await prefs.remove('role');
}
