import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_event.dart';

Map<DateTime, List<SmartEvent>> preloadedEvents =
<DateTime, List<SmartEvent>>{};

List<SmartRequisition> preloadedRequisitions = List.empty(growable: true);