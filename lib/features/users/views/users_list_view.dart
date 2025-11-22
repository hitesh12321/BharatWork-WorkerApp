import 'package:bharatwork/features/users/providers/user_providers.dart';
import 'package:bharatwork/features/users/views/create_user_view.dart';
import 'package:bharatwork/presentation/screens/MainPages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Change to ConsumerStatefulWidget
class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  // 2. Use initState to fetch data when the app opens
  @override
  void initState() {
    super.initState();
    // We use Future.microtask to ensure the build is finished before using context
    Future.microtask(() {
      ref.read(userControllerProvider.notifier).fetchAllUsers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Watch the providers just like before
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
              MaterialPageRoute(builder: (_) => const CreateUserScreen()),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          if (users.isEmpty && !isLoading)
            const Center(child: Text("No users found")),

          if (users.isNotEmpty)
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(userId: user.id),
                      ),
                    );
                  },
                  child: ListTile(
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
                  ),
                );
              },
            ),

          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
