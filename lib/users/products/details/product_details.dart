import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/service/api.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/constants.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/utils/helpers.dart';

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
      backgroundColor: const Color(0xFF242526),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF11181C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Buy Now',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Image.network(
            "$imageUrl${args["image"]}",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      args["name"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF145da0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        args["categories"]["name"],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                        args["stocks"] > 0
                            ? "${args["stocks"]} Item${args["stocks"] > 1 ? 's' : ''} •"
                            : "Out of Stocks •",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 4),
                    Text(
                      args["brands"]["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: Colors.grey[400]),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  args["description"],
                  style: const TextStyle(
                      color: Colors.white, height: 1.5, fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(currencyFormatter(args["price"]),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
