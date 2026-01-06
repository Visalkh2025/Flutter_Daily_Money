import 'package:daily_money/Bindings/add_transaction_binding.dart';
import 'package:daily_money/Bindings/auth_binding.dart';
import 'package:daily_money/Bindings/home_binding.dart';
import 'package:daily_money/View/Home/Screens/add_transaction_screen.dart';
import 'package:daily_money/View/Home/Screens/home_screen.dart';
import 'package:daily_money/View/auth/Screens/signin_screen.dart';
import 'package:daily_money/View/auth/Screens/signup_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const dashboard = '/dashboard';
  static const main = '/main';
  static const signUp = '/signup';
  static const signIn = '/signin';
  static const home = '/home';
  static const profile = '/profile';
  static const addTransaction = '/add_transaction';

  static final pages = [
    GetPage(name: signUp, page: () => SignupScreen(), binding: AuthBinding()),
    GetPage(name: signIn, page: () => SigninScreen(), binding: AuthBinding()),
    GetPage(name: home, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(
      name: addTransaction,
      page: () => AddTransactionScreen(),
      binding: AddTransactionBinding(),
    ),
  ];
}
