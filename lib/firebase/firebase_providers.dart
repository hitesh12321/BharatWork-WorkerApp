import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod/riverpod.dart';

class FirebaseProviders {
  // Firebase App
  static final firebaseAppProvider = Provider<FirebaseApp>((ref) {
    return Firebase.app();
  });

  // Firestore
  static final firestoreProvider = Provider<FirebaseFirestore>((ref) {
    return FirebaseFirestore.instance;
  });

  // Firebase Auth
  static final authProvider = Provider<FirebaseAuth>((ref) {
    return FirebaseAuth.instance;
  });

  // Firebase Storage
  // static final storageProvider = Provider<FirebaseStorage>((ref) {
  //   return FirebaseStorage.instance;
  // });

  // // Cloud Functions (optional)
  // static final functionsProvider = Provider<FirebaseFunctions>((ref) {
  //   return FirebaseFunctions.instance;
  // });

  // // Analytics (optional)
  // static final analyticsProvider = Provider<FirebaseAnalytics>((ref) {
  //   return FirebaseAnalytics.instance;
  // });

  // // Cloud Messaging (optional)
  // static final messagingProvider = Provider<FirebaseMessaging>((ref) {
  //   return FirebaseMessaging.instance;
  // });
}
