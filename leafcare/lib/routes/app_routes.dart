import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafcare/data/repositories/auth_repository.dart';
import 'package:leafcare/presentation/bloc/auth/auth_bloc.dart';
import 'package:leafcare/presentation/bloc/history/history_bloc.dart';
import 'package:leafcare/presentation/bloc/profile/profile_bloc.dart';
import 'package:leafcare/presentation/bloc/scan/scan_bloc.dart';
import 'package:leafcare/presentation/screens/disease_info_screen.dart';
import 'package:leafcare/presentation/screens/forgot_password_screen.dart';
import 'package:leafcare/presentation/screens/home_screen.dart';
import 'package:leafcare/presentation/screens/login_screen.dart';
import 'package:leafcare/presentation/screens/profile_screen.dart';
import 'package:leafcare/presentation/screens/onboarding_screen.dart';
import 'package:leafcare/presentation/screens/history_screen.dart';
import 'package:leafcare/presentation/screens/report_screen.dart';
import 'package:leafcare/presentation/screens/result_screen.dart';
import 'package:leafcare/presentation/screens/scan_screen.dart';
import 'package:leafcare/presentation/screens/signup_screen.dart';
import 'package:leafcare/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String onboarding = '/onboarding';
  static const String history = '/history';
  static const String scan = '/scan';
  static const String splash = '/splash';
  static const String result = '/result';
  static const String report = '/report';
  static const String signup = '/signup';
  static const String diseaseInfo = '/diseaseInfo';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case scan:
        return MaterialPageRoute(builder: (_) => const ScanScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case result:
        // Ensure the required arguments are passed
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ReportScreen(
              disease: args['disease'],
              prediction: args['prediction'],
              scanImage: args['scanImage'],
            ),
          );
        }
        return _errorRoute();

      case report:
        // Ensure the required arguments are passed
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ResultScreen(
              disease: args['disease'],
              prediction: args['prediction'],
              scanImage: args['scanImage'],
            ),
          );
        }
        return _errorRoute();

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case diseaseInfo:
        return MaterialPageRoute(builder: (_) => const DiseaseInfoScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found")),
      ),
    );
  }

  static List allproviders() => [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(create: (context) => ScanBloc()),
        BlocProvider(create: (context) => HistoryBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
      ];
}
