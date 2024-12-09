import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/home_users.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/helpers.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class UserTransactionsPage extends StatefulWidget {
  const UserTransactionsPage({super.key});

  static String routeName = "/user-transactions";

  @override
  State<UserTransactionsPage> createState() => _UserTransactionsPageState();
}

class _UserTransactionsPageState extends State<UserTransactionsPage> {
  final dio = Dio();
  bool isLoading = false;

  var userData;
  var userTransactionList = [];

  Future<void> loadUserData() async {
    final data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  void getTransactionByUserId() async {
    try {
      Response response;

      response =
          await dio.get("$getByUserIdTransaction/${userData["username"]}");

      if (response.data["status"]) {
        setState(() {
          userTransactionList = response.data["results"];
        });
      } else {
        toastification.show(
            title: const Text('Gagal memuat data'),
            type: ToastificationType.error,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          title: const Text('Kesalahan pada server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData().then((_) {
      getTransactionByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Transactions',
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
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        child: Text(
                          userData?["full_name"].split(" ")[0].toUpperCase() ??
                              "USER",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(userData?["full_name"] ?? "User",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      userData?["email"] ?? "user@mail.com",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey[400]),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, elevation: 1),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, LoginPage.routeName);
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
                ),
                const SizedBox(
                  height: 32,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Your Transactions',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: userTransactionList.length,
                          itemBuilder: (context, index) {
                            final transaction = userTransactionList[index];
                            String formattedDate =
                                formatDate(transaction['date']);

                            String formattedPrice =
                                currencyFormatter(transaction["total_price"]);

                            return Card(
                              color: Colors.grey[850],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "${transaction['products']['name']}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "${transaction['username']}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${transaction['quantity']} Item${transaction['quantity'] > 1 ? 's' : ''}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Chip(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 2,
                                              ),
                                              label: Text(
                                                "${transaction['status']}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              backgroundColor: getStatusColor(
                                                  transaction['status']),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide.none,
                                              ),
                                              elevation: 0,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formattedPrice,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                )
              ],
            ),
          ),
        ));
  }
}
