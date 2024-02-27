import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/currency/currency_repo.dart';
import 'package:smart_case/database/currency/smart_currency.dart';

class CurrencyApi {
  static Future<List<SmartCurrency>> fetchAll() async {
    CurrencyRepo currencyRepo = CurrencyRepo();
    List<SmartCurrency> currencies = List.empty(growable: true);

    var response = await currencyRepo.fetchAll();
    List currenciesList = response['currencytypes'];

    if (currenciesList.isNotEmpty) {
      currencies = currenciesList.map((doc) => SmartCurrency.fromJson(doc)).toList();
    }

    preloadedCurrencies.clear();
    preloadedCurrencies = currencies;
    return currencies;
  }
}
