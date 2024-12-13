import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/home_users.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/products/details/product_details.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/helpers.dart';
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

  List products = [];
  List categories = [];
  String selectedCategory = "All";

  TextEditingController amountController = TextEditingController();

  Future<void> loadUserData() async {
    final data = await getUserData();
    setState(() {
      userData = data;
    });
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
                      border: Border.all(color: Colors.red, width: 2),
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
        Navigator.pushReplacementNamed(
          context,
          HomeUsersPage.routeName,
          arguments: 2,
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

  void getProductsData() async {
    try {
      Response response;

      response = await dio.get(getProducts);

      if (response.data["status"]) {
        var data = response.data["results"];
        setState(() {
          products = data;

          categories = data
              .map((product) => product["categories"]["name"])
              .toSet()
              .toList();

          if (!categories.contains("All")) {
            categories.insert(0, "All");
          }
        });
      } else {
        products = [];
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
    getProductsData();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == "All"
        ? products
        : products
            .where(
                (product) => product["categories"]["name"] == selectedCategory)
            .toList();

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
                                Navigator.pushReplacementNamed(
                                  context,
                                  HomeUsersPage.routeName,
                                  arguments: 3,
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/product_banner.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        if (category == "All") {
                          selectedCategory = category;
                        } else {
                          selectedCategory = selected ? category : "All";
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Filtered Products
          filteredProducts.isEmpty
              ? const Center(
                  child: Text('No Products Found.'),
                )
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  children: List.generate(filteredProducts.length, (index) {
                    final product = filteredProducts[index];
                    String formattedPrice = currencyFormatter(product["price"]);

                    return GestureDetector(
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
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 120,
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
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                          product["stocks"] > 0
                                              ? "${product["stocks"]} Item${product["stocks"] > 1 ? 's' : ''} • ${product["brands"]["name"]}"
                                              : "Barang Habis • ${product["brands"]["name"]}",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            formattedPrice,
                                            style: TextStyle(
                                                color: Colors.grey[300],
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showBuyNowDialog(product);
                                          },
                                          child: const Icon(Icons.shopping_cart,
                                              color: Colors.cyan, size: 20),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
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
