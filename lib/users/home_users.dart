import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/categories/user_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/products/user_products.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/profile/user_profile.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/transactions/user_transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/helpers.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class HomeUsersPage extends StatefulWidget {
  final int initialIndex;

  const HomeUsersPage({super.key, this.initialIndex = 0});

  static String routeName = "/home-users";

  @override
  State<HomeUsersPage> createState() => _HomeUsersPageState();
}

class _HomeUsersPageState extends State<HomeUsersPage> {
  int indexPage = 0;
  var userData;
  // TODO: Move to UserHomePage widget

  final List pages = [
    const UserHomePage(),
    const UserProductsPage(),
    const UserCategoriesPage(),
    const UserTransactionsPage(),
    const UserProfilePage(),
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF232428),
          currentIndex: indexPage,
          onTap: onPageChanged,
          selectedItemColor: Colors.cyan,
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
              icon: Icon(Icons.receipt),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_sharp),
              label: 'Profile',
            ),
          ],
        ),
        body: pages[indexPage]);
  }
}

// Users Home Page Widget
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => UserHomePageState();
}

class UserHomePageState extends State<UserHomePage> {
  final dio = Dio();
  bool isLoading = false;

  var topProducts = [];
  var categoriesList = [];

  void getTopProductsData() async {
    try {
      Response response;

      response = await dio.get(getTopProducts);

      if (response.data["status"]) {
        setState(() {
          topProducts = response.data["results"];
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

  void getCategoriesList() async {
    try {
      Response response;

      response = await dio.get(getCategories);

      if (response.data["status"]) {
        setState(() {
          categoriesList = response.data["results"].sublist(0, 4);
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

  @override
  void initState() {
    super.initState();
    getTopProductsData();
    getCategoriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discover',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF242526),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeUsersPage(initialIndex: 2),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/game-heaven_banner.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Top Products',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(topProducts.length, (index) {
                    var product = topProducts[index];
                    String formattedPrice = currencyFormatter(product['price']);
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 2,
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0),
                                ),
                                child: Image.network(
                                  "$imageUrl${product['image']}",
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF145da0),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product["categories"]["name"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            "${product["name"]}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      product["description"],
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 3,
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        formattedPrice,
                                        style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF8a2bab),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shopping_cart,
                                              size: 16, color: Colors.white),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'Buy Now',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
        ],
      ),
    );
  }
}
