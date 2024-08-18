import 'package:shared_preferences/shared_preferences.dart';

Future<bool> verifyToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return (sharedPreferences.getString('accessToken') != null) ? true : false;
}
