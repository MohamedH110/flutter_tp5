import 'package:flutter/material.dart';
import '../model/list_etudiants.dart';
import '../util/dbuse.dart';

class ListStudentDialog {
  Widget buildAlert(BuildContext context, ListEtudiants student, bool isAdding) {
    final TextEditingController nameController = TextEditingController(text: student.nom);
    final TextEditingController prenomController = TextEditingController(text: student.prenom);
    final TextEditingController dateNaisController = TextEditingController(text: student.datNais);

    return AlertDialog(
      title: Text(isAdding ? 'Add Student' : 'Edit Student'),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: prenomController,
            decoration: InputDecoration(labelText: 'Prenom'),
          ),
          TextField(
            controller: dateNaisController,
            decoration: InputDecoration(labelText: 'Date of Birth'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Close the dialog without saving
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (isAdding) {
              // Add student logic
              ListEtudiants newStudent = ListEtudiants(
                0, // ID will be auto-generated
                student.codClass,
                nameController.text,
                prenomController.text,
                dateNaisController.text,
              );
              await DbUse().insertEtudiants(newStudent);
            } else {
              // Update student logic
              student.nom = nameController.text;
              student.prenom = prenomController.text;
              student.datNais = dateNaisController.text;
              await DbUse().updateEtudiant(student);
            }
            Navigator.of(context).pop(true); // Close the dialog and return true
          },
          child: Text(isAdding ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
