import 'package:flutter/material.dart';
import 'package:flutter_application_1/History.dart';
import 'package:flutter_application_1/InputCal.dart';
import 'Profile.dart';
import 'BoxText.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<UserEntity> _profiles = [];
  List<HistoryEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _loadHistory();
  }

  Future<String> _getHistoryFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/history.txt';
  }

  Future<void> _saveHistory() async {
    try {
      final file = File(await _getHistoryFilePath());
      final historyString = _history.map((e) => e.toString()).join('\n');
      await file.writeAsString(historyString);
      print("History saved.");
    } catch (e) {
      print("Error saving history: $e");
    }
  }

  Future<void> _loadHistory() async {
    try {
      final file = File(await _getHistoryFilePath());
      if (await file.exists()) {
        final lines = await file.readAsLines();
        setState(() {
          _history =
              lines.map((line) => HistoryEntry.fromString(line)).toList();
        });
        print("History loaded: $_history");
      } else {
        print("History file does not exist.");
      }
    } catch (e) {
      print("Error loading history: $e");
    }
  }

  void _addHistory(HistoryEntry entry) {
    setState(() {
      _history.add(entry);
      _saveHistory();
    });
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/profiles.txt';
    return path;
  }

  Future<void> _loadProfiles() async {
    try {
      final file = File(await _getFilePath());
      if (await file.exists()) {
        List<String> lines = await file.readAsLines();
        setState(() {
          _profiles = lines.map((line) => UserEntity.fromString(line)).toList();
        });
        print("Profiles loaded: $_profiles");
      } else {
        print("File does not exist.");
      }
    } catch (e) {
      print("Error loading profiles: $e");
    }
  }

  Future<void> _saveProfiles() async {
    try {
      final file = File(await _getFilePath());
      String profilesString = _profiles.map((p) => p.toString()).join('\n');
      await file.writeAsString(profilesString);
      print("Profiles saved.");
    } catch (e) {
      print("Error saving profiles: $e");
    }
  }

  void _addProfile(UserEntity profile) {
    setState(() {
      _profiles.add(profile);
      _saveProfiles();
    });
  }

  void _updateProfile(int index, UserEntity profile) {
    setState(() {
      _profiles[index] = profile;
      _saveProfiles();
    });
  }

  void _deleteProfile(int index) {
    setState(() {
      _profiles.removeAt(index);
      _saveProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome To GlucoGuide'),
        backgroundColor: const Color.fromARGB(255, 79, 133, 177),
      ),
      body: ListView.builder(
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Text(_profiles[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings), // ปุ่มตั้งค่า
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Profile(profile: _profiles[index]),
                        ),
                      );

                      if (result != null && result is UserEntity) {
                        _updateProfile(index, result);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteProfile(index),
                  ),
                ],
              ),
              onTap: () async {
                // When the ListTile is tapped, navigate to Inputcal screen
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Inputcal(
                      userProfile: _profiles[index],
                      addHistory:
                          _addHistory, // Ensure this is correctly passed
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile()),
          );

          if (result != null && result is UserEntity) {
            _addProfile(result);
          }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "History",
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(
                  history: _history,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
