import '../models/smart_event.dart';
import '../models/smart_requisition.dart';

Map<DateTime, List<SmartEvent>> preloadedEvents =
<DateTime, List<SmartEvent>>{};

List<SmartRequisition> preloadedRequisitions = List.empty(growable: true);