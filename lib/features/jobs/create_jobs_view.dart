import 'package:bharatwork/features/jobs/job_model.dart';
import 'package:bharatwork/features/jobs/job_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateJobScreen extends ConsumerStatefulWidget {
  const CreateJobScreen({super.key});

  @override
  ConsumerState<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends ConsumerState<CreateJobScreen> {
  final titleCtrl = TextEditingController();
  final enterpriseCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final payCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final jobTypeCtrl = TextEditingController();

  final skillsCtrl = TextEditingController(); // comma separated
  final shiftCtrl = TextEditingController();
  final durationCtrl = TextEditingController();

  GeoPoint _location = const GeoPoint(28.6, 77.2); // default Delhi for now

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Job")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            textField(titleCtrl, "Job Title"),
            textField(enterpriseCtrl, "Enterprise"),
            textField(phoneCtrl, "Phone Number", input: TextInputType.phone),
            textField(payCtrl, "Pay (₹)", input: TextInputType.number),
            textField(jobTypeCtrl, "Job Type (e.g. mason, electrician)"),
            textField(descCtrl, "Description", maxLines: 3),
            textField(skillsCtrl, "Skills (comma separated)"),
            textField(shiftCtrl, "Shift (e.g. Day, Night)"),
            textField(durationCtrl, "Duration (e.g. 3 days)"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : () => _create(context),
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Create Job"),
            )
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController c, String label,
      {TextInputType input = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: input,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Future<void> _create(BuildContext context) async {
    if (titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required")),
      );
      return;
    }

    setState(() => _loading = true);

    final job = JobModel(
      id: "",
      title: titleCtrl.text.trim(),
      enterprise: enterpriseCtrl.text.trim(),
      phoneNumber: phoneCtrl.text.trim(),
      pay: double.tryParse(payCtrl.text) ?? 0,
      description: descCtrl.text.trim(),
      jobType: jobTypeCtrl.text.trim(),
      skillsRequired:
          skillsCtrl.text.split(",").map((e) => e.trim()).toList(),
      shift: shiftCtrl.text.trim(),
      duration: durationCtrl.text.trim(),
      location: _location,
    );

    await ref.read(jobControllerProvider.notifier).createJob(context,job);

    setState(() => _loading = false);

    if (context.mounted) Navigator.pop(context);
  }
}
