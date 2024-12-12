import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;

class TodoDatabase {
  final _mybox = Hive.box('mybox');
  List tasks = [];
  String username = '';
  String profilePhotoPath = '';

  // Create initial database with an empty list
  void createdb() {
    tasks = [];
    username = 'Long Press to Edit';
    profilePhotoPath = '';
    _mybox.put('Tasks', tasks);
    _mybox.put('username', username);
    _mybox.put('ProfilePhotoPath', profilePhotoPath);
  }

  // Load data from the Hive box
  void loaddata() {
    tasks = _mybox.get('Tasks', defaultValue: []);
    username = _mybox.get('Username', defaultValue: 'Long Press to Edit');
    profilePhotoPath = _mybox.get('ProfilePhotoPath', defaultValue: '');
  }

  // Update the Hive box with the current list of tasks
  void update() {
    _mybox.put('Tasks', tasks);
    _mybox.put('Username', username);
    _mybox.put('ProfilePhotoPath', profilePhotoPath);
  }

  // Edit a task in the list
  void editTask(int taskIndex, String newTask) {
    if (taskIndex >= 0 && taskIndex < tasks.length) {
      tasks[taskIndex][0] = newTask;
      update(); // Save changes to Hive box
    }
  }

  Future<String> exportTasks() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'tasks_export_$timestamp.json';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      final jsonTasks = jsonEncode(tasks);
      await file.writeAsString(jsonTasks);

      // Share the file
      await Share.shareXFiles([XFile(filePath)],
          text: 'Here are my exported tasks');

      return 'Tasks exported successfully. Check your shared files.';
    } catch (e) {
      return 'Error exporting tasks: $e';
    }
  }

  // Import tasks from a JSON file
  Future<String> importTasks() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select your tasks file',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final importedTasks = jsonDecode(jsonString);

        if (importedTasks is List) {
          tasks = importedTasks;
          update(); // Save imported tasks to Hive box
          return 'Tasks imported successfully';
        } else {
          return 'Invalid file format';
        }
      } else {
        return 'Import cancelled';
      }
    } catch (e) {
      return 'Error importing tasks: $e';
    }
  }

  // Function to update the username
  void updateUsername(String newUsername) {
    username = newUsername;
    update(); // Save changes to Hive box
  }

  Future<String> pickProfilePhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select your profile photo',
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.single;
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_photo${path.extension(pickedFile.name)}';
        final savedFilePath = path.join(appDir.path, fileName);

        // Copy the file to the app's documents directory
        final bytes = await File(pickedFile.path!).readAsBytes();
        await File(savedFilePath).writeAsBytes(bytes);

        profilePhotoPath = fileName; // Store only the file name
        update(); // Save updated path to Hive box
        return 'Profile photo updated successfully.';
      } else {
        return 'No file selected.';
      }
    } catch (e) {
      return 'Error picking profile photo: $e';
    }
  }

  // New method to get the full path of the profile photo
  Future<String?> getProfilePhotoPath() async {
    if (profilePhotoPath.isNotEmpty) {
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(appDir.path, profilePhotoPath);
    }
    return null;
  }
}
