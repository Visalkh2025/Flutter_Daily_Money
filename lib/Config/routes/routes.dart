
import 'package:daily_money/View/auth/signin_screen.dart';
import 'package:daily_money/View/auth/signup_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const dashboard = '/dashboard';
  static const main = '/main';
  static const signUp = '/signup';
  static const signIn = '/signin';
  static const home = '/home';
  static const profile = '/profile';

  static final pages = [
    GetPage(name: signUp, page: () => SignupScreen()),
    GetPage(name: signIn, page: () => SigninScreen()),
   
    
  ];
}
