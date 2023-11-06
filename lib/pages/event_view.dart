import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:smart_case/widgets/custom_icon_holder.dart';
import 'package:smart_case/widgets/form_title.dart';

import '../services/apis/smartcase_api.dart';
import '../util/smart_case_init.dart';
import 'forms/diary_form.dart';

class EventView extends StatefulWidget {
  final int eventId;

  const EventView({
    super.key,
    required this.eventId,
  });

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  SmartEvent? event;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Column(
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
                        const CustomIconHolder(
                          width: 100,
                          height: 100,
                          radius: 100,
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
                            Text(
                              'from: ${DateFormat('dd/MM/yyyy h:mm a').format(DateFormat('dd-MM-yy h:mm a').parse(DateFormat('yy-MM-dd h:mm a').format(event!.startDate!)))}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'to:   ${DateFormat('dd/MM/yyyy h:mm a').format(DateFormat('dd-MM-yy h:mm a').parse(DateFormat('yy-MM-dd h:mm a').format(event!.endDate!)))}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(indent: 5, endIndent: 5, height: 20),
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
                    const Divider(indent: 5, endIndent: 5, height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 30,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Event',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              event!.title!,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(indent: 5, endIndent: 5, height: 20),
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              DateFormat('dd/MM/yyyy h:mm a').format(
                                  DateFormat('dd-MM-yy h:mm a').parse(
                                      DateFormat('yy-MM-dd h:mm a')
                                          .format(event!.notifyOnDate!))),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            for (var event in event!.toBeNotified ?? [])
                              Text(
                                event,
                                style: const TextStyle(fontSize: 18),
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
    );
  }

  _buildDairyForm(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => DiaryForm(event: event),
    );
  }

  _fetchEvent() async {
    Map response = await SmartCaseApi.smartFetch(
        'api/calendar/${widget.eventId}', currentUser.token);
    print(response);
    event = SmartEvent.fromJsonView(response);
    setState(() {});
  }

  @override
  void initState() {
    _fetchEvent();

    super.initState();
  }
}
