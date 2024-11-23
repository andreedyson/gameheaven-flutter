import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/input_brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/update_brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/input_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/update_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/input_transaction.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/update_transaction.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
        child: MaterialApp(
      title: 'UAS Pemrograman 4 Andre Edyson',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Onest'),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomeAdminPage.routeName: (context) => const HomeAdminPage(),
        BrandsPage.routeName: (context) => const BrandsPage(),
        InputBrandsPage.routeName: (context) => const InputBrandsPage(),
        UpdateBrandsPage.routeName: (context) => const UpdateBrandsPage(),
        CategoriesPage.routeName: (context) => const CategoriesPage(),
        InputCategoriesPage.routeName: (context) => const InputCategoriesPage(),
        UpdateCategoriesPage.routeName: (context) =>
            const UpdateCategoriesPage(),
        TransactionsPage.routeName: (context) => const TransactionsPage(),
        InputTransactionPage.routeName: (context) =>
            const InputTransactionPage(),
        UpdateTransactionPage.routeName: (context) =>
            const UpdateTransactionPage()
      },
    ));
  }
}