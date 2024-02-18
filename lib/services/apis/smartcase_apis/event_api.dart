import 'dart:convert';

import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/database/event/event_repo.dart';

class EventApi {
  static Future<Map<DateTime, List<SmartEvent>>> fetchAll(
      {Map<String, dynamic>? body,
      Function()? onSuccess,
      Function()? onError}) async {
    List<SmartEvent> _events = List.empty(growable: true);
    EventRepo eventRepo = EventRepo();
    Map<DateTime, List<SmartEvent>> events = Map<DateTime, List<SmartEvent>>();

    var response = await eventRepo.fetchAll(
      body: body,
      onSuccess: onSuccess,
      onError: onError,
    ); // Returns map instead of intended list

    print(response);

    List eventsMap = response;

    if (eventsMap.isNotEmpty) {
      List eventsList = json.decode(json.encode(eventsMap));
      _events = eventsList.map((doc) => SmartEvent.fromJson(doc)).toList();

      var dataCollection = <DateTime, List<SmartEvent>>{};
      final DateTime today = DateTime.now();
      final DateTime rangeStartDate =
          DateTime(today.year, today.month, today.day)
              .add(const Duration(days: -1000));
      final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
          .add(const Duration(days: 1000));
      for (DateTime i = rangeStartDate;
          i.isBefore(rangeEndDate);
          i = i.add(const Duration(days: 1))) {
        final DateTime date = i;
        for (int j = 0; j < _events.length; j++) {
          final SmartEvent event = SmartEvent(
            title: _events[j].title,
            startDate: _events[j].startDate,
            endDate: _events[j].endDate,
            backgroundColor: _events[j].backgroundColor,
            notifyOnDate: _events[j].notifyOnDate,
            toBeNotified: _events[j].toBeNotified,
            fullName: _events[j].fullName,
            isAllDay: false,
            description: _events[j].description,
            url: _events[j].url,
          );

          if (dataCollection.containsKey(date)) {
            final List<SmartEvent> eventsList = dataCollection[date]!;
            eventsList.add(event);
            dataCollection[date] = eventsList;
          } else {
            dataCollection[date] = [event];
          }
        }
      }

      events.addAll(dataCollection);
      preloadedEvents.addAll(dataCollection);
    }
    return events;
  }
}
