// lib/features/jobs/providers/job_providers.dart
import 'package:bharatwork/features/jobs/job_controller.dart';
import 'package:bharatwork/features/jobs/job_model.dart';
import 'package:bharatwork/features/jobs/job_repository.dart';
import 'package:bharatwork/firebase/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// repository provider
final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final firestore = ref.watch(FirebaseProviders.firestoreProvider); // your centralized provider
  return JobRepository(firestore);
});

// controller provider (StateNotifier<bool> loading)
final jobControllerProvider = StateNotifierProvider<JobController, bool>((ref) {
  final repo = ref.watch(jobRepositoryProvider);
  return JobController(repository: repo, ref: ref);
});

// UI state providers
final jobListProvider = StateProvider<List<JobModel>>((ref) => []);
final activeJobProvider = StateProvider<JobModel?>((ref) => null);
final jobStreamFiltersProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
final hasMoreJobsProvider = StateProvider<bool>((ref) => true);
final lastJobDocProvider = StateProvider<DocumentSnapshot?>((ref) => null);
