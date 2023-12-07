import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_client.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_model.dart';

class SmartEngagement {
  int? id;
  DateTime? date;
  DateTime? from;
  DateTime? to;
  String? description;
  String? cost;
  String? costDescription;
  DateTime? notifyOn;
  DateTime? notifyOnAt;
  int? isNextEngagement;
  int? clientId;
  int? engagementTypeId;
  SmartClient? client;
  List<SmartEmployee>? doneBy;
  SmartEngagementType? engagementType;
  List<SmartEmployee>? notifyWith;

  SmartEngagement({
    this.id,
    this.date,
    this.from,
    this.to,
    this.description,
    this.cost,
    this.costDescription,
    this.notifyOn,
    this.notifyOnAt,
    this.isNextEngagement,
    this.clientId,
    this.engagementTypeId,
    this.client,
    this.doneBy,
    this.engagementType,
    this.notifyWith,
  });

  SmartEngagement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = DateTime.parse(json['date']);
    from = DateTime.parse(json['from']);
    to = DateTime.parse(json['to']);
    description = json['description'];
    cost = json['cost'];
    costDescription = json['cost_description'];
    notifyOn =
        json['notify_on'] != null ? DateTime.parse(json['notify_on']) : null;
    notifyOnAt = json['notify_on_at'] != null
        ? DateTime.parse(json['notify_on_at'])
        : null;
    isNextEngagement = json['is_next_engagement'];
    clientId = json['client_id'];
    engagementTypeId = json['engagement_type_id'];
    client =
        json['client'] != null ? SmartClient.fromJson(json['client']) : null;
    doneBy = List<SmartEmployee>.from(
        json['done_by'].map((doc) => SmartEmployee.fromJson(doc)));
    engagementType = json['engagement_type'] != null
        ? SmartEngagementType.fromJson(json['engagement_type'])
        : null;
    notifyWith = List<SmartEmployee>.from(
        json['notify_with'].map((doc) => SmartEmployee.fromJson(doc)));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': DateFormat('dd/MM/yyyy').format(date!),
      'from': DateFormat('h:mm a').format(from!),
      'to': DateFormat('h:mm a').format(to!),
      'description': description,
      'cost': cost,
      'cost_description': costDescription,
      'notify_on': DateFormat('dd/MM/yyyy').format(notifyOn!),
      'notify_on_at': DateFormat('h:mm a').format(notifyOnAt!),
      'is_next_engagement': isNextEngagement,
      'client_id': clientId,
      'engagement_type_id': engagementTypeId,
      'client': client?.toJson(),
      'engagement_type': engagementType?.toJson(),
      'notify_with': List<String>.from(
          notifyWith!.map((smartEmployee) => smartEmployee.id.toString())),
      'done_by': List<String>.from(
          doneBy!.map((smartEmployee) => smartEmployee.id.toString())),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'description': description,
      'date': DateFormat('dd/MM/yyyy').format(date!),
      'from': DateFormat('hh:mm a').format(from!),
      'to': DateFormat('hh:mm a').format(to!),
      'engagement_type_id': engagementTypeId,
      'client_id': clientId,
      'cost': cost,
      'cost_description': costDescription,
      'is_next_engagement': isNextEngagement,
      'notify_on': DateFormat('dd/MM/yyyy').format(notifyOn!),
      'notify_on_at': DateFormat('hh:mm a').format(notifyOnAt!),
      'notify_with': List<String>.from(
          notifyWith!.map((smartEmployee) => smartEmployee.id.toString())),
      'done_by': List<String>.from(
          doneBy!.map((smartEmployee) => smartEmployee.id.toString())),
    };
  }
}

class SmartEngagementType extends SmartModel {
  int? id;
  String? name;
  String? code;
  String? description;
  int? isActive;

  SmartEngagementType({
    this.id,
    this.name,
    this.code,
    this.description,
    this.isActive,
  });

  SmartEngagementType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'is_active': isActive,
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
