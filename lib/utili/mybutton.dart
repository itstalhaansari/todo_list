import 'package:flutter/material.dart';
import 'package:flutter_application_22/Components/Constraints_colors.dart';

class Mybutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  const Mybutton(
      {super.key, required this.onPressed, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      color: color,
      child: Text(
        text,
        style: TextStyle(color: gettertiaryColor(context)),
      ),
    );
  }
}
