import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/entities/event.dart';

String dateToDD_MM_YY(DateTime dateTime){
  return dateTime.day.toString() + '-'
      + dateTime.month.toString() + '-'
      + dateTime.year.toString();
}

String dateToYY_MM_DD(DateTime dateTime){
  return dateTime.year.toString() + '-'
      + dateTime.month.toString() + '-'
      + dateTime.day.toString();
}

List<IconData> iconList = [Icons.sports_esports, Icons.dinner_dining, Icons.flight_outlined,
Icons.sports_basketball, Icons.sports_baseball_rounded, Icons.sports_football,
Icons.sports_soccer, Icons.group, Icons.medical_services, Icons.beach_access,
Icons.live_tv, Icons.draw, Icons.school];


List<String> eventTypeList = ['Anniversary', 'Class', 'Meeting'];
LinkedHashMap eventMap = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode
);

Event tappedEvent;

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final today = DateTime.now();
final firstDay = DateTime(today.year - 3, today.month, today.day);
final lastDay = DateTime(today.year + 3, today.month, today.day);