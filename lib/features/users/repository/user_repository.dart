import 'package:bharatwork/core/fpdart/failure.dart';
import 'package:bharatwork/core/fpdart/type_def.dart';
import 'package:bharatwork/features/users/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';


class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository(this.firestore);

  CollectionReference get _collection =>
      firestore.collection("users");

  FutureEither<AppUser> createUser(AppUser user) async {
    try {
      await _collection.doc(user.id).set(user.toJson());
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<AppUser> getUser(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return left(Failure("User not found"));

      return right(AppUser.fromJson(doc.data() as Map<String, dynamic>, doc.id));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<AppUser>> getAllUsers() async {
    try {
      final query = await _collection.get();
      final users = query.docs.map(
        (d) => AppUser.fromJson(d.data() as Map<String, dynamic>, d.id),
      ).toList();
      return right(users);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<AppUser> updateUser(AppUser user) async {
    try {
      await _collection.doc(user.id).update(user.toJson());
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<Unit> deleteUser(String id) async {
    try {
      await _collection.doc(id).delete();
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
