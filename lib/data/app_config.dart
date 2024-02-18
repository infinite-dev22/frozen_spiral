import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/database/reports/models/cause_list_report.dart';
import 'package:smart_case/database/reports/models/done_activities_report.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/database/task/task_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_form_item_list_item.dart';
import 'package:smart_case/util/smart_case_init.dart';

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
bool refreshInvoices = false;

Map<DateTime, List<SmartEvent>> preloadedEvents =
    <DateTime, List<SmartEvent>>{};
List<SmartRequisition> preloadedRequisitions = List.empty(growable: true);
List<SmartActivity> preloadedActivities = List.empty(growable: true);
List<SmartFile> preloadedFiles = List.empty(growable: true);
List<SmartDrawer> preloadedDrawers = List.empty(growable: true);
List<SmartClient> preloadedClients = List.empty(growable: true);
List<SmartEngagement> preloadedEngagements = List.empty(growable: true);
List<SmartEngagementType> preloadedEngagementTypes = List.empty(growable: true);
List<SmartEmployee> preloadedApprovers = List.empty(growable: true);
List<SmartCauseListReport> preloadedCauseList = List.empty(growable: true);
List<SmartDoneActivityReport> preloadedDoneActivities =
    List.empty(growable: true);
List<SmartInvoiceItem> preloadedInvoiceItems = List.empty(growable: true);
List<SmartTaxType> preloadedTaxTypes = List.empty(growable: true);
List<SmartInvoiceType> preloadedInvoiceTypes = List.empty(growable: true);
List<SmartBank> preloadedBanks = List.empty(growable: true);
List<SmartEmployee> preloadedInvoiceApprovers = List.empty(growable: true);
List<InvoiceFormItem> invoiceFormItemList = List.empty(growable: true);
List<SmartInvoice> preloadedInvoices = List.empty(growable: true);
List<SmartTask> preloadedTasks = List.empty(growable: true);
String? ttlSubAmount;
String? ttlAmount;
String? ttlTaxableAmount;

List<InvoiceFormItemListItem> invoiceFormItemListItemList =
    List.empty(growable: true);

String? requisitionNextPage =
    "${currentUser.url}/api/accounts/cases/requisitions/allapi?page=1";

int? pagesLength = 1;
