// lib/features/jobs/repository/job_repository.dart
import 'package:bharatwork/core/fpdart/type_def.dart';
import 'package:bharatwork/features/jobs/job_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/fpdart/failure.dart'; // adjust import path

class JobRepository {
  final FirebaseFirestore firestore;
  final String collectionPath;

  JobRepository(this.firestore, {this.collectionPath = 'jobs'});

  CollectionReference get _collection => firestore.collection(collectionPath);

  // Create (auto-id)
  FutureEither<JobModel> createJob(JobModel job) async {
    try {
      final data = job.toJson();
      data['created_at'] = Timestamp.fromDate(job.createdAt);
      data['updated_at'] = Timestamp.fromDate(job.updatedAt);

      final docRef = await _collection.add(data);
      final snap = await docRef.get();
      final newJob = JobModel.fromJson(snap.data() as Map<String, dynamic>, snap.id);
      return right(newJob);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Read single
  FutureEither< JobModel> getJob(String id) async {
    try {
      final snap = await _collection.doc(id).get();
      if (!snap.exists) return left(Failure('Job not found'));
      return right(JobModel.fromJson(snap.data() as Map<String, dynamic>, snap.id));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update
  FutureEither<JobModel> updateJob(JobModel job) async {
    try {
      final data = job.toJson();
      data['updated_at'] = Timestamp.now();
      await _collection.doc(job.id).update(data);
      final snap = await _collection.doc(job.id).get();
      return right(JobModel.fromJson(snap.data() as Map<String, dynamic>, snap.id));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Delete
  FutureEither<Unit> deleteJob(String id) async {
    try {
      await _collection.doc(id).delete();
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // One-time paginated get
  FutureEither<List<JobModel>> getJobs({
    int limit = 20,
    DocumentSnapshot? startAfter,
    Map<String, dynamic>? filters,
    String orderBy = 'created_at',
    bool descending = true,
  }) async {
    try {
      Query q = _collection;

      // apply filters (simple)
      if (filters != null) {
        filters.forEach((k, v) {
          if (k == 'skills' && v is String) {
            q = q.where('skills_required', arrayContains: v);
          } else if (k == 'job_type' && v is String) {
            q = q.where('job_type', isEqualTo: v);
          } else {
            q = q.where(k, isEqualTo: v);
          }
        });
      }

      q = q.orderBy(orderBy, descending: descending).limit(limit);

      if (startAfter != null) q = q.startAfterDocument(startAfter);

      final snap = await q.get();
      final list = snap.docs.map((d) => JobModel.fromJson(d.data() as Map<String, dynamic>, d.id)).toList();
      return right(list);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Real-time stream of jobs with optional filters & sorting
  Stream<List<JobModel>> streamJobs({
    Map<String, dynamic>? filters,
    String orderBy = 'created_at',
    bool descending = true,
    int limit = 50,
  }) {
    Query q = _collection;

    if (filters != null) {
      filters.forEach((k, v) {
        if (k == 'skills' && v is String) {
          q = q.where('skills_required', arrayContains: v);
        } else if (k == 'job_type' && v is String) {
          q = q.where('job_type', isEqualTo: v);
        } else {
          q = q.where(k, isEqualTo: v);
        }
      });
    }

    q = q.orderBy(orderBy, descending: descending).limit(limit);

    return q.snapshots().map((snap) => snap.docs
        .map((d) => JobModel.fromJson(d.data() as Map<String, dynamic>, d.id))
        .toList());
  }
}
