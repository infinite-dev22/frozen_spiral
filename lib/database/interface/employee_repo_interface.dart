import 'dart:io';

abstract class EmployeeRepoInterface {
  // Future<Map<String, dynamic>> fetch(int id);

  Future<File> getAvatar();

  // Future<Map<String, dynamic>> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> post(Map<String, dynamic> data, int id);

// Future<dynamic> post(Map<String, dynamic> data, int id);

// Future<Map<String, dynamic>> filter();
}
