import 'package:smart_case/models/smart_model.dart';

class Partner extends SmartModel{
  int id;
  String? initials;
  String? firstName;
  String? middleName;
  String? lastName;

  Partner({
    required this.id,
    required this.initials,
    required this.firstName,
    this.middleName,
    required this.lastName,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      initials: json['initials'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
    );
  }

  @override
  int getId() {
    return id;
  }

  @override
  String getName() {
    return "$firstName ${(middleName == null) ? "$middleName " : ""}$lastName";
  }
}