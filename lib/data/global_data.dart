import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:smart_case/util/smart_case_init.dart';

import '../database/client/client_model.dart';
import '../models/smart_drawer.dart';

// Global options
final baseOps = BaseOptions(
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
);

final options = CacheOptions(
  // A default store is required for interceptor.
  store: MemCacheStore(),

  // All subsequent fields are optional.

  // Default.
  policy: CachePolicy.request,
  // Returns a cached response on error but for statuses 401 & 403.
  // Also allows to return a cached response on network errors (e.g. offline usage).
  // Defaults to [null].
  // hitCacheOnErrorExcept: [401, 403],
  // Overrides any HTTP directive to delete entry past this duration.
  // Useful only when origin server has no cache config or custom behaviour is desired.
  // Defaults to [null].
  // maxStale: const Duration(days: 7),
  // Default. Allows 3 cache sets and ease cleanup.
  priority: CachePriority.normal,
  // Default. Body and headers encryption with your own algorithm.
  // cipher: null,
  // Default. Key builder to retrieve requests.
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  // Default. Allows to cache POST requests.
  // Overriding [keyBuilder] is strongly recommended when [true].
  allowPostMethod: false,
);

bool refreshRequisitions = false;

Map<DateTime, List<SmartEvent>> preloadedEvents =
    <DateTime, List<SmartEvent>>{};
List<SmartRequisition> preloadedRequisitions = List.empty(growable: true);
List<SmartActivity> preloadedActivities = List.empty(growable: true);
List<SmartFile> preloadedFiles = List.empty(growable: true);
List<SmartDrawer> preloadedDrawers = List.empty(growable: true);
List<SmartActivity> preloadedCauseListReport = List.empty(growable: true);
List<SmartActivity> preloadedDoneActivitiesReport = List.empty(growable: true);
List<SmartClient> preloadedClients = List.empty(growable: true);
List<SmartEngagementType> preloadedEngagements = List.empty(growable: true);
List<SmartEmployee> preloadedApprovers = List.empty(growable: true);

String? requisitionNextPage =
    "${currentUser.url}/api/accounts/cases/requisitions/allapi?page=1";

int? pagesLength = 1;
