import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/model/product_model.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/model/user_model.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';

class UpdateTransactionPage extends StatefulWidget {
  const UpdateTransactionPage({super.key});

  static String routeName = "/edit-transactions";

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  final dio = Dio();
  bool isLoading = false;

  ProductModel? _selectedProduct;
  UserModel? _selectedUser;
  String? _selectedStatus;
  DateTime? _selectedDate;
  TextEditingController qtyController = TextEditingController();
  int idTransaction = 0;

  Future<List<ProductModel>> getProductsData() async {
    try {
      Response response;

      response = await dio.get(getProducts);

      final data = response.data["results"];
      if (data != null) {
        return ProductModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  Future<List<UserModel>> getUsersData() async {
    try {
      Response response;

      response = await dio.get(getUsers);

      final data = response.data["results"];
      if (data != null) {
        return UserModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
    return [];
  }

  void updateTransactionResponse() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      Response response;

      String formattedDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : '';

      var dataTransaction = {
        "username": _selectedUser?.username,
        "productId": _selectedProduct?.idProduct,
        "quantity": qtyController.text,
        "date": formattedDate,
        "status": _selectedStatus
      };

      response = await dio.put("$updateTransaction/$idTransaction",
          data: dataTransaction);

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeAdminPage(initialIndex: 4)),
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

  void deleteTransactionResponse(idTransaction) async {
    try {
      Response response;

      response = await dio.delete("$deleteTransaction/$idTransaction");

      if (response.data["status"]) {
        toastification.show(
            title: Text(response.data['message']),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeAdminPage(initialIndex: 4)),
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

    idTransaction = args["id_transactions"];
    String quantity = args["quantity"].toString();
    _selectedProduct =
        _selectedProduct ?? ProductModel.fromJson(args["products"]);
    _selectedUser = _selectedUser ?? UserModel.fromJson(args["users"]);
    _selectedStatus = _selectedStatus ?? args["status"];
    _selectedDate = _selectedDate ?? DateTime.parse(args["date"]);

    if (qtyController.text.isEmpty) {
      qtyController.text = quantity;
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Edit Transaction',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.deepPurple,
        ),
        backgroundColor: const Color(0xFF232429),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Edit Data Transaksi',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              ),
              Text(
                'Silahkan melakukan perubahan terhadap data transaksi.',
                style: TextStyle(
                    color: Colors.grey[400], fontWeight: FontWeight.w100),
              ),
              const SizedBox(
                height: 24,
              ),
              DropdownSearch<UserModel>(
                popupProps: PopupProps.dialog(
                  itemBuilder:
                      (BuildContext context, UserModel item, bool isDisabled) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        title: Text(item.fullname),
                      ),
                    );
                  },
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search User...",
                    ),
                  ),
                ),
                asyncItems: (String? filter) => getUsersData(),
                itemAsString: (UserModel? item) => item?.userAsString() ?? "",
                onChanged: (UserModel? data) {
                  setState(() {
                    _selectedUser = data;
                  });
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Search User...",
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
                selectedItem: _selectedUser,
                dropdownBuilder:
                    (BuildContext context, UserModel? selectedItem) {
                  return Text(
                    selectedItem?.fullname ?? "Select Users",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownSearch<ProductModel>(
                popupProps: PopupProps.dialog(
                  itemBuilder: (BuildContext context, ProductModel item,
                      bool isDisabled) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        title: Text(item.name),
                        leading: CircleAvatar(child: Text(item.name[0])),
                      ),
                    );
                  },
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search Product...",
                    ),
                  ),
                ),
                asyncItems: (String? filter) => getProductsData(),
                itemAsString: (ProductModel? item) =>
                    item?.userAsString() ?? "",
                onChanged: (ProductModel? data) {
                  setState(() {
                    _selectedProduct = data;
                  });
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Search User...",
                    prefixIcon:
                        const Icon(Icons.conveyor_belt, color: Colors.white),
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                ),
                selectedItem: _selectedProduct,
                dropdownBuilder:
                    (BuildContext context, ProductModel? selectedItem) {
                  return Text(
                    selectedItem?.name ?? "Select Product",
                    style: const TextStyle(
                      color: Colors.white, // Warna teks yang dipilih
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  border: Border.all(
                      color: Colors.grey, width: 1.0), // Border color
                ),
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  hint: const Text(
                    "Status",
                    style: TextStyle(color: Colors.white),
                  ),
                  dropdownColor: Colors.black, // Dropdown background color
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: "Pending",
                      child: Text("Pending",
                          style: TextStyle(color: Colors.orange)),
                    ),
                    DropdownMenuItem(
                      value: "Processing",
                      child: Text("Processing",
                          style: TextStyle(color: Colors.blue)),
                    ),
                    DropdownMenuItem(
                      value: "Completed",
                      child: Text("Completed",
                          style: TextStyle(color: Colors.green)),
                    ),
                    DropdownMenuItem(
                      value: "Cancelled",
                      child: Text("Cancelled",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                  onChanged: (String? status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  underline: const SizedBox(), // Remove the default underline
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: TextField(
                  readOnly: true, // Make it read-only to prevent manual input
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020), // Set the first date
                      lastDate: DateTime(2025), // Set the last date
                    );

                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: _selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                        : "Select Date",
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
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
                    child: ElevatedButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: "Hapus Transaksi",
                          text:
                              'Apakah anda yakin ingin menghapus transaksi ini ?',
                          confirmBtnText: "Hapus",
                          cancelBtnText: 'Batal',
                          confirmBtnColor: Colors.red,
                          animType: QuickAlertAnimType.slideInDown,
                          onConfirmBtnTap: () {
                            deleteTransactionResponse(idTransaction);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
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
                              if (_selectedUser == null) {
                                toastification.show(
                                    title: const Text("User harus dipilih!"),
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.fillColored);
                              } else if (_selectedProduct == null) {
                                toastification.show(
                                    title: const Text("Produk harus dipilih!"),
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.fillColored);
                              } else if (qtyController.text.isEmpty) {
                                toastification.show(
                                    context: context,
                                    title: const Text(
                                        'Jumlah Barang tidak boleh kosong!'),
                                    type: ToastificationType.error,
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    style: ToastificationStyle.fillColored);
                              } else if (_selectedStatus == null) {
                                toastification.show(
                                    title: const Text("Status harus dipilih!"),
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.fillColored);
                              } else if (_selectedDate == null) {
                                toastification.show(
                                    title: const Text("Tanggal harus dipilih!"),
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                    type: ToastificationType.error,
                                    style: ToastificationStyle.fillColored);
                              } else {
                                updateTransactionResponse();
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
            ])));
  }
}
