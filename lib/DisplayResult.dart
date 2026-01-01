import 'package:flutter/material.dart';

class Displayresult {
  static void showResultDialog(BuildContext context, double correctionDose,
      double carbDose, double totalDose) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Result of Dose'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Correction Dose: $correctionDose'),
              Text('Carb Dose: $carbDose'),
              Text('Total Dose: $totalDose'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
