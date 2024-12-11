import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});
  static String routeName = "/product-details";

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
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
    );
  }
}
