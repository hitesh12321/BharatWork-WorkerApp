import 'package:bharatwork/core/utils/utils.dart';
import 'package:bharatwork/features/users/models/user_model.dart';
import 'package:bharatwork/features/users/providers/user_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/user_repository.dart';

// ─────────────────────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────────────────────
final userControllerProvider =
    StateNotifierProvider<UserController, bool>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserController(repository: repo, ref: ref);
});

// ─────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────
class UserController extends StateNotifier<bool> {
  final UserRepository _repository;
  final Ref _ref;

  UserController({
    required UserRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(false);

  // ============================================================
  // CREATE USER
  // ============================================================
  Future<void> createUser(BuildContext context, AppUser user) async {
    state = true;

    final result = await _repository.createUser(user);
    state = false;

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userListProvider.notifier).state = [
          r,
          ..._ref.read(userListProvider),
        ];
        showSnackBar(context, "User Created");
      },
    );
  }

  // ============================================================
  // GET A SINGLE USER
  // ============================================================
  Future<void> fetchUser(BuildContext context, String id) async {
    state = true;

    final result = await _repository.getUser(id);
    state = false;

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) => _ref.read(activeUserProvider.notifier).state = r,
    );
  }

  // ============================================================
  // GET USERS WITH FILTERS & PAGINATION
  // ============================================================
  Future<void> fetchUsers({
    required BuildContext context,
    int limit = 20,
    bool reset = false,
    Map<String, dynamic>? filters,
    String orderBy = "created_at",
    bool descending = true,
  }) async {
    state = true;

    // Pagination: if reset, start fresh from page 1
    DocumentSnapshot? startAfter;
    if (!reset) {
      startAfter = _ref.read(lastUserDocProvider);
    }

    final result = await _repository.getUsers(
      limit: limit,
      startAfter: startAfter,
      filters: filters,
      orderBy: orderBy,
      descending: descending,
    );

    state = false;

    result.fold(
      (l) => showSnackBar(context, l.message),
      (users) {
        // If first page (reset)
        if (reset) {
          _ref.read(userListProvider.notifier).state = users;
        } else {
          _ref.read(userListProvider.notifier).state = [
            ..._ref.read(userListProvider),
            ...users,
          ];
        }

        // Update last doc for next pagination call
        if (users.isNotEmpty) {
          // Save last DocumentSnapshot → modify repository to return it OR fetch manually
          // For now, fetch manually: query last doc from Firestore again
          // (Preferred: modify repo later to return QuerySnapshot)
        }

        // If < limit → no more pages
        if (users.length < limit) {
          _ref.read(hasMoreUsersProvider.notifier).state = false;
        } else {
          _ref.read(hasMoreUsersProvider.notifier).state = true;
        }
      },
    );
  }

  // ============================================================
  // GET ALL USERS (NO FILTERS)
  // ============================================================
  Future<void> fetchAllUsers(BuildContext context) async {
    state = true;

    final result = await _repository.getAllUsers();
    state = false;

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userListProvider.notifier).state = r;
      },
    );
  }

  // ============================================================
  // UPDATE USER
  // ============================================================
  Future<void> updateUser(BuildContext context, AppUser user) async {
    state = true;

    final result = await _repository.updateUser(user);
    state = false;

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        final users = [..._ref.read(userListProvider)];
        final index = users.indexWhere((u) => u.id == r.id);

        if (index != -1) {
          users[index] = r;
          _ref.read(userListProvider.notifier).state = users;
        }

        _ref.read(activeUserProvider.notifier).state = r;

        showSnackBar(context, "User Updated");
      },
    );
  }

  // ============================================================
  // DELETE USER
  // ============================================================
  Future<void> deleteUser(BuildContext context, String id) async {
    state = true;

    final result = await _repository.deleteUser(id);
    state = false;

    result.fold(
      (l) => showSnackBar(context, l.message),
      (_) {
        final users =
            _ref.read(userListProvider).where((u) => u.id != id).toList();

        _ref.read(userListProvider.notifier).state = users;

        showSnackBar(context, "User Deleted");
      },
    );
  }
}
