import 'package:flutter/material.dart';

import 'package:uni/view/Pages/calendar/calendar_view.dart';

class EventAppBarButton extends StatelessWidget{
  final String text;
  final IconData icon;
  final Function callback;

  EventAppBarButton(this.text, this.icon, this.callback);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(icon),
        onPressed: (){
          callback();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CalendarView())
          );
        }
    );
  }
}