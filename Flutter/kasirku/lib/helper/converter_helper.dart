import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ConverterHelper {
  static String toDate(String dateTimeString) {
    DateTime dateTimeUtc = DateTime.parse(dateTimeString);
    DateTime dateTimeWib = dateTimeUtc.toLocal();
    String formattedDate = DateFormat('HH:mm dd-MM-yyyy').format(dateTimeWib);
    return formattedDate;
  }

  static String toRupiah(int number) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
        .format(number);
  }
}
