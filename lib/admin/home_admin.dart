import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/products/products.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/helpers.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class HomeAdminPage extends StatefulWidget {
  final int initialIndex;

  const HomeAdminPage({super.key, this.initialIndex = 0});

  static String routeName = "/home-admin";

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int indexPage = 0;
  var userData;

  final List pages = [
    const HomePage(),
    const CategoriesPage(),
    const ProductsPage(),
    const BrandsPage(),
    const TransactionsPage(),
  ];

  @override
  void initState() {
    super.initState();
    indexPage = widget.initialIndex;
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      indexPage = index;
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
                'Admin Page',
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
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Role"),
                                  Text(
                                    "Admin",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
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
          backgroundColor: const Color(0xFF333333),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF232428),
          currentIndex: indexPage,
          onTap: onPageChanged,
          selectedItemColor: const Color(0xFFd371dd),
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.conveyor_belt),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.branding_watermark),
              label: 'Brands',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Transactions',
            ),
          ],
        ),
        body: pages[indexPage]);
  }
}

// Admin Home Page Widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dio = Dio();
  bool isLoading = false;
  int totalUsers = 0;
  int totalBrands = 0;
  int totalTransactions = 0;
  int totalProducts = 0;

  var highestTransactionsList = [];

  void getTotalUsersData() async {
    try {
      Response response;

      response = await dio.get(getTotalUsers);

      if (response.data["status"]) {
        setState(() {
          totalUsers = response.data["total_users"];
        });
      }
    } catch (e) {
      toastification.show(
          title: const Text('Kesalahan pada server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    }
  }

  void getTotalTransactionsData() async {
    try {
      Response response;

      response = await dio.get(getTotalTransaction);

      if (response.data["status"]) {
        setState(() {
          totalTransactions = response.data["total_transactions"];
        });
      }
    } catch (e) {
      toastification.show(
          title: const Text('Kesalahan pada server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    }
  }

  void getTotalBrandsData() async {
    try {
      Response response;

      response = await dio.get(getTotalBrand);

      if (response.data["status"]) {
        setState(() {
          totalBrands = response.data["total_brands"];
        });
      }
    } catch (e) {
      toastification.show(
          title: const Text('Kesalahan pada server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    }
  }

  void getTotalProductsData() async {
    try {
      Response response;

      response = await dio.get(getTotalProduct);

      if (response.data["status"]) {
        setState(() {
          totalProducts = response.data["total_products"];
        });
      }
    } catch (e) {
      toastification.show(
          title: const Text('Kesalahan pada server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    }
  }

  void getHighestTransactions() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    try {
      Response response;

      response = await dio.get(highestTransactions);

      if (response.data["status"]) {
        highestTransactionsList = response.data["results"];
      } else {
        highestTransactionsList = [];
      }
    } catch (e) {
      toastification.show(
          title: const Text('Kesalahan pada server'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTotalUsersData();
    getTotalProductsData();
    getTotalBrandsData();
    getTotalTransactionsData();
    getHighestTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232429),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text(
                    "Selamat Datang Admin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 300,
                    child: Align(
                      child: Text(
                        'Kelola brand, kategori, produk, dan transaksi yang ada dalam toko GameHeaven.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w100,
                        ),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Card(
                                color: const Color(0xFF2f2f2f),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.yellowAccent[700],
                                        size: 32,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$totalUsers",
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Text(
                                            'Users',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Card(
                                color: const Color(0xFF2f2f2f),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.branding_watermark,
                                        color: Colors.blueAccent[700],
                                        size: 32,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$totalBrands",
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Text(
                                            'Brands',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Card(
                                color: const Color(0xFF2f2f2f),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.conveyor_belt,
                                        color: Colors.orangeAccent[700],
                                        size: 32,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$totalProducts",
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Text(
                                            'Products',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Card(
                                color: const Color(0xFF2f2f2f),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.receipt,
                                        color: Colors.purpleAccent[700],
                                        size: 32,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$totalTransactions",
                                            style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Text(
                                            'Transactions',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transaksi Tertinggi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeAdminPage(initialIndex: 4),
                                  ),
                                );
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(color: Colors.grey[400]),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 535,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: highestTransactionsList.length,
                                itemBuilder: (context, index) {
                                  final transaction =
                                      highestTransactionsList[index];

                                  String formattedDate =
                                      formatDate(transaction['date']);
                                  String formattedPrice = currencyFormatter(
                                      transaction["total_price"]);

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
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "${transaction['quantity']} Item",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Chip(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 2,
                                                    ),
                                                    label: Text(
                                                      "${transaction['status']}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    backgroundColor:
                                                        getStatusColor(
                                                            transaction[
                                                                'status']),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
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
                                },
                              ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
