import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/smart_model.dart';

class SmartDrawer extends SmartModel {
  int? id;
  String? name;
  String? description;
  double? openingBalance;
  int? currencyId;
  SmartCurrency? currency;

  SmartDrawer({
    this.id,
    this.name,
    this.description,
    this.openingBalance,
    this.currencyId,
    this.currency,
  });

  SmartDrawer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    openingBalance = double.parse(json['opening_balance']);
    currencyId = json['currency_id'];
    currency = json['currency'] != null
        ? SmartCurrency.fromJson(json['currency'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'opening_balance': openingBalance,
      'currency_id': currencyId,
      'currency': currency?.toJson(),
    };
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return "$name | ${currency!.code}$openingBalance";
  }
}
