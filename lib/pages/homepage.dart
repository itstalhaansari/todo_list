import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_22/Components/Constraints_colors.dart';
import 'package:flutter_application_22/Theme/themeprovider.dart';
import 'package:flutter_application_22/hivedb.dart';
import 'package:flutter_application_22/utili/malertdialogue.dart';
import 'package:flutter_application_22/utili/mcontainer.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TodoDatabase db = TodoDatabase();
  final mcontroller = TextEditingController();
  String? _profilePhotoPath;

  @override
  void initState() {
    super.initState();
    db.loaddata();
    _loadProfilePhoto();
    if (db.tasks.isEmpty && db.username.isEmpty && _profilePhotoPath == null) {
      db.createdb();
    }
  }

  //get profile photo working
  Future<void> _loadProfilePhoto() async {
    final photoPath = await db.getProfilePhotoPath();
    if (photoPath != null) {
      setState(() {
        _profilePhotoPath = photoPath;
      });
    }
  }

  void checkboxchanged(int index, bool value) {
    setState(() {
      if (index >= 0 && index < db.tasks.length) {
        db.tasks[index][1] = !db.tasks[index][1];
        db.update();
      }
    });
  }

  void onedittasks(int index) {
    if (index >= 0 && index < db.tasks.length) {
      mcontroller.text = db.tasks[index][0];
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return MAlert(
            oncancel: () {
              Navigator.pop(context);
              mcontroller.clear();
            },
            tittletext: "Update task name",
            con: mcontroller,
            onsave: () {
              setState(() {
                if (mcontroller.text.isNotEmpty) {
                  db.editTask(index, mcontroller.text);
                  mcontroller.clear();
                  Navigator.pop(context);
                }
              });
            },
          );
        },
      );
    }
  }

  void createnewtask() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MAlert(
          oncancel: () {
            Navigator.pop(context);
            mcontroller.clear();
          },
          tittletext: "Enter task name",
          con: mcontroller,
          onsave: () {
            setState(() {
              if (mcontroller.text.isNotEmpty) {
                db.tasks.add([mcontroller.text, false]);
                db.update();
                mcontroller.clear();
              }
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void deletetask(int index) {
    setState(() {
      if (index >= 0 && index < db.tasks.length) {
        db.tasks.removeAt(index);
        db.update();
      }
    });
  }

  ////build code starts
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: getprimaryColor(context), //drawer background color
        child: Column(children: [
          DrawerHeader(
            decoration: BoxDecoration(
              // Background color of the header
              border: Border(
                bottom: BorderSide(
                    color: gettertiaryColor(context),
                    width: 2.0), // Custom divider color
              ),
            ),
            child: Column(children: [
              GestureDetector(
                  onTap: () async {
                    String message = await db.pickProfilePhoto();
                    await _loadProfilePhoto(); // Reload the profile photo
                    setState(() {});
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: CircleAvatar(
                    backgroundImage: _profilePhotoPath != null &&
                            File(_profilePhotoPath!).existsSync()
                        ? FileImage(File(_profilePhotoPath!))
                        : null,
                    backgroundColor: gettertiaryColor(context),
                    radius: 40,
                    child: _profilePhotoPath == null
                        ? Icon(Icons.supervised_user_circle_outlined,
                            color: getprimaryColor(context))
                        : null,
                  )),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onLongPress: () => showDialog(
                  context: context,
                  builder: (context) => MAlert(
                    con: mcontroller,
                    onsave: () {
                      setState(() {
                        String name = mcontroller.text;
                        db.updateUsername(name);
                        mcontroller.clear();
                        Navigator.pop(context);
                      });
                    },
                    tittletext: "Change User Name",
                    oncancel: () => Navigator.pop(context),
                  ),
                ),
                child: Text(
                  db.username,
                  style: TextStyle(
                    color: gettertiaryColor(context),
                    fontSize: 20,
                  ),
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ListTile(
              leading: Transform.scale(
                scale: 0.9,
                child: Switch.adaptive(
                  activeColor: const Color.fromARGB(0, 251, 252, 252),
                  value: Provider.of<Themeprovider>(context).isdarkmode,
                  onChanged: (value) =>
                      Provider.of<Themeprovider>(context, listen: false)
                          .toggletheme(),
                ),
              ),
              title: Text(
                "Light/Dark Mode",
                style: TextStyle(
                    color: gettertiaryColor(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              focusColor: getprimaryColor(context),
              onTap: () async {
                try {
                  final result = await db.exportTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'An unexpected error occurred. Please try again.')),
                  );
                }
              },
              leading: Icon(
                size: 26,
                Icons.save,
                color: gettertiaryColor(context),
              ),
              title: Text(
                "Export",
                style: TextStyle(
                    color: gettertiaryColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              onTap: () async {
                final result = await db.importTasks();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
                setState(() {});
              },
              leading: Icon(
                size: 26,
                Icons.download,
                color: gettertiaryColor(context),
              ),
              title: Text(
                "Import",
                style: TextStyle(
                    color: gettertiaryColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
            child: ListTile(
              title: Text(
                "Exit",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: gettertiaryColor(context)),
              ),
              leading: Icon(
                Icons.exit_to_app,
                size: 26,
                color: gettertiaryColor(context),
              ),
              onTap: () => SystemNavigator.pop(),
            ),
          ),
          Text(
            "Developed by Talha Ansari",
            style: TextStyle(
              color: gettertiaryColor(context),
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ]),
      ), //drawer end bracket
      backgroundColor: getSurfaceColor(context), //scaffold background
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: getsecondaryColor(context)),
        //  elevation: 200,
        backgroundColor: getprimaryColor(context),
        centerTitle: true,
        title: Text(
          "TO DO APP BY T.A",
          style: TextStyle(color: gettertiaryColor(context), fontSize: 18),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          tooltip: "Add task",
          onPressed: createnewtask,
          child: Icon(
            Icons.add,
            color: gettertiaryColor(context),
          ),
        ),
      ),
      body: db.tasks.isEmpty
          ? const Center(child: Text('No tasks available'))
          : ListView.builder(
              itemCount: db.tasks.length,
              itemBuilder: (context, index) => Mcontainer(
                onedittask: (context) {
                  onedittasks(index);
                },
                onPressed: (context) => deletetask(index),
                done: db.tasks[index][1],
                onChanged: (context) {
                  checkboxchanged(index, false);
                },
                taskname: db.tasks[index][0],
              ),
            ),
    );
  }
}
