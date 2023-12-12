import 'package:smart_case/models/smart_model.dart';

class SmartClient extends SmartModel {
  int? id;
  String? name;
  String? number;
  String? tin;
  String? email;
  String? telephone;
  String? address;
  int? clientTypeId;
  int? businessIndustryId;
  int? nationId;

  SmartClient({
    this.id,
    this.name,
    this.number,
    this.tin,
    this.email,
    this.telephone,
    this.address,
    this.clientTypeId,
    this.businessIndustryId,
    this.nationId,
  });

  SmartClient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    tin = json['tin'];
    email = json['email'];
    telephone = json['telephone'];
    address = json['address'];
    clientTypeId = json['client_type_id'];
    businessIndustryId = json['business_industry_id'];
    nationId = json['nation_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'tin': tin,
      'email': email,
      'telephone': telephone,
      'address': address,
      'client_type_id': clientTypeId,
      'business_industry_id': businessIndustryId,
      'nation_id': nationId,
    };
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return name!;
  }
}
