import 'package:intl/intl.dart';

class DateFormater {
  String getDashFormat(DateTime dateToFormat) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateToFormat);
  }

  String getDotFormat(DateTime dateToFormat) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(dateToFormat);
  }
}
