import 'package:flutter/material.dart';

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

class Event{
  String name;
  String location;
  String description;
  DateTime date;
  String type;
  Color color;
  IconData icon;

  Event(
    this.name,
    this.location,
    this.description,
    this.date,
    this.type,
    this.color,
    this.icon
  );

  @override
  String toString() {
    return name + "_"
        + location + "_"
        + description + "_"
        + type + "_"
        + color.toString() + "_"
        + date.year.toString() + "-"
        + date.month.toString() + "-"
        + date.day.toString();
  }

  String dateToString(){
    return date.day.toString() + "/"
        + date.month.toString() + "/"
        + date.year.toString();
  }

  @override
  bool operator ==(other) {
    return other is Event &&
    other.name == name &&
    other.color == color &&
    other.location == location &&
    other.type == type &&
    other.description == description &&
    other.date == date;
  }

  @override
  int get hashCode => super.hashCode;
}