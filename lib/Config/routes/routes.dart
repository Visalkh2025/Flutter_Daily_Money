import 'package:daily_money/Bindings/add_transaction_binding.dart';
import 'package:daily_money/Bindings/auth_binding.dart';
import 'package:daily_money/Bindings/home_binding.dart';
import 'package:daily_money/Bindings/main_binding.dart';
import 'package:daily_money/Bindings/statistics_binding.dart';
import 'package:daily_money/View/Home/Screens/add_transaction_screen.dart';
import 'package:daily_money/View/Home/Screens/home_screen.dart';
import 'package:daily_money/View/Main/splash_screen.dart';
import 'package:daily_money/View/Profile/main/profile_screen.dart';
import 'package:daily_money/View/Statistic/statistics_screen.dart';
import 'package:daily_money/View/Wallet/wallet_screen.dart';
import 'package:daily_money/View/auth/Screens/signin_screen.dart';
import 'package:daily_money/View/auth/Screens/signup_screen.dart';
import 'package:daily_money/View/Main/main_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const wallet = '/wallet';
  static const splash = '/splash';
  static const main = '/main';
  static const signUp = '/signup';
  static const signIn = '/signin';
  static const home = '/home';
  static const profile = '/profile';
  static const addTransaction = '/add_transaction';
  static const statistic = '/statistic';

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signUp, page: () => SignupScreen(), binding: AuthBinding()),
    GetPage(name: signIn, page: () => SigninScreen(), binding: AuthBinding()),
    GetPage(name: main, page: () => const MainScreen(), binding: MainBinding()),
    GetPage(name: home, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(
      name: addTransaction,
      page: () => AddTransactionScreen(),
      binding: AddTransactionBinding(),
    ),
    GetPage(
      name: statistic,
      page: () => StatisticsScreen(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: wallet,
      page: () => WalletScreen(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      //binding: StatisticsBinding(),
    ),
  ];
}
