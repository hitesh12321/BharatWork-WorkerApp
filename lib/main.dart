// main.dart

import 'dart:developer' as console;

import 'package:bharatwork/firebase_options.dart';
import 'package:bharatwork/presentation/screens/MainPages/main_page.dart';

// import 'package:bharatwork/presentation/screens/on_boarding/choose_language.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using your firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  console.log(
    level: 0,
    "✅ /////////////////// Firebase connected to project: ${DefaultFirebaseOptions.currentPlatform.projectId}",
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // CommonFunctions.lightStatusBarColor(AppColors.lightPink);

  // Run your actual app with Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bharat Work',
      home: MainPage(),
    );
  }
}
