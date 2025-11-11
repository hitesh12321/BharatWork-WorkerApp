import 'package:bharatwork/firebase_options.dart';
import 'package:bharatwork/presentation/screens/on_boarding/choose_language.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> testPhoneAuth() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseAuth auth = FirebaseAuth.instance;

  print("🚀 Starting Firebase Phone Auth test...");

  await auth.verifyPhoneNumber(
    phoneNumber: '+19193386615', // use Firebase test number (see below)
    timeout: const Duration(seconds: 60),
    verificationCompleted: (PhoneAuthCredential credential) async {
      print("✅ Auto verified! Signing in...");
      final userCredential = await auth.signInWithCredential(credential);
      print("Signed in as: ${userCredential.user?.phoneNumber}");
    },
    verificationFailed: (FirebaseAuthException e) {
      print("❌ Verification failed: ${e.message}");
    },
    codeSent: (String verificationId, int? resendToken) async{
      print("📩 Code sent! Verification ID: $verificationId");
      // You can manually verify like this:
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: "123456",
      );
      await auth.signInWithCredential(credential);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print("⌛ Auto retrieval timeout: $verificationId");
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await testPhoneAuth();
  // await Firebase.initializeApp();
  // runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChooseLanguage());
  }
}
