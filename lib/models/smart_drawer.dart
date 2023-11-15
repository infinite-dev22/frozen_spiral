import 'package:smart_case/models/smart_currency.dart';

class SmartDrawer {
  int? id;
  String? name;
  String? description;
  String? openingBalance;
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
    openingBalance = json['opening_balance'];
    currencyId = json['currency_id'];
    currency = json['currency'] != null ? SmartCurrency.fromJson(json['currency']) : null;
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
}