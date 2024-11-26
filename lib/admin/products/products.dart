import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/products/input_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  static String routeName = "/products";

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
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
              'Product List',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            Text(
              'Dibawah merupakan daftar Produk yang dijual di toko GameHeaven.',
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
                    Navigator.pushNamed(context, InputProductsPage.routeName);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Product',
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
          ],
        ),
      ),
    );
  }
}
