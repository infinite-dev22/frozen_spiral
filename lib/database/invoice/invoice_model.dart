import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/file/file_model.dart';

class SmartInvoice {
  final int? id;
  final SmartFile? file;
  final SmartCurrency? currency;

  SmartInvoice({
    this.id,
    this.file,
    this.currency,
  });
}
