import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Bottombutton {
  final IconData selected;
  final IconData unselected;
  final String title;

  Bottombutton({
    required this.selected,
    required this.unselected,
    required this.title,
  });
}

List<Bottombutton> bottombuttons = [
  Bottombutton(
    selected: Icons.home_outlined,
    unselected: Icons.home_outlined,
    title: "Home",
  ),
  Bottombutton(
    selected: Icons.work_outline,
    unselected: Icons.work_outline,
    title: "Jobs",
  ),
  Bottombutton(
    selected: Icons.person_outline,
    unselected: Icons.person_outline,
    title: "Agent",
  ),

  Bottombutton(
    selected: Icons.account_balance_wallet_outlined,
    unselected: Icons.account_balance_wallet_outlined,
    title: "Earnings",
  ),
  Bottombutton(
    selected: Icons.person,
    unselected: Icons.person,
    title: "Profile",
  ),
];
