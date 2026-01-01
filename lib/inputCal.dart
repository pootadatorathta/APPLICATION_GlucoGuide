// Inputcal.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/BoxText.dart';
import 'package:flutter_application_1/History.dart';
import 'package:flutter_application_1/mainCal.dart';
import 'DisplayResult.dart';

class Inputcal extends StatefulWidget {
  final UserEntity userProfile;
  final Function(HistoryEntry) addHistory;

  Inputcal({required this.userProfile, required this.addHistory});

  @override
  _InputcalState createState() => _InputcalState();
}

class _InputcalState extends State<Inputcal> {
  final TextEditingController currentBloodSugar = TextEditingController();
  final TextEditingController targetBloodSugar = TextEditingController();
  final TextEditingController carbValue = TextEditingController();

  @override
  void dispose() {
    currentBloodSugar.dispose();
    targetBloodSugar.dispose();
    carbValue.dispose();
    super.dispose();
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _calculateDose() {
    try {
      if (currentBloodSugar.text.isEmpty) {
        throw FormatException('โปรดใส่ค่าของเลือดปัจจุบัน');
      }
      if (targetBloodSugar.text.isEmpty) {
        throw FormatException('โปรดใส่ค่าเป้าหมายของน้ำตาลในเลือด');
      }
      if (carbValue.text.isEmpty) {
        throw FormatException('โปรดใส่ค่าคาร์บ');
      }

      double insulinSensitivity = widget.userProfile.insulinSensitivity;
      double carbPerUnit = widget.userProfile.carbPerUnit;

      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(currentBloodSugar.text)) {
        throw FormatException('โปรดใส่ค่าของเลือดปัจจุบันเป็นตัวเลข');
      }
      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(targetBloodSugar.text)) {
        throw FormatException('โปรดใส่ค่าเป้าหมายของน้ำตาลในเลือดเป็นตัวเลข');
      }
      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(carbValue.text)) {
        throw FormatException('โปรดใส่ค่าคาร์บเป็นตัวเลข');
      }

      double currentBS = double.parse(currentBloodSugar.text);
      double targetBS = double.parse(targetBloodSugar.text);
      double carbs = double.parse(carbValue.text);

      mainCal calculator = mainCal(currentBS, targetBS, carbs);

      double correctionDose =
          calculator.calculateCorrectionDose(insulinSensitivity);
      double carbDose = calculator.calculateCarbDose(carbPerUnit);
      double totalDose =
          calculator.calculateTotalDose(insulinSensitivity, carbPerUnit);

      Displayresult.showResultDialog(
          context, correctionDose, carbDose, totalDose);

      final historyEntry = HistoryEntry(
        profileName: widget.userProfile.name,
        description:
            'Correction Dose: $correctionDose, Carb Dose: $carbDose, Total Dose: $totalDose',
        timestamp: DateTime.now(),
        result: totalDose
            .toString(), // Assuming you want to store the total dose as the result
      );
      widget.addHistory(historyEntry);

      currentBloodSugar.clear();
      targetBloodSugar.clear();
      carbValue.clear();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate of Dose'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: currentBloodSugar,
              decoration:
                  InputDecoration(labelText: 'โปรดใส่ค่าของเลือดปัจจุบัน'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: targetBloodSugar,
              decoration: InputDecoration(
                  labelText: 'โปรดใส่ค่าเป้าหมายของน้ำตาลในเลือด'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: carbValue,
              decoration: InputDecoration(labelText: 'โปรดใส่ค่าคาร์โบไฮเดรต'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                  ),
                  child: Text(
                    "Cancel",
                  ),
                ),
                ElevatedButton(
                  onPressed: _calculateDose,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                  ),
                  child: Text(
                    "Calculate",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
