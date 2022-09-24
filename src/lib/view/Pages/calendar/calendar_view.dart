
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import 'package:uni/model/entities/event.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:uni/view/Pages/calendar/add_event_view.dart';
import 'package:uni/view/Pages/calendar/daily_events_view.dart';
import 'package:uni/view/Pages/calendar/edit_event_view.dart';
import 'package:uni/view/Pages/calendar/event_view.dart';
import 'package:uni/view/Pages/calendar/settings_view.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/calendar/event_tile.dart';
import 'package:uni/view/Widgets/calendar/my_bottom_navigation_bar.dart';


import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import '../../../model/app_state.dart';
import '../../../model/entities/lecture.dart';
import '../../../utils/settings.dart';
import '../../../utils/utils.dart';

import '../../Widgets/navigation_drawer.dart';


class CalendarView extends StatefulWidget {
  const CalendarView({Key key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends GeneralPageViewState {
  ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  int _selectedIndex = 1;
  List<Lecture> lectures;

  bool wereLecturesFetched = false;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return eventMap[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _showSynchDialog(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Center(child: new Text('Synchronization', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                      children: <Widget>[
                        TextButton(
                          child: new Text('No, take me back.'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ]
                  ),
                  SizedBox(height: 10, width: 30),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                      children: <Widget>[
                        TextButton(
                          key: Key('Confirm Button'),
                          child: new Text('Sync it.'),
                          onPressed: () async{
                            await _getSigarraEvent(dateToYY_MM_DD(DateTime.now()));
                            setState(() {});
                            Navigator.pop(context);
                          },
                        )
                      ]
                  )
              ]
          )

            ],
          );
      }
    );
  }

  void _getSigarraEvent(var d) async{
    final response =
        await http.Client().get(Uri.parse('https://sigarra.up.pt/feup/pt/noticias_geral.eventos?p_g_eventos=0&P_dia=$d'));

    if (response.statusCode == 200) {
      final document = parse(response.body);
      final elements = document.getElementsByTagName('td');

      List<String> title = [];
      List<String> href_link = [];
      int li_size;

      for(var i = 0; i < elements.length; i++) {
        if(elements.elementAt(i).attributes.containsValue('topo')){
          li_size = elements.elementAt(i).querySelectorAll('li').length;

          for(var j = 0; j < li_size; j++) {
            title.add(elements.elementAt(i).querySelectorAll('li > a')[j].text);
            href_link.add(elements.elementAt(i).querySelectorAll('li > a')[j].attributes['href']);
          }
        }
      }

      for(var i = 0; i < li_size; i++){
        final Event newEvent = Event(title[i], 'Rua Doutor Roberto Frias', '',
            today, 'University', Colors.black, Icons.people_alt);

        if(!eventMap.containsKey(DateTime.now()) || eventMap[DateTime.now()].length == 0){
          List<Event> newList = [];
          newList.add(newEvent);
          eventMap[DateTime.now()] = newList;
        }

        else {
          if(!eventMap[DateTime.now()].contains(newEvent)){
            eventMap[DateTime.now()].add(newEvent);
          }
        }

        setState(() {});
      }

      for(Lecture l in lectures){
        if(l.day != DateTime.now().weekday - 1) continue;

        final Event newEvent = Event(l.subject, 'Rua Doutor Roberto Frias', l.classNumber,
          today, 'Class', Color.fromARGB(255, 0x75, 0x17, 0x1e), Icons.school);

        if(!eventMap.containsKey(newEvent.date) || eventMap[newEvent.date].length == 0){
          List<Event> newList = [];
          newList.add(newEvent);
          eventMap[DateTime.now()] = newList;
        }

        else {
          if (!eventMap[DateTime.now()].contains(newEvent)) {
            eventMap[DateTime.now()].add(newEvent);
          }
        }

        setState(() {});
      }

    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: NavigationDrawer(parentContext: context),
      body: StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['schedule'],
            store.state.content['scheduleStatus']),
        builder: (context, lectureData) {
          lectures = lectureData.item1;
          return Column(
            children: [
              TableCalendar<Event>(
                firstDay: firstDay,
                lastDay: lastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                startingDayOfWeek: firstDayWeekEnum,
                daysOfWeekVisible: daysNamesSwitch,
                pageJumpingEnabled: true,
                calendarStyle: CalendarStyle(
                    outsideDaysVisible: true,
                    markersMaxCount: 0
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: _getCustomCalendarHeader,
                  todayBuilder: _getCustomTodayBuilder,
                  defaultBuilder: _getCustomDefaultBuilder,
                ),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return EventTile(
                          event: value[index],
                          onDelete: () async {
                            Future.delayed(
                              const Duration(seconds: 0),
                                () => _displayWarningAlert(context, value[index]));
                            setState(() {});
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
                          }
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(_onBottomButtonTap, _selectedIndex),
      floatingActionButton:  FloatingActionButton (
        key: const Key('Add Event'),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEvent())
          );
          setState(() {});
        },
      ),
    );
  }

  void _onBottomButtonTap(index){
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 0){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DailyEventsView())
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

  Widget _getCustomCalendarHeader(BuildContext context, DateTime date){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 120.0,
          child: Center(
              child: Text(
                  DateFormat.yMMMM().format(date)
              )
          ),
        ),
        Container(
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: IconButton(
                        key: const Key('searchButton'),
                        icon: const Icon(Icons.search,size: 26.0),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: MySearchDelegate(),
                          );
                        }
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: IconButton(
                        key: const Key('Sync Button'),
                        icon: const Icon(Icons.sync,size: 26.0),
                        onPressed: () {
                          _showSynchDialog();
                        }
                    )
                ),
              ],
            )
        )
      ],
    );
  }

  Widget _getCustomDefaultBuilder(BuildContext context, DateTime day, DateTime focusedDay){
    if(!eventMap.containsKey(day)){
      return Center(
        child: Container(
          child: Text(
            day.day.toString(),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          color: eventMap[day][0].color
        ),
        child: Center(
            child: Text(
              day.day.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            )
        ),
      ),
    );
  }

  Widget _getCustomTodayBuilder(BuildContext context, DateTime d1, DateTime d2){
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.5,
            color: Color.fromARGB(255, 0x75, 0x17, 0x1e)
          ),
        ),
        child: Center(
            child: Text(
                d1.day.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            )
        ),
      ),
    );
  }

  void _displayWarningAlert(BuildContext context, Event event){
    showDialog(
        context: context,
        builder:(BuildContext bc){
          return AlertDialog(
              title: const Text('Are you sure'),
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
                      child: Text('No'),
                      onPressed: () => Navigator.pop(bc),
                    ),
                    TextButton(
                      key: Key('Yes'),
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

class MySearchDelegate extends SearchDelegate{
  List events = [];
  List list = [];

  MySearchDelegate(){
    eventMap.entries.forEach((e) => list.addAll(e.value));

    for (var element in list) {
      events.add(element.name);
    }
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: (){
        if(query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      },
    ),
  ];

  @override
  Widget buildResults(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.event, size: 120),
        const SizedBox(height: 48),
        Text(
          query,
          key: const Key('searchResults'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 64,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? events : events.where((event) {
      final eventLower = event.toLowerCase();
      final queryLower = query.toLowerCase();

      return eventLower.startsWith(queryLower);
    }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<dynamic> suggestions) =>
    ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        final queryText = suggestion.substring(0, query.length);
        final remainingText = suggestion.substring(query.length);

        return ListTile(
          onTap: () {
            query = suggestion;
            for(DateTime key in eventMap.keys){
              for(Event e in eventMap[key]){
                if(e.name == suggestion)
                  tappedEvent = e;
              }
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventView())
            );
          },
          leading: const Icon(Icons.event),
          // title: Text(suggestion),
          title: RichText(
            text: TextSpan(
              text: queryText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: remainingText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
}

