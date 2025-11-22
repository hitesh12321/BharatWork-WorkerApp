import 'package:bharatwork/features/jobs/job_list_view.dart';
import 'package:bharatwork/features/users/views/users_list_view.dart';
import 'package:bharatwork/models/button.dart';
import 'package:bharatwork/presentation/screens/MainPages/agents_page.dart';
import 'package:bharatwork/presentation/screens/MainPages/earnings_page.dart';
import 'package:bharatwork/presentation/screens/MainPages/home_page.dart';

import 'package:bharatwork/presentation/screens/MainPages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  final List selectedPage = [
    HomePage(),
    JobsListScreen(),
    AgentPage(),
    EarningPage(),
    UsersScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 240, 220),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 90,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...List.generate(
              bottombuttons.length,
              (index) => Card(
                elevation: 0,
                color: selectedIndex == index ? Colors.orange : Colors.white,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => selectedPage[index],
                          ),
                        );
                      },
                      icon: selectedIndex == index
                          ? Icon(bottombuttons[index].selected)
                          : Icon(bottombuttons[index].unselected),
                    ),
                    Text(bottombuttons[index].title),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: selectedPage[selectedIndex],
    );
  }
}
