import 'package:bharatwork/features/users/controller/user_controller.dart';
import 'package:bharatwork/features/users/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Create User")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    final user = AppUser(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      createdAt: DateTime.now(),
                    );

                    ref
                        .read(userControllerProvider.notifier)
                        .createUser(context, user);

                    Navigator.pop(context);
                  },
                  child: const Text("Create"),
                )
              ],
            ),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
