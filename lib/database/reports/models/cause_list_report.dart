import 'package:smart_case/database/court/court_model.dart';
import 'package:smart_case/database/partner/partner_model.dart';

class SmartCauseListReport {
  int id;
  String? title;
  DateTime? date;
  String? toBeDoneBy;
  String? description;
  String? fileName;
  String? fileNumber;
  Court? court;
  String? practiceArea;
  List<Partner>? partners;

  SmartCauseListReport({
    required this.id,
    required this.title,
    required this.date,
    required this.toBeDoneBy,
    required this.description,
    required this.fileName,
    required this.fileNumber,
    required this.court,
    required this.practiceArea,
    required this.partners,
  });

  factory SmartCauseListReport.fromJson(Map<String, dynamic> json) {
    return SmartCauseListReport(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['start']),
      toBeDoneBy: json['to_be_doneby'],
      description: json['description'],
      fileName: json['file_name'],
      fileNumber: json['file_number'],
      court: (json['court'] != null) ? Court.fromJson(json['court']) : null,
      practiceArea: json['practiceArea'],
      partners: (json['partners'] != null)
          ? (json['partners'] as List)
              .map((partner) => Partner.fromJson(partner))
              .toList()
          : null,
    );
  }
}
