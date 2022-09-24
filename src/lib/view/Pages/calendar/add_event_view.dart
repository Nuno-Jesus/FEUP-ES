import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uni/utils/utils.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/calendar/event_text_input.dart';
import 'package:uni/model/entities/event.dart';
import 'package:uni/view/Widgets/calendar/rounded_large_button.dart';

import '../../../utils/settings.dart';



class AddEvent extends StatefulWidget {
  const AddEvent({Key key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();

}

class _AddEventState extends GeneralPageViewState {
  String eventName = 'Unnamed Event';
  String eventLocation = 'Rua Doutor Roberto Frias';
  String eventDescription = 'No description was provided.';
  String eventType = eventTypeList[0];
  DateTime eventDate = DateTime.now();
  Color eventColor = defaultEventColor;
  IconData eventIcon = iconList[0];

  final myController = TextEditingController();
  int iconValue = 0;

  void updateWidget(){
    setState(() {

    });
  }

  void _addItemToList(String name) {
    List<String> tempNameList = eventTypeList;
    tempNameList.add(name);

    setState(() {
      eventTypeList = tempNameList;
    });
  }

  void _removeItemFromList(String name) {
    List<String> tempNameList = eventTypeList;

    for(int i=0; i<eventTypeList.length; i++) {
      if (eventTypeList.elementAt(i) == name) {
        tempNameList.removeAt(i);
      }
    }

    setState(() {
      eventTypeList = tempNameList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                      child: const Center(
                        child: Text(
                          'Event details',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventTextInput(
                    key: const Key('Event Title'),
                    hint: 'The event name',
                    label: 'Event name',
                    onChange: (String input) => eventName = input)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventTextInput(
                    key: Key('Location'),
                    hint: 'Be specific!',
                    label: 'Location',
                    onChange: (String input) => eventLocation = input)
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventTextInput(
                    hint: 'Describe the event in a few words',
                    label: 'Description',
                    onChange: (String input) => eventDescription = input)
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: iconList.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            child: Center(
                              child: ChoiceChip(
                                autofocus: index == 0 ? true : false,
                                selected: iconValue == index,
                                selectedColor: Colors.green[400],
                                label: Icon(
                                  iconList[index],
                                  color: Colors.black54,
                                  size: 40,
                                ),
                                onSelected: (wasSelected){
                                  setState(() {
                                    if(wasSelected){
                                      iconValue = index;
                                      eventIcon = iconList[index];
                                    }
                                  });
                                },
                              )
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width,
                                50
                            )
                        ),
                        onPressed: () => _displayDatePicker(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Event date',
                                style: TextStyle(color: Colors.black)),
                            Row(
                              children: <Widget>[
                                Text(dateToDD_MM_YY(eventDate),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
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
                                MediaQuery.of(context).size.width,
                                50
                            ))
                        ),

                        onPressed: () {
                          _displayEventTypePicker(context);
                          setState(() {});
                        },

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Type',
                                style: TextStyle(color: Colors.black)
                            ),
                            Row(
                              children: <Widget>[
                                Text(eventType,
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
                            const Text('Color',
                                style: TextStyle(color: Colors.black)
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: eventColor,
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
                              ],
                            )
                          ],
                        )
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: RoundedLargeButton(
                    key: Key("Save Button"),
                    text: 'Save',
                    backgroundColor: Colors.green,
                    onPressed: (context){
                      Event newEvent = Event(eventName, eventLocation, eventDescription,
                          eventDate, eventType, eventColor, eventIcon);

                      if(!eventMap.containsKey(eventDate) || eventMap[eventDate].length == 0){
                        List<Event> newList = [];
                        newList.add(newEvent);
                        eventMap[eventDate] = newList;
                      }

                      else {
                        eventMap[eventDate].add(newEvent);
                      }
                      Navigator.pop(context);
                    }
                  ),
                )
              ]
          )
      )
    );
  }

  void _displayDatePicker(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            height: 250,
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        eventDate = newDate;
                      });
                    },
                  ),
                ),
                Container(
                  height: 50,
                  child: TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ]
            )
          );
        });
  }

  void _displayEventTypePicker(context){
    showDialog(
      context: context,
      builder: (BuildContext bc){
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Center(
              child: const Text('Event Type'),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 300
              ),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(eventTypeList.length, (index) {
                      return ListTile(
                        title: Text(eventTypeList.elementAt(index)),
                        leading: Radio<String>(
                          activeColor: Colors.blue,
                          value: eventTypeList.elementAt(index),
                          groupValue: eventType,
                          onChanged: (String value){
                            setState(() {
                              eventType = value;
                            });
                            updateWidget();
                          },
                        ),
                      );
                    })
                  )
              ),
            ),
            actions: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    await _showDeleteDialog();
                    setState(() {});
                  },
                ),),
              FittedBox(
                fit: BoxFit.contain,
                child: TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    myController.text = ""; // resetting the textfield
                    await _showNewTypeDialog();
                    setState(() {});
                  },
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: TextButton(
                    child: const Text('OK'),
                    onPressed: (){
                      setState((){});
                      Navigator.pop(context);
                    }
                ),
              ),
            ],
          );
        });
      }
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future _showDeleteDialog() =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deleting ' + eventType + ""),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _removeItemFromList(eventType);
                    Navigator.pop(context);
                  },
                  child: Text('Yes')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              )
            ],
          );
        });

  Future _showNewTypeDialog() =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Type'),
            content: TextFormField(
              controller: myController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
              TextButton(
                onPressed: () => setState(() {
                  _addItemToList(myController.text);
                  Navigator.pop(context);
                }),
                child: Text('Add'),
              )
            ],
          );
        });


  void _displayColorPicker(context){
    showDialog(
        context: context,
        builder: (BuildContext bc){
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
                        pickerColor: eventColor,
                        onColorChanged: (newColor){
                          setState(() {
                            eventColor = newColor;
                          });
                          //print('Event color: ${eventColor.toString()}');
                        },
                        colorPickerWidth: 300.0,
                        pickerAreaHeightPercent: 0.7,
                        enableAlpha: true,
                        displayThumbColor: true,
                        paletteType: PaletteType.hsv,
                        pickerAreaBorderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(2.0),
                          topRight: const Radius.circular(2.0),
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
        }
    );
  }
}