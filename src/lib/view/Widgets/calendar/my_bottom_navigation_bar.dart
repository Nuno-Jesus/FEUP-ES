import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget{
  final Function onTap;
  final int selectedIndex;

  const MyBottomNavigationBar(this.onTap, this.selectedIndex);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>{
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today, key: Key("Daily")),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, key: Key("View Calendar")),
            label: 'View Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, key: Key("Settings")),
            label: 'Settings',
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 0x75, 0x17, 0x1e),
        currentIndex: widget.selectedIndex,
        onTap: (index) => widget.onTap(index)
      // onTap: _onItemTapped,
    );
  }
}