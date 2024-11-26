import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/transactions/input_transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  static String routeName = "/transactions";

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
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
              'Transaction List',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
            Text(
              'Dibawah merupakan daftar Transaksi yang ada di toko GameHeaven.',
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
                    Navigator.pushNamed(
                        context, InputTransactionPage.routeName);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Transaction',
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
