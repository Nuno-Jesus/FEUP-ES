
import 'package:flutter/material.dart';
import 'package:uni/model/entities/event.dart';
import 'package:uni/view/Pages/calendar/calendar_view.dart';
import 'package:uni/view/Pages/calendar/edit_event_view.dart';
import 'package:uni/view/Pages/calendar/settings_view.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/calendar/my_bottom_navigation_bar.dart';

import '../../../utils/utils.dart';
import '../../Widgets/calendar/event_tile.dart';

class DailyEventsView extends StatefulWidget {
  const DailyEventsView({Key key}) : super(key: key);

  @override
  _DailyEventsViewState createState() => _DailyEventsViewState();
}

class _DailyEventsViewState extends GeneralPageViewState{
  int _selectedIndex = 0;
  DateTime today = DateTime.now();
  final ValueNotifier<List<Event>> _dailyEvents = ValueNotifier(eventMap[DateTime.now()] ?? []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: _getEventListBody(),
      ),
      bottomNavigationBar: MyBottomNavigationBar(_onBottomButtonTap, _selectedIndex),
      floatingActionButton:  FloatingActionButton (
        child: Icon(
          Icons.highlight_remove,
          size: 35,
        ),
        backgroundColor: Colors.red[400],
        onPressed: () async {
          _displayClearAlert(context);
          setState(() {});
        },
      ),
    );
  }

  void _onBottomButtonTap(index){
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 1){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CalendarView())
        );
      }

      else if(_selectedIndex == 2){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingsView())
        );
      }
    });
  }

  Widget _getEmptyStateBody(){
    /*_dailyEvents.value.length == 0 ?
          _getEmptyStateBody() :
            _getEventListBody()*/
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: MediaQuery.of(context).size.height * 0.15
      ),
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.6,
        backgroundColor: Colors.grey,
        child: Column(
          children: [
            Center(
              child: Icon(
                Icons.coffee,
                size: MediaQuery.of(context).size.width * 0.5,
                color: Color.fromARGB(200, 0x75, 0x17, 0x1e),
              ),
            ),
            const Text(
              "Looks like you don't have anything scheduled for today. Free day!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getEventListBody(){
    return ValueListenableBuilder<List<Event>>(
      valueListenable: _dailyEvents,
      builder: (context, value, _) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return EventTile(
              event: value[index],
              onDelete: (){
                Future.delayed(
                    const Duration(seconds: 0),
                        () => _displayWarningAlert(context, value[index]));
              },
              onEdit: () async{
                tappedEvent = value[index];
                Future.delayed(const Duration(seconds: 0),
                        () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditEvent())
                      );
                      setState(() {});
                    }
                );
              },
            );
          },
        );
      },
    );
  }

  void _displayClearAlert(BuildContext context){
    showDialog(
        context: context,
        builder:(BuildContext bc){
          return AlertDialog(
            title: const Text('Delete today events?'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 60,
                  maxWidth: 80
              ),
              child: const Center(
                  child: Text(
                    'The events for today will be erased, and you cannot undo this.',
                    style: TextStyle(color: Colors.grey)
                  )
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('No'),
                    onPressed: () => Navigator.pop(bc),
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: (){
                      eventMap[today].clear();
                      setState(() {});
                      Navigator.pop(bc);
                    },
                  ),
                ],
              )
            ],
          );
        }
    );
  }

  void _displayWarningAlert(BuildContext context, Event event){
    showDialog(
      context: context,
      builder:(BuildContext bc){
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
                maxHeight: 50,
                maxWidth: 80
            ),
            child: const Center(
                child: Text(
                  'Once the event is deleted you cannot undo it.',
                  style: TextStyle(color: Colors.grey),)
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.pop(bc),
                ),
                TextButton(
                  key: Key('Yes Button'),
                  child: const Text('Yes'),
                  onPressed: (){
                    eventMap[event.date].remove(event);
                    setState(() {});
                    Navigator.pop(bc);
                  },
                ),
              ],
            )
          ],
        );
      }
    );
  }
}