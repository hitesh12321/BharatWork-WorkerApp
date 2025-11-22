import 'package:bharatwork/features/users/controller/user_controller.dart';
import 'package:bharatwork/features/users/models/user_model.dart';
import 'package:bharatwork/features/users/providers/user_providers.dart'
    show activeUserProvider; // Added userControllerProvider for context
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Global Constants ---
// Define the colors used in the design
const Color _kPrimaryBackgroundColor = Color(0xFFFBF7EF); // Page background
const Color _kCardColor = Color(0xFFFEFCF9); // Light beige/yellow for cards
const Color _kAccentColor = Color(
  0xFFE57373,
); // Primary accent (like Edit buttons)
const Color _kPrimaryTextColor = Color(0xFF333333);
const Color _kSecondaryTextColor = Color(0xFF666666);
const Color _kAadhaarVerifiedColor = Color(0xFF388E3C); // Green for verified
const Color _kRatingColor = Color(0xFFFBC02D); // Yellow for stars
const Color _kChipBackgroundColor = Color(0xFFF1E9D7); // Skill chip background

// --- MAIN PROFILE PAGE (Riverpod ConsumerStatefulWidget) ---

class ProfilePage extends ConsumerStatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is created
    Future.microtask(() {
      ref
          .read(userControllerProvider.notifier)
          .fetchUser(context, widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch the active user state
    final AppUser? activeUser = ref.watch(activeUserProvider);

    // 2. Handle Loading/Error States
    if (activeUser == null) {
      // You could add an error check here if AppUser was a AsyncValue
      return const Scaffold(
        backgroundColor: _kPrimaryBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 3. Render the UI with user data
    return Scaffold(
      backgroundColor: _kPrimaryBackgroundColor,
      // appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- My Profile Header ---
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 15),

              // --- User Profile Card (Data-driven) ---
              ProfileHeaderCard(user: activeUser),
              const SizedBox(height: 20),

              // --- Skills Section (Data-driven) ---
              SkillsSection(
                skills:
                    activeUser.skills ??
                    [""], // Assuming skills is List<String>
              ),
              const SizedBox(height: 20),

              // --- Wage Preference Section (Data-driven) ---
              // WagePreferenceSection(
              //   wageRange: activeUser.wageRange ?? '₹600 - ₹800', // Example field
              // ),
              const SizedBox(height: 20),

              // --- Work History Section ---
              const WorkHistorySection(),
              const SizedBox(height: 20),

              // --- Reviews Section ---
              const ReviewsSection(),
              const SizedBox(height: 20),

              // --- Settings Divider ---
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      // --- Bottom Navigation Bar ---
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  // AppBar implementation remains constant
  // AppBar _buildAppBar() {
  //   return AppBar(
  //     title: const Text(
  //       'BharatWork',
  //       style: TextStyle(color: _kPrimaryTextColor),
  //     ),
  //     centerTitle: true,
  //     backgroundColor: Colors.white,
  //     elevation: 1,
  //     leading: IconButton(
  //       icon: const Icon(Icons.menu, color: _kPrimaryTextColor),
  //       onPressed: () {},
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: const Icon(Icons.add, color: _kPrimaryTextColor),
  //         onPressed: () {},
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.notifications_none, color: _kPrimaryTextColor),
  //         onPressed: () {},
  //       ),
  //     ],
  //   );
  // }
}

// --- Reusable Widget for Profile Header Card (Now accepts AppUser) ---
class ProfileHeaderCard extends StatelessWidget {
  final AppUser user;

  const ProfileHeaderCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder values for missing data fields in the AppUser model
    final String name = user.name ?? 'Rajesh Kumar';
    // final List imageUrl = user.photos ?? 'https://via.placeholder.com/150';
    final double rating = user.averageRating ?? 4.5;
    final bool isVerified = user.verified ?? true;
    final String memberSince = /*user.createdAt.toString() ??*/ 'April 2022';
    final String aadhar = user.aadharNumber?.toString() ?? '32';
    final String jobsCompleted = user.jobsCompleted.toString() ?? '48';

    return Card(
      color: _kCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // User Image/Avatar
                CircleAvatar(
                  radius: 35,
                  // backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(width: 15),
                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            color: _kRatingColor,
                            size: 16,
                          ),
                          Text(
                            ' $rating',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 10),
                          if (isVerified) ...[
                            Icon(
                              Icons.check_circle,
                              color: _kAadhaarVerifiedColor,
                              size: 16,
                            ),
                            const Text(
                              ' Aadhaar Verified',
                              style: TextStyle(
                                fontSize: 14,
                                color: _kSecondaryTextColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Edit Button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _kAccentColor,
                    side: const BorderSide(color: _kAccentColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildStatItem('Member Since', memberSince),
                _buildStatItem('aadhar', aadhar),
                _buildStatItem('Jobs Completed', jobsCompleted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for the statistics text
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          label,
          style: const TextStyle(color: _kSecondaryTextColor, fontSize: 12),
        ),
      ],
    );
  }
}

// --- Reusable Widget for Skill Chips Section (Now accepts skills List) ---
class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({required this.skills, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _kCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Add',
                    style: TextStyle(color: _kAccentColor),
                  ), // Using accent for 'Add'
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0, // horizontal space
              runSpacing: 4.0, // vertical space
              children: skills
                  .map(
                    (skill) => Chip(
                      label: Text(
                        skill,
                        style: const TextStyle(color: _kPrimaryTextColor),
                      ),
                      backgroundColor: _kChipBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Widget for Wage Preference Section (Now accepts wageRange) ---
class WagePreferenceSection extends StatelessWidget {
  final String wageRange;

  const WagePreferenceSection({required this.wageRange, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _kCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Wage Preference',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _kAccentColor,
                    side: const BorderSide(color: _kAccentColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Daily Wage Range',
              style: TextStyle(color: _kSecondaryTextColor, fontSize: 14),
            ),
            Text(
              wageRange,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Work History Section (UI only) ---
class WorkHistorySection extends StatelessWidget {
  const WorkHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      cardColor: _kCardColor,
      title: 'Work History',
      subtitle: 'View your job history',
      icon: Icons.work_outline,
      onTap: () {},
    );
  }
}

// --- Reviews Section (UI only) ---
class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      cardColor: _kCardColor,
      title: 'Reviews',
      subtitle: 'See what employers say about you',
      icon: Icons.star_border,
      onTap: () {},
    );
  }
}

// --- Reusable Widget for Work History/Reviews Sections (Common Style) ---
class SectionCard extends StatelessWidget {
  final Color cardColor;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SectionCard({
    required this.cardColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kChipBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _kAccentColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _kSecondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: _kSecondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Reusable Widget for the Bottom Navigation Bar ---
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.orange; // Active tab color
    const Color inactiveColor = _kSecondaryTextColor; // Inactive tab color

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 4, // 'Profile' is the 5th item (index 4)
        type: BottomNavigationBarType.fixed, // Essential for more than 3 items
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Agent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            // Active icon is filled
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation here
        },
      ),
    );
  }
}
