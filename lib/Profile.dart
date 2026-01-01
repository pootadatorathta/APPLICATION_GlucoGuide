import 'package:flutter/material.dart';
import 'BoxText.dart';

class Profile extends StatefulWidget {
  final UserEntity? profile;
  const Profile({super.key, this.profile});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  final TextEditingController firstandlastName = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController InsuliSensitive = TextEditingController();
  final TextEditingController CarbPerUnit = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      firstandlastName.text = widget.profile!.name;
      age.text = widget.profile!.age.toString();
      InsuliSensitive.text = widget.profile!.insulinSensitivity.toString();
      CarbPerUnit.text = widget.profile!.carbPerUnit.toString();
    }
  }

  @override
  void dispose() {
    firstandlastName.dispose();
    age.dispose();
    InsuliSensitive.dispose();
    CarbPerUnit.dispose();
    super.dispose();
  }

  void _saveProfile() {
    try {
      // ตรวจสอบค่าชื่อ
      if (!RegExp(r'^[a-zA-Zก-๙0-9.\s]+$').hasMatch(firstandlastName.text)) {
        throw FormatException(
            'ท่านใส่ค่าข้อมูลไม่ถูกต้อง โปรดใส่ข้อมูลที่เป็นพยัญชนะภาษาไทย ภาษาอังกฤษ ตัวเลข และเครื่องหมายจุด');
      }
      // ตรวจสอบค่าอายุ
      if (!RegExp(r'^\d*\.?\d+$').hasMatch(age.text)) {
        throw FormatException(
            'ท่านใส่ค่าข้อมูลไม่ถูกต้อง โปรดใส่ค่าข้อมูลเป็นตัวเลข');
      }
      // ตรวจสอบค่าความดื้อต่ออินซูลิน
      if (!RegExp(r'^\d*\.?\d+$').hasMatch(InsuliSensitive.text)) {
        throw FormatException(
            'ท่านใส่ค่าข้อมูลไม่ถูกต้อง โปรดใส่ค่าข้อมูลเป็นตัวเลข');
      }
      // ตรวจสอบค่าคาร์โบไฮเดรต/กรัม
      if (!RegExp(r'^\d*\.?\d+$').hasMatch(CarbPerUnit.text)) {
        throw FormatException(
            'ท่านใส่ค่าข้อมูลไม่ถูกต้อง โปรดใส่ค่าข้อมูลเป็นตัวเลข');
      }
      // ตรวจสอบว่าฟิลด์ทั้งหมดไม่ว่างเปล่า
      if (firstandlastName.text.isEmpty ||
          age.text.isEmpty ||
          InsuliSensitive.text.isEmpty ||
          CarbPerUnit.text.isEmpty) {
        throw FormatException('กรุณากรอกข้อมูลในช่องว่างให้ครบ');
      }

      final user = UserEntity(
        firstandlastName.text,
        double.parse(age.text),
        double.parse(InsuliSensitive.text),
        double.parse(CarbPerUnit.text),
      );
      Navigator.pop(context, user);
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

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: firstandlastName,
              decoration: InputDecoration(labelText: 'โปรดใส่ ชื่อ - นามสกุล'),
            ),
            TextField(
              controller: age,
              decoration: InputDecoration(labelText: 'โปรดใส่ อายุ'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: InsuliSensitive,
              decoration:
                  InputDecoration(labelText: 'โปรดใส่ค่าความดื้อต่ออินซูลิน'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: CarbPerUnit,
              decoration:
                  InputDecoration(labelText: 'โปรดใส่ค่าคาร์โบไฮเดรต/กรัม'),
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
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.green),
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
