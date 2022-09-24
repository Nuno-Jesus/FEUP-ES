import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

Color defaultEventColor = Colors.red;
bool notificationsSwitch = false;
bool daysNamesSwitch = true;
final List<String> listOfDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
String firstDayWeek = listOfDays[0];
StartingDayOfWeek firstDayWeekEnum = StartingDayOfWeek.monday;