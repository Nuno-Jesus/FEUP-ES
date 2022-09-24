import 'package:flutter/material.dart';

class RoundedLargeButton extends StatelessWidget{
  final Function onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final bool isTextButton;

  const RoundedLargeButton({
    this.onPressed,
    this.text = '',
    this.isTextButton = false,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.red,
    this.borderRadius = 20,
    Key key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if(!isTextButton) {
      return ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          )
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.9, 50)
          ),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              )
          )
        ),
        onPressed: (){
          Future.delayed(
            const Duration(seconds: 0),
              () => onPressed(context)
          );
        }
      );
    }

    return TextButton(
        child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            )
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width * 0.9, 50)
            ),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                )
            )
        ),
        onPressed: (){
          Future.delayed(
              const Duration(seconds: 0),
                  () => onPressed(context)
          );
        }
    );
  }
}