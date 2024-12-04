import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/input_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/update_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  static String routeName = "/categories";

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final dio = Dio();
  bool isLoading = false;
  var dataCategories = [];

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232429),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category List',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            Text(
              'Dibawah merupakan list Kategori Produk yang ada di toko GameHeaven.',
              style: TextStyle(
                  color: Colors.grey[400], fontWeight: FontWeight.w100),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, InputCategoriesPage.routeName);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Category',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF121212),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                    itemBuilder: (context, index) {
                      var category = dataCategories[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "${category["name"]} (${category["totalProducts"]} Item)",
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.category,
                          color: Colors.white,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, UpdateCategoriesPage.routeName,
                                      arguments: category);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.yellow,
                                  size: 20,
                                )),
                            IconButton(
                                onPressed: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    title: "Hapus Kategori",
                                    text:
                                        'Apakah anda yakin ingin menghapus kategori ${category["name"]} ?',
                                    confirmBtnText: "Hapus",
                                    cancelBtnText: 'Batal',
                                    confirmBtnColor: Colors.red,
                                    animType: QuickAlertAnimType.slideInDown,
                                    onConfirmBtnTap: () {
                                      deleteCategoryResponse(
                                          category["id_category"]);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ))
                          ],
                        ),
                      );
                    },
                    itemCount: dataCategories.length,
                  ))
          ],
        ),
      ),
    );
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    try {
      Response response;

      response = await dio.get(getCategories);

      if (response.data["status"]) {
        dataCategories = response.data["results"];
      } else {
        dataCategories = [];
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

  void deleteCategoryResponse(idCategory) async {
    try {
      Response response;

      response = await dio.delete("$deleteCategory/$idCategory");

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        getData();
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
