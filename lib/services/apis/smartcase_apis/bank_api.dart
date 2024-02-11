import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/bank/bank_repo.dart';

class BankApi {
  static Future<List<SmartBank>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    BankRepo bankRepo = BankRepo();
    List<SmartBank> banks = List.empty(growable: true);

    var response = await bankRepo.fetchAll();
    List banksMap = response['banks'];

    if (banksMap.isNotEmpty) {
      banks = banksMap
          .map(
            (bank) => SmartBank.fromJson(bank),
          )
          .toList();
    }

    if (page == 1) {
      preloadedBanks.clear();
    }
    preloadedBanks.addAll(banks);
    return banks;
  }
}
