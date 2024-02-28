import 'package:intl/intl.dart';

DateTime formatDate(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTimeString);

  // Format the DateTime object using the desired format.
  String formattedDateString = DateFormat('dd/MM/yyyy').format(dateTime);

  // Format the DateTime object using the desired format.
  DateTime formattedDate = DateFormat('dd/MM/yyyy').parse(formattedDateString);

  // Return the formatted date string.
  return formattedDate;
}

DateTime formatEventReminderDate(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTimeString);

  // Format the DateTime object using the desired format.
  String formattedDateString =
      DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);

  // Format the DateTime object using the desired format.
  DateTime formattedDate =
      DateFormat('dd/MM/yyyy hh:mm a').parse(formattedDateString);

  // Return the formatted date string.
  return formattedDate;
}

String formatEventReminderDateString(DateTime dateTimeString) {
  // Parse the date and time string into a DateTime object.
  String dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').format(dateTimeString);

  // Format the DateTime object using the desired format.
  DateTime formattedDateString =
      DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTime);

  // Format the DateTime object using the desired format.
  String formattedDate =
      DateFormat('dd/MM/yyyy - hh:mm a').format(formattedDateString);

  // Return the formatted date string.
  return formattedDate;
}

DateTime formatTime(String dateTimeString) {
  // Parse the date and time string into a DateTime object.
  print("B4: $dateTimeString");
  DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTimeString);
  print("After1: $dateTime");

  // Format the DateTime object using the desired format.
  String formattedDateString = DateFormat('hh:mm:ss a').format(dateTime);
  print("After2: $formattedDateString");

  // Format the DateTime object using the desired format.
  DateTime formattedDate = DateFormat('hh:mm:ss a').parse(formattedDateString);
  print("Final: $formattedDate");

  // Return the formatted date string.
  return formattedDate;
}
