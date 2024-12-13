import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/model/brand_model.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/model/category_model.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';

class UpdateProductsPage extends StatefulWidget {
  const UpdateProductsPage({super.key});

  static String routeName = "/edit-product";

  @override
  State<UpdateProductsPage> createState() => _InputProductsPageState();
}

class _InputProductsPageState extends State<UpdateProductsPage> {
  final dio = Dio();
  bool isLoading = false;

  CategoryModel? _selectedCategory;
  BrandModel? _selectedBrand;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController stocksController = TextEditingController();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  Future<List<CategoryModel>> getCategoriesData() async {
    try {
      Response response;

      response = await dio.get(getCategories);

      final data = response.data["results"];
      if (data != null) {
        return CategoryModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  Future<List<BrandModel>> getBrandsData() async {
    try {
      Response response;

      response = await dio.get(getBrands);

      final data = response.data["results"];
      if (data != null) {
        return BrandModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  void editProductResponse(int idProduct) async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      var imgData = _imageBytes != null
          ? MultipartFile.fromBytes(_imageBytes!, filename: 'image.jpg')
          : null;

      FormData formData = FormData.fromMap({
        "name": nameController.text,
        "price": priceController.text,
        "description": descriptionController.text,
        "stocks": stocksController.text,
        "category": _selectedCategory?.idCategory,
        "brand": _selectedBrand?.idBrand,
        "image": imgData,
      });

      Response response;

      response = await dio.put("$updateProduct/${idProduct.toString()}",
          data: formData);

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeAdminPage(initialIndex: 2),
          ),
        );
      } else {
        toastification.show(
            description: Text(
              response.data['message'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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

  void deleteProductsResponse(idProduct) async {
    try {
      Response response;

      response = await dio.delete("$deleteProduct/$idProduct");

      if (response.data["status"]) {
        toastification.show(
            description: Text(response.data['message'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeAdminPage(initialIndex: 2),
          ),
        );
      } else {
        toastification.show(
            description: Text(response.data['message'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
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

    int idProduct = args["id_product"];
    String name = args["name"];
    String price = args["price"].toString();
    String description = args["description"];
    String stocks = args["stocks"].toString();
    String image = args["image"];

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        stocksController.text.isEmpty) {
      nameController.text = name;
      priceController.text = price;
      descriptionController.text = description;
      stocksController.text = stocks;
    }

    _selectedCategory =
        _selectedCategory ?? CategoryModel.fromJson(args["categories"]);
    _selectedBrand = _selectedBrand ?? BrandModel.fromJson(args["brands"]);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.deepPurple,
      ),
      backgroundColor: const Color(0xFF232429),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Data Produk',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
                Text(
                  'Silahkan melakukan perubahan terhadap data produk.',
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.w100),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "Hapus Produk",
                            text:
                                'Apakah anda yakin ingin menghapus produk ${args["name"]} ?',
                            confirmBtnText: "Hapus",
                            cancelBtnText: 'Batal',
                            confirmBtnColor: Colors.red,
                            animType: QuickAlertAnimType.slideInDown,
                            onConfirmBtnTap: () {
                              deleteProductsResponse(idProduct);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                        ),
                        label: const Text(
                          'Hapus Produk',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    border: const OutlineInputBorder(),
                    focusColor: AppColors.deepPurple,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: AppColors.deepPurple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
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
                DropdownSearch<CategoryModel>(
                  popupProps: PopupProps.dialog(
                    itemBuilder: (BuildContext context, CategoryModel item,
                        bool isDisabled) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          title: Text(item.name),
                        ),
                      );
                    },
                    showSearchBox: true,
                    searchFieldProps: const TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search Kategori...",
                      ),
                    ),
                  ),
                  asyncItems: (String? filter) => getCategoriesData(),
                  itemAsString: (CategoryModel? item) =>
                      item?.userAsString() ?? "",
                  onChanged: (CategoryModel? data) {
                    setState(() {
                      _selectedCategory = data;
                    });
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Search Kategori...",
                      prefixIcon:
                          const Icon(Icons.category, color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  selectedItem: _selectedCategory,
                  dropdownBuilder:
                      (BuildContext context, CategoryModel? selectedItem) {
                    return Text(
                      selectedItem?.name ?? "Select Kategori",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownSearch<BrandModel>(
                  popupProps: PopupProps.dialog(
                    itemBuilder: (BuildContext context, BrandModel item,
                        bool isDisabled) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          title: Text(item.name),
                        ),
                      );
                    },
                    showSearchBox: true,
                    searchFieldProps: const TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search Brand...",
                      ),
                    ),
                  ),
                  asyncItems: (String? filter) => getBrandsData(),
                  itemAsString: (BrandModel? item) =>
                      item?.userAsString() ?? "",
                  onChanged: (BrandModel? data) {
                    setState(() {
                      _selectedBrand = data;
                    });
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Search Brand...",
                      prefixIcon: const Icon(Icons.branding_watermark,
                          color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  selectedItem: _selectedBrand,
                  dropdownBuilder:
                      (BuildContext context, BrandModel? selectedItem) {
                    return Text(
                      selectedItem?.name ?? "Select Brand",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: const OutlineInputBorder(),
                    focusColor: AppColors.deepPurple,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: AppColors.deepPurple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
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
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: const OutlineInputBorder(),
                    focusColor: AppColors.deepPurple,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: AppColors.deepPurple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: stocksController,
                  decoration: InputDecoration(
                    labelText: 'Stok',
                    border: const OutlineInputBorder(),
                    focusColor: AppColors.deepPurple,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: AppColors.deepPurple, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
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
                OutlinedButton(
                  onPressed: () {
                    pickImage();
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: _imageBytes != null
                          ? AppColors.deepPurple
                          : Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Pilih Gambar',
                    style: TextStyle(
                      color: _imageBytes != null
                          ? AppColors.deepPurple
                          : Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _imageBytes != null
                    ? Center(
                        child: Image.memory(
                          _imageBytes!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Image.network("$imageUrl$image",
                            width: 300, height: 300, fit: BoxFit.cover),
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
                                if (nameController.text.isEmpty) {
                                  toastification.show(
                                      context: context,
                                      title: const Text(
                                          'Nama Produk tidak boleh kosong!',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      type: ToastificationType.error,
                                      autoCloseDuration:
                                          const Duration(seconds: 3),
                                      style: ToastificationStyle.fillColored);
                                } else if (_selectedBrand == null) {
                                  toastification.show(
                                      context: context,
                                      title: const Text('Brand harus dipilih!'),
                                      type: ToastificationType.error,
                                      autoCloseDuration:
                                          const Duration(seconds: 3),
                                      style: ToastificationStyle.fillColored);
                                } else if (priceController.text.isEmpty) {
                                  toastification.show(
                                      context: context,
                                      title: const Text(
                                          'Harga tidak boleh kosong!'),
                                      type: ToastificationType.error,
                                      autoCloseDuration:
                                          const Duration(seconds: 3),
                                      style: ToastificationStyle.fillColored);
                                } else if (stocksController.text.isEmpty) {
                                  toastification.show(
                                      context: context,
                                      title: const Text(
                                          'Jumlah Stok tidak boleh kosong!'),
                                      type: ToastificationType.error,
                                      autoCloseDuration:
                                          const Duration(seconds: 3),
                                      style: ToastificationStyle.fillColored);
                                } else {
                                  editProductResponse(idProduct);
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
