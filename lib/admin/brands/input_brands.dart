import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';

class InputBrandsPage extends StatefulWidget {
  const InputBrandsPage({super.key});

  static String routeName = "/input-brands";

  @override
  State<InputBrandsPage> createState() => _InputBrandsPageState();
}

class _InputBrandsPageState extends State<InputBrandsPage> {
  final dio = Dio();
  bool isLoading = false;

  TextEditingController idBrandController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Input Brand',
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
              'Masukan Brand',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            Text(
              'Silakan masukkan nama brand yang ingin ditambahkan.',
              style: TextStyle(
                  color: Colors.grey[400], fontWeight: FontWeight.w100),
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              controller: idBrandController,
              decoration: InputDecoration(
                labelText: 'Kode Brand',
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
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Brand',
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
              keyboardType: TextInputType.text,
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
                      ? const Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (idBrandController.text.isEmpty) {
                              toastification.show(
                                  context: context,
                                  title: const Text(
                                      'Kode Brand Tidak Boleh Kosong!'),
                                  type: ToastificationType.error,
                                  autoCloseDuration: const Duration(seconds: 3),
                                  style: ToastificationStyle.fillColored);
                            } else if (nameController.text.isEmpty) {
                              toastification.show(
                                  context: context,
                                  title: const Text(
                                      'Nama Brand Tidak Boleh Kosong!'),
                                  type: ToastificationType.error,
                                  autoCloseDuration: const Duration(seconds: 3),
                                  style: ToastificationStyle.fillColored);
                            } else if (idBrandController.text.length > 4) {
                              toastification.show(
                                  context: context,
                                  title: const Text(
                                      'Kode Brand Maksimal 4 Karakter!'),
                                  type: ToastificationType.error,
                                  autoCloseDuration: const Duration(seconds: 3),
                                  style: ToastificationStyle.fillColored);
                            } else {
                              insertBrandResponse();
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

  void insertBrandResponse() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;

      response = await dio.post(inputBrand, data: {
        "id_brand": idBrandController.text,
        "name": nameController.text
      });

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeAdminPage(initialIndex: 3),
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
}
