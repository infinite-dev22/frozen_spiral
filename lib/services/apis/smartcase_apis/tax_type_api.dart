import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';
import 'package:smart_case/database/tax/tax_type_repo.dart';

class TaxTypeApi {
  static Future<List<SmartTaxType>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    TaxTypeRepo taxTypeRepo = TaxTypeRepo();
    List<SmartTaxType> taxTypes = List.empty(growable: true);

    var response = await taxTypeRepo.fetchAll();
    List taxTypesMap = response["taxes"]['data'];

    if (taxTypesMap.isNotEmpty) {
      taxTypes = taxTypesMap
          .map(
            (taxType) => SmartTaxType.fromJson(taxType),
          )
          .toList();
    }

    if (page == 1) {
      preloadedTaxTypes.clear();
    }
    preloadedTaxTypes.addAll(taxTypes);
    return taxTypes;
  }
}
