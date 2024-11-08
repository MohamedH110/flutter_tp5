import 'package:flutter/material.dart';
import 'package:tp5_flutter/util/dbuse.dart';
import '../model/scol_list.dart';

class ScolListDialog {
  final txtNomClass = TextEditingController();
  final txtNbreEtud = TextEditingController();

  Widget buildDialog(BuildContext context, ScolList list, bool isNew) {
    DbUse helper = DbUse();

    // If editing an existing class, populate the fields
    if (!isNew) {
      txtNomClass.text = list.nomClass;
      txtNbreEtud.text = list.nbreEtud.toString();
    }

    return AlertDialog(
      title: Text(isNew ? 'New Class List' : 'Edit Class List'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtNomClass,
              decoration: InputDecoration(hintText: 'Class List Name'),
            ),
            TextField(
              controller: txtNbreEtud,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Number of Students'),
            ),
            const SizedBox(height: 20), // Add some spacing before the button
            ElevatedButton(
              child: const Text('Save Class List'),
              onPressed: () {
                list.nomClass = txtNomClass.text;
                list.nbreEtud = int.parse(txtNbreEtud.text);
                helper.insertClass(list);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
