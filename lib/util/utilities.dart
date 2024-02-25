import 'package:intl/intl.dart';

DateTime formatStringDMY(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  DateTime dateTime =
  DateFormat('dd/MM/yyyy'/*'yyyy-MM-dd hh:mm:ss a'*/).parse(dateTimeString);

  // Format the DateTime object using the desired format.
  String formattedDateString = DateFormat('dd/MM/yyyy').format(dateTime);

  // Format the DateTime object using the desired format.
  DateTime formattedDate =
  DateFormat('dd/MM/yyyy').parse(formattedDateString);

  // Return the formatted date string.
  return formattedDate;
}

DateTime formatStringDateTime(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  DateTime dateTime =
  DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ'/*'yyyy-MM-dd hh:mm:ss a'*/).parse(dateTimeString);

  // Format the DateTime object using the desired format.
  String formattedDateString = DateFormat('dd/MM/yyyy').format(dateTime);

  // Format the DateTime object using the desired format.
  DateTime formattedDate =
  DateFormat('dd/MM/yyyy').parse(formattedDateString);

  // Return the formatted date string.
  return formattedDate;
}

String formatStringDateTimeString(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTimeString);

  // Format the DateTime object using the desired format.
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  // Return the formatted date string.
  return formattedDate;
}

String formatDateTimeToString(DateTime dateTime) {
  // Format the DateTime object using the desired format.
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  // Return the formatted date string.
  return formattedDate;
}