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
