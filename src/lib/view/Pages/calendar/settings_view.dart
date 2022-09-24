import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uni/view/Pages/calendar/daily_events_view.dart';
import 'package:uni/view/Pages/general_page_view.dart';

import '../../../utils/settings.dart';
import '../../Widgets/calendar/my_bottom_navigation_bar.dart';
import 'calendar_view.dart';


class SettingsView extends StatefulWidget {

  const SettingsView({Key key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();

}

class _SettingsViewState extends GeneralPageViewState {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Notifications',
                            style: TextStyle(color: Colors.black)
                        ),
                        Switch(
                          value: notificationsSwitch,
                          onChanged: (value) {
                            setState(() {
                              notificationsSwitch = value;
                            });
                          },
                        ),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Show days\' names' ,
                            style: TextStyle(color: Colors.black)
                        ),
                        Switch(
                          value: daysNamesSwitch,
                          onChanged: (value) {
                            setState(() {
                              daysNamesSwitch = value;
                            });
                          },
                        ),
                      ],
                    )
                ),


                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                        style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            fixedSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width,
                                50
                            ))
                        ),
                        onPressed: () => _displayFirstDayPicker(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('First day of week',
                                style: TextStyle(color: Colors.black)
                            ),
                            Row(
                              children: <Widget>[
                                Text(firstDayWeek,
                                    style: const TextStyle(color: Colors.grey)
                                ),
                                const Icon( Icons.arrow_forward_ios_rounded, color: Colors.black,
                                )
                              ],
                            )
                          ],
                        )
                    )
                ),

                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                        style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            fixedSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width, 50
                            ))
                        ),
                        onPressed: () => _displayColorPicker(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Default events color',
                                style: TextStyle(color: Colors.black)
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: defaultEventColor,
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
                              ],
                            )
                          ],
                        )
                    )
                ),
              ],
            )
        ),
        bottomNavigationBar: MyBottomNavigationBar(_onBottomButtonTap, _selectedIndex),
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

      else if(_selectedIndex == 1){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CalendarView())
        );
      }
    });
  }



  void _displayColorPicker(context){
    showDialog(
        context: context,
        builder: (BuildContext bc){
          return StatefulBuilder(builder: (context, setState){
            return AlertDialog(
                title: const Center(
                  child: Text('Event Color'),
                ),
                actions: <Widget>[
                  ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: 400
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ColorPicker(
                          pickerColor: defaultEventColor,
                          onColorChanged: (newColor) {
                            setState(() {
                              defaultEventColor = newColor;
                            });
                            //print('Event color: ${eventColor.toString()}');
                          },
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: true,
                          displayThumbColor: true,
                          paletteType: PaletteType.hsv,
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(2.0),
                            topRight: Radius.circular(2.0),
                          ),
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  )
                ]
            );
          });
        }
    );
  }


  void _displayFirstDayPicker(context){
    showDialog(
        context: context,
        builder: (BuildContext bc){
          return AlertDialog(
            title: Center(
              child: const Text('First day of week'),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 300
              ),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      children: List.generate(listOfDays.length, (index) {
                        return ListTile(
                            title: Text(listOfDays.elementAt(index)),
                            leading: Radio<String>(
                              value: listOfDays.elementAt(index),
                              groupValue: firstDayWeek,
                              onChanged: (value) {
                                setState(() {
                                  firstDayWeek = value;
                                  switch(value){
                                    case('Monday'):
                                      firstDayWeekEnum = StartingDayOfWeek.monday;
                                      break;
                                    case('Tuesday'):
                                      firstDayWeekEnum = StartingDayOfWeek.tuesday;
                                      break;
                                    case('Wednesday'):
                                      firstDayWeekEnum = StartingDayOfWeek.wednesday;
                                      break;
                                    case('Thursday'):
                                      firstDayWeekEnum = StartingDayOfWeek.thursday;
                                      break;
                                    case('Friday'):
                                      firstDayWeekEnum = StartingDayOfWeek.friday;
                                      break;
                                    case('Saturday'):
                                      firstDayWeekEnum = StartingDayOfWeek.saturday;
                                      break;
                                    case('Sunday'):
                                      firstDayWeekEnum = StartingDayOfWeek.sunday;
                                      break;
                                  }
                                });
                              },
                            )
                        );
                      })
                  )
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }
}