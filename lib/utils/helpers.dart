import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(dynamic date) {
  var parsedDate = DateTime.parse(date);
  return DateFormat("MMM d, yyyy").format(parsedDate);
}

String currencyFormatter(double amount) {
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: "Rp", decimalDigits: 0);
  return formatter.format(amount);
}

Color? getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange[900];
    case 'processing':
      return Colors.blue[800];
    case 'completed':
      return Colors.green[800];
    case 'cancelled':
      return Colors.red[800];
    default:
      return Colors.grey;
  }
}
