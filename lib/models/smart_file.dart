import 'package:smart_case/models/smart_model.dart';

class SmartFile extends SmartModel {
  int id;
  String fileName;
  String fileNumber;
  dynamic dateOpened;
  String clientName;
  String? status;

  SmartFile({
    required this.id,
    required this.fileName,
    required this.fileNumber,
    required this.dateOpened,
    required this.clientName,
    required this.status,
  });

  factory SmartFile.fromJson(Map json) {
    return SmartFile(
      id: json["id"],
      fileName: json["file_name"],
      fileNumber: json["file_number"],
      dateOpened: json["date_opened"],
      clientName: json["client_name"],
      status: json["Status"],
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
    };
  }

  @override
  int getId() {
    return id;
  }

  @override
  String getName() {
    return fileName;
  }
}
