import 'dart:developer' as console;

import 'package:bharatwork/core/fpdart/failure.dart';
import 'package:bharatwork/core/fpdart/type_def.dart';
import 'package:bharatwork/features/users/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository(this.firestore);

  CollectionReference get _collection => firestore.collection("users");

  // -------------------------
  // CREATE USER
  // -------------------------
  FutureEither<AppUser> createUser(AppUser user) async {
    try {
      final docRef = await _collection.add({...user.toJson(), 'created_at': Timestamp.now()});
      console.log(docRef.id);

      final snap = await docRef.get();
      final newUser = AppUser.fromJson(snap.data() as Map<String, dynamic>, snap.id);

      return right(newUser);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // -------------------------
  // GET SINGLE USER
  // -------------------------
  FutureEither<AppUser> getUser(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) {
        return left(Failure("User not found"));
      }

      return right(AppUser.fromJson(doc.data() as Map<String, dynamic>, doc.id));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // -------------------------
  // GET ALL USERS (NO FILTERS)
  // -------------------------
  FutureEither<List<AppUser>> getAllUsers() async {
    try {
      final query = await _collection.orderBy("created_at", descending: true).get();

      final users = query.docs.map((d) => AppUser.fromJson(d.data() as Map<String, dynamic>, d.id)).toList();

      return right(users);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // -------------------------
  // GET USERS WITH PAGINATION / FILTERS
  // -------------------------
  FutureEither<List<AppUser>> getUsers({int limit = 20, DocumentSnapshot? startAfter, Map<String, dynamic>? filters, String orderBy = "created_at", bool descending = true}) async {
    try {
      Query query = _collection;

      // Apply filters
      if (filters != null) {
        filters.forEach((key, value) {
          if (key == "skills" && value is String) {
            query = query.where("skills", arrayContains: value);
          } else if (key == "min_expected_wages") {
            query = query.where("expected_wages", isGreaterThanOrEqualTo: value);
          } else if (key == "max_expected_wages") {
            query = query.where("expected_wages", isLessThanOrEqualTo: value);
          } else {
            query = query.where(key, isEqualTo: value);
          }
        });
      }

      query = query.orderBy(orderBy, descending: descending).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snap = await query.get();

      final users = snap.docs.map((d) => AppUser.fromJson(d.data() as Map<String, dynamic>, d.id)).toList();

      return right(users);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // -------------------------
  // UPDATE USER
  // -------------------------
  FutureEither<AppUser> updateUser(AppUser user) async {
    try {
      final data = user.toJson();
      data["updated_at"] = Timestamp.now();

      await _collection.doc(user.id).update(data);

      final snap = await _collection.doc(user.id).get();

      return right(AppUser.fromJson(snap.data() as Map<String, dynamic>, snap.id));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // -------------------------
  // DELETE USER
  // -------------------------
  FutureEither<Unit> deleteUser(String id) async {
    try {
      await _collection.doc(id).delete();
      return right(unit); // fpdart Unit
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
