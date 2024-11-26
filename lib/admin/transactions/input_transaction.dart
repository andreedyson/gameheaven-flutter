import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';

class InputTransactionPage extends StatefulWidget {
  const InputTransactionPage({super.key});

  static String routeName = "/input-transaction";

  @override
  State<InputTransactionPage> createState() => _InputTransactionPageState();
}

class _InputTransactionPageState extends State<InputTransactionPage> {
  final dio = Dio();
  bool isLoading = false;
  var dataUsers = [];
  var dataProducts = [];
  // static List statusList = ["Pending", "Processing", "Completed", "Cancelled"];

  TextEditingController qtyController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUsersData();
    getProductsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Input Category',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: const Color(0xFF232429),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambahkan Transaksi',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            Text(
              'Silahkan masukkan transaksi baru yang ingin ditambahkan.',
              style: TextStyle(
                  color: Colors.grey[400], fontWeight: FontWeight.w100),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: const OutlineInputBorder(),
                focusColor: Colors.cyan,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 46,
                  width: 100,
                  child: isLoading
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (qtyController.text.isEmpty) {
                              toastification.show(
                                  context: context,
                                  title: const Text(
                                      'Jumlah Barang Tidak Boleh Kosong!'),
                                  type: ToastificationType.error,
                                  autoCloseDuration: const Duration(seconds: 3),
                                  style: ToastificationStyle.fillColored);
                            } else {
                              insertTransactionResponse();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              minimumSize: const Size.fromHeight(50)),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void getUsersData() async {
    try {
      Response response;

      response = await dio.get(getUsers);

      if (response.data["status"]) {
        dataUsers = response.data["results"];
      } else {
        dataUsers = [];
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    }
  }

  void getProductsData() async {
    try {
      Response response;

      response = await dio.get(getProducts);

      if (response.data["status"]) {
        dataProducts = response.data["results"];
      } else {
        dataProducts = [];
      }
    } catch (e) {
      toastification.show(
          title: const Text("Terjadi kesalahan pada server"),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored);
    }
  }

  void insertTransactionResponse() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;

      var dataTransaction = {
        "id_transactions": 0,
        "username": "usertest",
        "id_product": 1,
        "quantity": qtyController.text,
        "date": "Test",
        "status": "Test"
      };
      // TODO: Fix later after adding input

      response = await dio.post(inputTransaction, data: dataTransaction);

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushNamed(context, TransactionsPage.routeName);
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
}
