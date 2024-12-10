import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/home_users.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class UserProductsPage extends StatefulWidget {
  const UserProductsPage({super.key});

  static String routeName = "/user-products";

  @override
  State<UserProductsPage> createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  final dio = Dio();
  bool isLoading = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Products',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Builder(builder: (context) {
              return GestureDetector(
                onTap: () {
                  showPopover(
                    context: context,
                    bodyBuilder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      width: 150,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userData["email"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(userData["full_name"]),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeUsersPage(initialIndex: 3),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.receipt,
                                size: 14,
                              ),
                              label: const Text(
                                'Your Transaction',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              height: 1,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                    context, LoginPage.routeName);
                                clearUserData();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    direction: PopoverDirection.bottom,
                    width: 200,
                    arrowWidth: 20,
                    backgroundColor: Colors.white,
                  );
                },
                child: CircleAvatar(
                  child: Text(userData?["full_name"][0] ?? "A"),
                ),
              );
            })
          ],
        ),
        backgroundColor: AppColors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF242526),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Center(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
