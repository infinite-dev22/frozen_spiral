import 'package:smart_case/database/smart_model.dart';

class SmartFile extends SmartModel {
  int? id;
  final int? clientId;
  String? fileName;
  String? fileNumber;
  dynamic dateOpened;
  String? clientName;
  String? status;
  String? courtFileNumber;

  SmartFile({
    this.id,
    this.clientId,
    this.fileName,
    this.fileNumber,
    this.dateOpened,
    this.clientName,
    this.status,
    this.courtFileNumber,
  });

  factory SmartFile.fromJson(Map json) {
    return SmartFile(
      id: json["id"],
      clientId: json["client_id"],
      fileName: json["file_name"],
      fileNumber: json["file_number"],
      dateOpened: json["date_opened"],
      clientName: json["client_name"],
      status: json["Status"],
      courtFileNumber: json["court_file_number"],
    );
  }

  static toJson(SmartFile file) {
    return {
      "id": file.id,
      "file_name": file.fileName,
      "file_number": file.fileNumber,
      "date_opened": file.dateOpened,
      "client_name": file.clientName,
      "Status": file.status,
      "court_file_number": file.courtFileNumber,
    };
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return fileName!;
  }
}
