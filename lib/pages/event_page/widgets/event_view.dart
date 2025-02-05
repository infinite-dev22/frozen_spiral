import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/pages/event_page/widgets/event_form.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/util/utilities.dart';
import 'package:smart_case/widgets/custom_icon_holder.dart';
import 'package:smart_case/widgets/custom_image.dart';
import 'package:smart_case/widgets/form_title.dart';

class EventView extends StatefulWidget {
  final int? eventId;

  const EventView({
    super.key,
    this.eventId,
  });

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  SmartEvent? event;
  SmartActivityStatus? activityStatus;
  int? eventId;

  @override
  Widget build(BuildContext context) {
    if (widget.eventId == null) {
      String eventIdAsString =
          ModalRoute.of(context)!.settings.arguments as String;
      eventId = int.parse(eventIdAsString);
    }

    if (event == null && eventId != null) {
      _setupData();
    }

    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return (event != null)
        ? Column(
            children: [
              CalendarViewTitle(
                  title: (event != null) ? event!.title! : '',
                  onPressed: () {
                    _buildDairyForm(context);
                  }),
              Expanded(
                child: (event != null)
                    ? ListView(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        children: [
                          Column(
                            children: [
                              (event!.url != null && event!.url!.isNotEmpty)
                                  ? CustomImage(
                                      event!.url!,
                                      isFile: false,
                                      isNetwork: true,
                                    )
                                  : const CustomIconHolder(
                                      width: 100,
                                      height: 100,
                                      radius: 100,
                                      size: 70,
                                      graphic: Icons.person_2_rounded,
                                    ),
                              const SizedBox(height: 5),
                              Text(
                                event!.fullName!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.watch_later_outlined,
                                size: 30,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  if (event!.startDate != null)
                                    Text(
                                      'from: ${DateFormat('dd/MM/yyyy - h:mm a').format(event!.startDate!)}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  const SizedBox(height: 10),
                                  if (event!.endDate != null)
                                    Text(
                                      'to:   ${DateFormat('dd/MM/yyyy - h:mm a').format(event!.endDate!)}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(indent: 5, endIndent: 5, height: 20),
                          if (event!.file != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.file_copy_rounded,
                                  size: 30,
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 70,
                                  height: 50,
                                  child: Marquee(
                                    text:
                                        "${event!.file?.fileName!} - ${event!.file?.fileNumber!} | ",
                                    velocity: 50.0,
                                    style: const TextStyle(fontSize: 18),
                                    blankSpace: 0,
                                    pauseAfterRound: const Duration(seconds: 3),
                                  ),
                                ),
                              ],
                            ),
                          if (event!.file != null)
                            const Divider(indent: 5, endIndent: 5, height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 30,
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Description',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      event!.description!,
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(indent: 5, endIndent: 5, height: 20),
                          if (event!.notifyOnDate != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.notifications_active_rounded,
                                  size: 30,
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Reminder',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      formatEventReminderDateString(
                                          event!.notifyOnDate!),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (event!.notifyOnDate != null)
                            const Divider(indent: 5, endIndent: 5, height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.people_alt_rounded,
                                size: 30,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Notify',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  if (event!.toNotify != null &&
                                      event!.toNotify!.isNotEmpty)
                                    for (var employee in event!.toNotify ?? [])
                                      Text(
                                        "• ${employee.getName()}",
                                        style: const TextStyle(fontSize: 18),
                                      )
                                  else
                                    Text(
                                      "• No people/contacts to be notified",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: AppColors.inActiveColor,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          )
        : const Center(
            child: CupertinoActivityIndicator(radius: 20),
          );
  }

  _buildDairyForm(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => DiaryForm(
        event: event,
        activity: activityStatus,
      ),
    );
  }

  _fetchEvent() async {
    Map eventResponse = await SmartCaseApi.smartFetch(
        'api/calendar/${widget.eventId}', currentUser.token);
    event = SmartEvent.fromJsonView(eventResponse);
    if (event!.activityStatusId != null) {
      Map activityStatusResponse = await SmartCaseApi.smartFetch(
          'api/admin/caseActivityStatus/${event!.activityStatusId!}',
          // Cause of not loading
          currentUser.token);
      activityStatus = SmartActivityStatus.fromJson(
          activityStatusResponse['caseActivityStatus']);
      if (mounted) setState(() {});
    }
  }

  _setupData() async {
    _fetchEvent();
  }

  @override
  void initState() {
    if (widget.eventId != null) _fetchEvent();

    super.initState();
  }
}
