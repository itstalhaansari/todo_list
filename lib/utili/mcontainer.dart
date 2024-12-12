import 'package:flutter/material.dart';
import 'package:flutter_application_22/Components/Constraints_colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:read_more_text/read_more_text.dart';

class Mcontainer extends StatelessWidget {
  final bool done;
  final Function(bool?)? onChanged;
  final String taskname;
  final Function(BuildContext)? onPressed;
  final Function(BuildContext)? onedittask;
  const Mcontainer(
      {super.key,
      required this.done,
      required this.onChanged,
      required this.taskname,
      required this.onPressed,
      required this.onedittask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Slidable(
        startActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: onedittask,
            icon: Icons.edit,
            backgroundColor: Colors.green,
            borderRadius: BorderRadius.circular(10),
          )
        ]),
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: onPressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
          )
        ]),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: getprimaryColor(context), width: 1.5),
            borderRadius: BorderRadius.circular(12),
            color: getSurfaceColor(context),
          ),
          height: 105,
          //width: 200,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Checkbox(
                value: done,
                onChanged: onChanged,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: ReadMoreText(
                  taskname,
                  numLines: 2,
                  readMoreText: "Read more",
                  readLessText: "Read less",
                  style: TextStyle(
                      fontSize: 17,
                      decoration: done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                  readMoreTextStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: getprimaryColor(context)),
                  readMoreIconColor: getprimaryColor(context),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
