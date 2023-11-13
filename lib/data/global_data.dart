import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_event.dart';

// Global options
final options = CacheOptions(
  // A default store is required for interceptor.
  store: MemCacheStore(),

  // All subsequent fields are optional.

  // Default.
  policy: CachePolicy.request,
  // Returns a cached response on error but for statuses 401 & 403.
  // Also allows to return a cached response on network errors (e.g. offline usage).
  // Defaults to [null].
  hitCacheOnErrorExcept: [401, 403],
  // Overrides any HTTP directive to delete entry past this duration.
  // Useful only when origin server has no cache config or custom behaviour is desired.
  // Defaults to [null].
  maxStale: const Duration(days: 7),
  // Default. Allows 3 cache sets and ease cleanup.
  priority: CachePriority.normal,
  // Default. Body and headers encryption with your own algorithm.
  cipher: null,
  // Default. Key builder to retrieve requests.
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  // Default. Allows to cache POST requests.
  // Overriding [keyBuilder] is strongly recommended when [true].
  allowPostMethod: false,
);

Map<DateTime, List<SmartEvent>> preloadedEvents =
    <DateTime, List<SmartEvent>>{};
List<SmartRequisition> preloadedRequisitions = List.empty(growable: true);
List<SmartActivity> preloadedActivities = List.empty(growable: true);
List<SmartFile> preloadedFiles = List.empty(growable: true);
