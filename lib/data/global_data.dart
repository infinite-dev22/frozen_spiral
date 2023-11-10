import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:smart_case/database/file/file_model.dart';

Map<DateTime, List<SmartEvent>> preloadedEvents =
    <DateTime, List<SmartEvent>>{};
List<SmartRequisition> preloadedRequisitions = List.empty(growable: true);
List<SmartActivity> preloadedActivities = List.empty(growable: true);
List<SmartFile> preloadedFiles = List.empty(growable: true);
