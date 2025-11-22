// lib/features/jobs/controller/job_controller.dart
import 'dart:async';
import 'package:bharatwork/core/utils/utils.dart';
import 'package:bharatwork/features/jobs/job_model.dart';
import 'package:bharatwork/features/jobs/job_providers.dart';
import 'package:bharatwork/features/jobs/job_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class JobController extends StateNotifier<bool> {
  final JobRepository _repository;
  final Ref _ref;

  StreamSubscription<List<JobModel>>? _jobsSub;

  JobController({required JobRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  // start listening to real-time jobs; updates jobListProvider
  void startJobsStream({
    Map<String, dynamic>? filters,
    String orderBy = 'created_at',
    bool descending = true,
    int limit = 50,
  }) {
    // cancel existing subscription
    _jobsSub?.cancel();

    final stream = _repository.streamJobs(
      filters: filters,
      orderBy: orderBy,
      descending: descending,
      limit: limit,
    );

    _jobsSub = stream.listen((jobs) {
      _ref.read(jobListProvider.notifier).state = jobs;
      // update last doc and hasMore if needed (we don't have doc snapshots here)
      _ref.read(hasMoreJobsProvider.notifier).state = jobs.length >= limit;
    }, onError: (err) {
      // show snackbar if UI context available via other means
      // you can optionally route errors into a provider
    });
  }

  // stop listening
  Future<void> stopJobsStream() async {
    await _jobsSub?.cancel();
    _jobsSub = null;
  }

  // create
  Future<void> createJob(BuildContext context, JobModel job) async {
    state = true;
    final res = await _repository.createJob(job);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Job created'),
    );
  }

  // read single
  Future<void> fetchJob(BuildContext context, String id) async {
    state = true;
    final res = await _repository.getJob(id);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => _ref.read(activeJobProvider.notifier).state = r,
    );
  }

  // update
  Future<void> updateJob(BuildContext context, JobModel job) async {
    state = true;
    final res = await _repository.updateJob(job);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Job updated'),
    );
  }

  // delete
  Future<void> deleteJob(BuildContext context, String id) async {
    state = true;
    final res = await _repository.deleteJob(id);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (_) => showSnackBar(context, 'Job deleted'),
    );
  }

  // one-time paginated fetch (useful in addition to stream)
  Future<void> fetchJobsPage({
    required BuildContext context,
    int limit = 20,
    DocumentSnapshot? startAfter,
    Map<String, dynamic>? filters,
    String orderBy = 'created_at',
    bool descending = true,
    bool reset = false,
  }) async {
    state = true;
    final res = await _repository.getJobs(
      limit: limit,
      startAfter: startAfter,
      filters: filters,
      orderBy: orderBy,
      descending: descending,
    );
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (jobs) {
        if (reset) {
          _ref.read(jobListProvider.notifier).state = jobs;
        } else {
          _ref.read(jobListProvider.notifier).state = [
            ..._ref.read(jobListProvider),
            ...jobs,
          ];
        }

        _ref.read(hasMoreJobsProvider.notifier).state = jobs.length >= limit;

        // set last doc for pagination (if jobs non-empty)
        // Note: repository.getJobs doesn't return docs; if you need precise pagination, modify repo to return QuerySnapshot or last doc.
      },
    );
  }

  @override
  void dispose() {
    _jobsSub?.cancel();
    super.dispose();
  }
}
