import 'package:bharatwork/features/users/models/user_model.dart';
import 'package:bharatwork/firebase/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import '../controller/user_controller.dart';
import '../repository/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(FirebaseProviders.firestoreProvider);
  return UserRepository(firestore);
  
});

final userControllerProvider =
    StateNotifierProvider<UserController, bool>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserController(repository: repo, ref: ref);
});

// Example state provider for currently loaded users
final userListProvider = StateProvider<List<AppUser>>((ref) => []);

// holds selected user
final activeUserProvider = StateProvider<AppUser?>((ref) => null);

// active user (single)

// last doc for pagination
final lastUserDocProvider = StateProvider<DocumentSnapshot?>((ref) => null);

// to track if more pages are available
final hasMoreUsersProvider = StateProvider<bool>((ref) => true);


