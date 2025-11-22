import 'package:bharatwork/features/jobs/create_jobs_view.dart';
import 'package:bharatwork/features/jobs/job_model.dart';
import 'package:bharatwork/features/jobs/job_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobsListScreen extends ConsumerStatefulWidget {
  const JobsListScreen({super.key});

  @override
  ConsumerState<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends ConsumerState<JobsListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(jobControllerProvider.notifier)
          .startJobsStream(limit: 50, orderBy: 'created_at', descending: true);
    });
  }

  @override
  void dispose() {
    ref.read(jobControllerProvider.notifier).stopJobsStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = ref.watch(jobListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Jobs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateJobScreen()),
            ),
          ),
        ],
      ),
      body: jobs.isEmpty
          ? const Center(child: Text("No jobs found"))
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (_, index) {
                final job = jobs[index];
                return jobTile(job);
              },
            ),
    );
  }

  Widget jobTile(JobModel job) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(job.title),
        subtitle: Text("${job.enterprise} • ₹${job.pay}"),
        trailing: Text(job.jobType.isEmpty ? "" : job.jobType),
      ),
    );
  }
}
