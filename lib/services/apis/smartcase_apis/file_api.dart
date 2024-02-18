import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/file/file_repo.dart';

class FileApi {
  static Future<List<SmartFile>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    FileRepo fileRepo = FileRepo();
    List<SmartFile> files = List.empty(growable: true);

    var response = await fileRepo.fetchAll();
    List filesMap = response['search']['caseFiles']['original'];

    if (filesMap.isNotEmpty) {
      files = filesMap
          .map(
            (file) => SmartFile.fromJson(file),
          )
          .toList();
    }

    preloadedFiles.clear();
    preloadedFiles = files;
    return preloadedFiles;
  }
}
