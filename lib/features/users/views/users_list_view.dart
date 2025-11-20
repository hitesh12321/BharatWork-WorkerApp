import 'package:bharatwork/features/users/controller/user_controller.dart';
import 'package:bharatwork/features/users/providers/user_providers.dart' hide userControllerProvider;
import 'package:bharatwork/features/users/views/create_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userControllerProvider.notifier).fetchAllUsers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userListProvider);
    final isLoading = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateUserScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (users.isEmpty)
            const Center(child: Text("No users found")),

          if (users.isNotEmpty)
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref
                          .read(userControllerProvider.notifier)
                          .deleteUser(context, user.id);
                    },
                  ),
                );
              },
            ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
