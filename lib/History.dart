// History.dart
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HistoryEntry {
  final String profileName;
  final String description;
  final DateTime timestamp;

  HistoryEntry({
    required this.profileName,
    required this.description,
    required this.timestamp,
    required String result,
  });

  @override
  String toString() {
    return '$profileName|$description|${timestamp.toIso8601String()}';
  }

  static HistoryEntry fromString(String string) {
    final parts = string.split('|');
    return HistoryEntry(
      profileName: parts[0],
      description: parts[1],
      timestamp: DateTime.parse(parts[2]),
      result: '',
    );
  }
}

class HistoryScreen extends StatefulWidget {
  final List<HistoryEntry> history;

  HistoryScreen({required this.history});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<HistoryEntry> _history;

  @override
  void initState() {
    super.initState();
    _history = widget.history;
  }

  void _deleteHistory(int index) {
    setState(() {
      _history.removeAt(index);
      _saveHistory();
    });
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

  Future<String> _getHistoryFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/history.txt';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_history[index].profileName),
            subtitle: Text(
                '${_history[index].timestamp.toString()} : ${_history[index].description}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteHistory(index),
            ),
          );
        },
      ),
    );
  }
}
