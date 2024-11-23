import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  static String routeName = "/home-admin";

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Page',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.cyan,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFF232429),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Text(
                'Game',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                    color: Colors.blue[300]),
              ),
              Text(
                'Heaven',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                    color: Colors.blue[300]),
              ),
              const SizedBox(
                height: 80,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      alignment: Alignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 130,
                                height: 120,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2f2f2f),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, CategoriesPage.routeName),
                                  child: const Column(
                                    children: [
                                      Icon(Icons.category,
                                          size: 32.0, color: Colors.white),
                                      SizedBox(height: 4),
                                      Text('Categories',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 130,
                                height: 120,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2f2f2f),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: GestureDetector(
                                  // onTap: () =>
                                  //     Navigator.pushNamed(context, Page2.routes),
                                  child: const Column(
                                    children: [
                                      Icon(Icons.conveyor_belt,
                                          size: 32.0, color: Colors.white),
                                      SizedBox(height: 4),
                                      Text('Products',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 130,
                                height: 120,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2f2f2f),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, BrandsPage.routeName),
                                  child: const Column(
                                    children: [
                                      Icon(Icons.branding_watermark,
                                          size: 32.0, color: Colors.white),
                                      SizedBox(height: 4),
                                      Text('Brands',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 130,
                                height: 120,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 32),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2f2f2f),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, TransactionsPage.routeName),
                                  child: const Column(
                                    children: [
                                      Icon(Icons.receipt,
                                          size: 32.0, color: Colors.white),
                                      SizedBox(height: 4),
                                      Text('Transactions',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                ),
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, LoginPage.routeName);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
