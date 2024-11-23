import 'package:flutter/material.dart';
import 'package:uas_pemrograman_4_22411002_andreedyson/admin/home_admin.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomeAdminPage.routeName);
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  )),
              const Text(
                'Transaction',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, InputTransactionPage.routeName);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: const Color(0xFF232429));
  }
}
