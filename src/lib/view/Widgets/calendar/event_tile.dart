import 'package:flutter/material.dart';

import '../../../model/entities/event.dart';
import '../../../utils/utils.dart';
import '../../Pages/calendar/edit_event_view.dart';
import '../../Pages/calendar/event_view.dart';

class EventTile extends StatefulWidget{
  final Event event;
  final Function onDelete;
  final Function onEdit;
  
  EventTile({this.event, this.onDelete, this.onEdit});
  
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: widget.event.color),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        key: Key('Event Body'),
        title: Text(widget.event.name),
        subtitle: Text(widget.event.description),
        isThreeLine: true,
        leading: Icon(
          widget.event.icon,
          color: widget.event.color,
          size: 45,
        ),
        onTap: () async{
          tappedEvent = widget.event;
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EventView()
              )
          );
          setState(() {});
        },
        trailing: Column(
          children: [
            PopupMenuButton<String>(
              key: const Key('PopUp Menu'),
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    key: const Key('Edit Button'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        Icon(Icons.edit),
                        Text('Edit')
                      ],
                    ),
                    onTap: widget.onEdit
                ),
                PopupMenuItem<String>(
                    child: Row(
                      key: const Key('Delete Button'),
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        Icon(Icons.delete),
                        Text('Delete')
                      ],
                    ),
                    onTap: widget.onDelete
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}