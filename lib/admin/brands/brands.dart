import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/input_brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/update_brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  static String routeName = "/brands";

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final dio = Dio();
  bool isLoading = false;
  var dataBrands = [];

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
              'Brand List',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            Text(
              'Dibawah merupakan list Brand yang terafiliasi dengan toko GameHeaven.',
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
                    Navigator.pushNamed(context, InputBrandsPage.routeName);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Brand',
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
            Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          var brand = dataBrands[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "${brand["id_brand"]} (${brand["name"]})",
                              style: const TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(
                              Icons.branding_watermark,
                              color: Colors.white,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, UpdateBrandsPage.routeName,
                                          arguments: brand);
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
                                        title: "Hapus Brand",
                                        text:
                                            'Apakah anda yakin ingin menghapus brand ${brand["name"]} ?',
                                        confirmBtnText: "Hapus",
                                        cancelBtnText: 'Batal',
                                        confirmBtnColor: Colors.red,
                                        animType:
                                            QuickAlertAnimType.slideInDown,
                                        onConfirmBtnTap: () {
                                          deleteBrandResponse(
                                              brand["id_brand"]);
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
                        itemCount: dataBrands.length,
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

      response = await dio.get(getBrands);

      if (response.data["status"]) {
        dataBrands = response.data["results"];
      } else {
        dataBrands = [];
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

  void deleteBrandResponse(idBrand) async {
    try {
      Response response;

      response = await dio.delete(deleteBrand, data: {"id_brand": idBrand});

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
