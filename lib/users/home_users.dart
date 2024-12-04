import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class HomeUsersPage extends StatefulWidget {
  const HomeUsersPage({super.key});

  static String routeName = "/home-users";

  @override
  State<HomeUsersPage> createState() => _HomeUsersPageState();
}

class _HomeUsersPageState extends State<HomeUsersPage> {
  var userData;

  Future<void> loadUserData() async {
    final data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
