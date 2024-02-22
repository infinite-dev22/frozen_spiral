import 'package:intl/intl.dart';

DateTime formatDateTimeString(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  DateTime dateTime =
  DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTimeString);

  // Format the DateTime object using the desired format.
  String formattedDateString = DateFormat('dd/MM/yyyy').format(dateTime);

  // Format the DateTime object using the desired format.
  DateTime formattedDate =
  DateFormat('dd/MM/yyyy').parse(formattedDateString);

  // Return the formatted date string.
  return formattedDate;
}