import 'package:bharatwork/models/onboard.dart';
import 'package:bharatwork/presentation/screens/auth/Sign_up/signup_otp_page.dart';
import 'package:bharatwork/presentation/screens/auth/Sign_up/signup_with_number.dart';
import 'package:bharatwork/presentation/screens/auth/login/login_otp_page.dart';
import 'package:bharatwork/presentation/screens/auth/login/login_with_number.dart';
import 'package:bharatwork/presentation/screens/auth/welcomepage.dart';
import 'package:bharatwork/presentation/screens/home/home_page.dart';
import 'package:bharatwork/presentation/screens/on_boarding/choose_language.dart';
import 'package:bharatwork/presentation/screens/on_boarding/on_boarding.dart';
import 'package:bharatwork/presentation/screens/register/document_details_page.dart';
import 'package:bharatwork/presentation/screens/register/occupation_details_page.dart';
import 'package:bharatwork/presentation/screens/register/personal_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ChooseLanguage()),
    GoRoute(
      path: '/boarding',
      builder: (context, state) => const OnBoardingPage(),
    ),
    GoRoute(
      path: "/login_page",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/signup_page",
      builder: (context, state) => const SignupWithNumber(),
    ),
    GoRoute(path: "/home_page", builder: (context, state) => const HomePage()),
    GoRoute(path: "/welcome", builder: (context, state) => const Welcomepage()),
    GoRoute(
      path: "/login_otp_page",
      builder: (context, state) => const LoginOtpPage(),
    ),
    GoRoute(
      path: "/signup_otp_page",
      builder: (context, state) => const SignupOtpPage(),
    ),
    GoRoute(
      path: "/personal_details_page",
      builder: (context, state) => const PersonalDetailsPage(),
    ),
    GoRoute(
      path: "/document_details_page",
      builder: (context, state) => const DocumentDetailsPage(),
    ),
    GoRoute(
      path: "/occupation_details_page",
      builder: (context, state) => const OccupationDetailsPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
