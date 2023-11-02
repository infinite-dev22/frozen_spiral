import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:smart_case/widgets/custom_icon_holder.dart';
import 'package:smart_case/widgets/form_title.dart';

class EventView extends StatelessWidget {
  final SmartEvent event;

  const EventView({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Column(
      children: [
        CalendarViewTitle(title: event.title!),
        Expanded(
          child: ListView(
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
                    event.fullName!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: 30,
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        'from: ${event.startDate}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'to:   ${event.endDate}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(indent: 5, endIndent: 5, height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.file_copy_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 20),
                  Text(
                    event.title!,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Divider(indent: 5, endIndent: 5, height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        event.title!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(indent: 5, endIndent: 5, height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminder',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        event.notifyOnDate.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(indent: 5, endIndent: 5, height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notify',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      for (var event in event.toBeNotified ?? [])
                        Text(
                          event,
                          style: TextStyle(fontSize: 18),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
