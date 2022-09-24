import 'package:flutter/material.dart';

class EventTextInput extends StatelessWidget{
  final String hint;
  final Function onChange;
  final String label;
  final Key key;

  EventTextInput({
    this.hint,
    this.onChange,
    this.label = '',
    this.key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      onChanged: (String text) => onChange(text),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
        labelText: label,
        hintStyle: TextStyle(color: Colors.black38),
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return 'This field cannot be empty';
        }
        return null;
      }
    );
  }

}