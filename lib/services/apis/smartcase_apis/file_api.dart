import 'package:smart_case/data/global_data.dart';
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

    preloadedFiles = files;
    return files;
  }

  static fetch(int id, {Function()? onSuccess, Function()? onError}) async {
    FileRepo fileRepo = FileRepo();
    List<SmartFile> files = List.empty(growable: true);

    Map response = await fileRepo.fetch(id);
    List filesMap = response['search']['files'];

    if (filesMap.isNotEmpty) {
      files = filesMap
          .map(
            (file) => SmartFile.fromJson(file),
          )
          .toList();
    }

    preloadedFiles = files;
  }

  static post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    FileRepo fileRepo = FileRepo();
    // List<SmartFile> files = List.empty(growable: true);

    var response = await fileRepo.post(data, id);
    // List filesMap = response['search']['files'];
    //
    // if (filesMap.isNotEmpty) {
    //   files = filesMap
    //       .map(
    //         (file) => SmartFile.fromJson(file),
    //       )
    //       .toList();
    // }
    //
    // preloadedFiles = files;
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    FileRepo fileRepo = FileRepo();
    // List<SmartFile> files = List.empty(growable: true);

    var response = await fileRepo.put(data, id);
    // List filesMap = response['search']['files'];
    //
    // if (filesMap.isNotEmpty) {
    //   files = filesMap
    //       .map(
    //         (file) => SmartFile.fromJson(file),
    //       )
    //       .toList();
    // }
    //
    // preloadedFiles = files;
    return response;
  }
}
