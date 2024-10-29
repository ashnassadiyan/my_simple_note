import "package:flutter/material.dart";
import "package:mobile/Models/note.dart";
class Button extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final String buttonType;

  const Button({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.buttonType
  });



  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(onPressed: onPressed, child: Text(buttonText,style: TextStyle(color: Colors.white),),style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(getColors(buttonType)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1), // Set your desired border radius here
        ),
      ),

    ),);
  }

  Color getColors(String color){
    if(color==Note.noteTypePriorityMedium){
      return Colors.cyan;
    }
    if(color==Note.noteTypePriorityLow){
      return Colors.green;
    }
    else{
      return Colors.deepOrange;
    }
  }
}
