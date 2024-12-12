import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/home_users.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/helpers.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/user_data.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});
  static String routeName = "/product-details";

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final dio = Dio();
  bool isLoading = false;

  var userData;
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
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        if (amountController.text.isEmpty) {
                          toastification.show(
                              context: context,
                              title: const Text(
                                  'Jumlah barang tidak boleh kosong!'),
                              type: ToastificationType.error,
                              autoCloseDuration: const Duration(seconds: 3),
                              style: ToastificationStyle.fillColored);
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
                            animType: QuickAlertAnimType.slideInDown,
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              insertTransactionResponse(product, context);
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
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
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

      await Future.delayed(const Duration(seconds: 2));
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
            builder: (context) => const HomeUsersPage(initialIndex: 2),
          ),
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
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.deepPurple,
      ),
      backgroundColor: const Color(0xFF242526),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF11181C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                showBuyNowDialog(args);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Buy Now',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Image.network(
            "$imageUrl${args["image"]}",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        args["name"],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF145da0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        args["categories"]["name"],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        args["stocks"] > 0
                            ? "${args["stocks"]} Item${args["stocks"] > 1 ? 's' : ''} •"
                            : "Out of Stocks •",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 4),
                    Text(
                      args["brands"]["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: Colors.grey[400]),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  args["description"],
                  style: const TextStyle(
                      color: Colors.white, height: 1.5, fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(currencyFormatter(args["price"]),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
