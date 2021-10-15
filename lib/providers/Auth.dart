import 'package:flutter/foundation.dart';

class Auth extends ChangeNotifier {
  static String? token;
  static bool? authenticated = false;
  static bool? reAuthenticate = false;
}
