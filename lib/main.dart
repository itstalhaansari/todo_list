import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/Theme/themeprovider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/homepage.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  var box = await Hive.openBox('mybox');
  await FilePicker.platform.clearTemporaryFiles();
  runApp(ChangeNotifierProvider(
    create: (context) => Themeprovider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Homepage(),
      theme: Provider.of<Themeprovider>(context).activethemename,
    );
  }
}
