import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/products/details/product_details.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/products/user_products.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/transactions/user_transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
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

  final List pages = [
    const UserHomePage(),
    const UserProductsPage(),
    const UserTransactionsPage(),
  ];

  @override
  void initState() {
    super.initState();
    indexPage = widget.initialIndex;
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
          selectedItemColor: const Color(0xFFbf17f1),
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.conveyor_belt),
              label: 'Products',
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

// Users Home Page Widget
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => UserHomePageState();
}

class UserHomePageState extends State<UserHomePage> {
  final dio = Dio();
  bool isLoading = false;

  TextEditingController amountController = TextEditingController();

  var userData;

  var topProducts = [];
  var categoriesList = [];

  Future<void> loadUserData() async {
    final data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  void getTopProductsData() async {
    try {
      Response response;

      response = await dio.get(getTopProducts);

      if (response.data["status"]) {
        setState(() {
          topProducts = response.data["results"].sublist(0, 4);
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

  void showBuyNowDialog(product) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF232429),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            title: const Center(
              child: Text(
                "Buy Product",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: SizedBox(
              height: 240,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nama",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          product["name"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kategori",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          product["categories"]["name"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Brand",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          product["brands"]["name"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stok",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          "${product["stocks"]} Pc(s) Left",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Harga",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          currencyFormatter(product["price"]),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  product["stocks"] > 0
                      ? TextField(
                          controller: amountController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            border: const OutlineInputBorder(),
                            focusColor: AppColors.deepPurple,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.deepPurple, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        )
                      : const Center(
                          child: Text(
                            "Stok Barang Habis",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        amountController.text = "";
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        minimumSize: const Size.fromHeight(50),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  product["stocks"] > 0
                      ? SizedBox(
                          width: 120,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    if (amountController.text.isEmpty) {
                                      toastification.show(
                                          context: context,
                                          title: const Text(
                                              'Jumlah barang tidak boleh kosong!'),
                                          type: ToastificationType.error,
                                          autoCloseDuration:
                                              const Duration(seconds: 3),
                                          style:
                                              ToastificationStyle.fillColored);
                                    } else {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.confirm,
                                        title: "Beli Produk",
                                        text:
                                            'Anda akan membeli produk ${product["name"]} dengan total harga ${currencyFormatter(product["price"] * int.tryParse(amountController.text))}',
                                        confirmBtnText: "Beli",
                                        cancelBtnText: 'Batal',
                                        confirmBtnColor: Colors.green,
                                        animType:
                                            QuickAlertAnimType.slideInDown,
                                        onConfirmBtnTap: () {
                                          Navigator.of(context).pop();
                                          insertTransactionResponse(
                                              product, context);
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.deepPurple,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Beli',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        )
                      : Container()
                ],
              )
            ],
          );
        });
  }

  void insertTransactionResponse(product, BuildContext dialogContext) async {
    try {
      setState(() {
        isLoading = true;
      });

      Response response;

      var transactionData = {
        "username": userData["username"],
        "productId": product["id_product"],
        "quantity": amountController.text,
        "date": DateTime.now().toIso8601String(),
      };

      response = await dio.post(inputTransaction, data: transactionData);

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pop(dialogContext);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeUsersPage(initialIndex: 2)),
        );
      } else {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored);
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
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
    getTopProductsData();
    getCategoriesList();
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
              'Discover',
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
                                          const HomeUsersPage(initialIndex: 2)),
                                );
                              },
                              icon: const Icon(
                                Icons.receipt,
                                size: 14,
                              ),
                              label: const Text(
                                'Transaksi Anda',
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeUsersPage(initialIndex: 2)),
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
            'Produk Teratas',
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
                  childAspectRatio: 0.515,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(topProducts.length, (index) {
                    var product = topProducts[index];
                    String formattedPrice = currencyFormatter(product['price']);
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ProductDetailsPage.routeName,
                            arguments: product);
                      },
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
                                  fit: BoxFit.cover,
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
                                        color: Colors.grey[400],
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showBuyNowDialog(product);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan,
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
          const SizedBox(height: 32),
          const Text(
            'Kategori',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(categoriesList.length, (index) {
              var category = categoriesList[index];
              return GestureDetector(
                onTap: () {
                  // TODO: Add Navigator to dynamic route for Categories page
                },
                child: Card(
                  elevation: 2,
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${category["name"]}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${category["totalProducts"]} ${category["totalProducts"] > 1 ? 'Products' : 'Product'}",
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
