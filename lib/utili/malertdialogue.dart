import 'package:flutter/material.dart';
import 'package:flutter_application_22/Components/Constraints_colors.dart';
import 'package:flutter_application_22/utili/mybutton.dart';

class MAlert extends StatelessWidget {
  final con;
  final String tittletext;
  final VoidCallback onsave;
  final VoidCallback oncancel;
  const MAlert({
    super.key,
    required this.con,
    required this.onsave,
    required this.tittletext,
    required this.oncancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: getprimaryColor(context),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Center(
        child: Text(
          tittletext,
          style: TextStyle(
            color: Colors.white,
            shadows: List.filled(
              2,
              const Shadow(blurRadius: 2),
            ),
          ),
        ),
      ),
      content: Container(
        height: 120,
        color: getprimaryColor(context),
        child: Column(
          children: [
            TextFormField(
              controller: con,
              decoration: InputDecoration(
                hintText: "Type here",
                hintStyle: TextStyle(
                    color: gettertiaryColor(context),
                    shadows: List.filled(
                        2, const Shadow(blurRadius: 2, color: Colors.black))),
                // border: OutlineInputBorder(
                //   borderSide: BorderSide(),
                //   borderRadius: BorderRadius.circular(12),
                // ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: gettertiaryColor(context),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: gettertiaryColor(context)),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Mybutton(
                  onPressed: oncancel,
                  text: "Cancel",
                  color: const Color.fromARGB(255, 238, 91, 80),
                ),
                const SizedBox(
                  width: 10,
                ),
                Mybutton(
                  onPressed: onsave,
                  text: "Save",
                  color: Colors.green,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
