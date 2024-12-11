import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/input_brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/brands/update_brands.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/input_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/categories/update_categories.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/products/input_product.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/products/products.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/products/update_products.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/input_transaction.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/transactions.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/update_transaction.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/login_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/auth/register_page.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/home_users.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/products/details/product_details.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/products/user_products.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/users/transactions/user_transactions.dart';

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
          HomeUsersPage.routeName: (context) => const HomeUsersPage(),
          BrandsPage.routeName: (context) => const BrandsPage(),
          InputBrandsPage.routeName: (context) => const InputBrandsPage(),
          UpdateBrandsPage.routeName: (context) => const UpdateBrandsPage(),
          CategoriesPage.routeName: (context) => const CategoriesPage(),
          InputCategoriesPage.routeName: (context) =>
              const InputCategoriesPage(),
          UpdateCategoriesPage.routeName: (context) =>
              const UpdateCategoriesPage(),
          TransactionsPage.routeName: (context) => const TransactionsPage(),
          InputTransactionPage.routeName: (context) =>
              const InputTransactionPage(),
          UpdateTransactionPage.routeName: (context) =>
              const UpdateTransactionPage(),
          ProductsPage.routeName: (context) => const ProductsPage(),
          InputProductsPage.routeName: (context) => const InputProductsPage(),
          UpdateProductsPage.routeName: (context) => const UpdateProductsPage(),
          UserProductsPage.routeName: (context) => const UserProductsPage(),
          UserTransactionsPage.routeName: (context) =>
              const UserTransactionsPage(),
          ProductDetailsPage.routeName: (context) => const ProductDetailsPage(),
        }));
  }
}
