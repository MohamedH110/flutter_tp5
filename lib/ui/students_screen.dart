import 'package:flutter/material.dart';
import '../model/list_etudiants.dart';
import '../model/scol_list.dart';
import '../util/dbuse.dart';
import '../ui/ list_student_dialog.dart'; // Assuming this is your dialog screen for adding/editing students

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  StudentsScreen(this.scolList);

  @override
  _StudentsScreenState createState() => _StudentsScreenState(this.scolList);
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScolList scolList;
  late DbUse helper;
  late List<ListEtudiants> students;

  _StudentsScreenState(this.scolList);

  @override
  void initState() {
    super.initState();
    helper = DbUse();
    students = [];
    showData(this.scolList.codClass);
  }

  @override
  Widget build(BuildContext context) {
    ListStudentDialog dialog = ListStudentDialog();

    return Scaffold(
      appBar: AppBar(
        title: Text(scolList.nomClass),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(students[index].nom),
            onDismissed: (direction) async {
              String strName = students[index].nom;
              await helper.deleteStudent(students[index]);
              setState(() {
                students.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$strName deleted")),
              );
            },
            child: ListTile(
              title: Text(students[index].nom),
              subtitle: Text('Prenom: ${students[index].prenom} - Date Nais: ${students[index].datNais}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit Button
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Open the dialog to edit the student
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return dialog.buildAlert(
                            context,
                            students[index],
                            false, // False means editing
                          );
                        },
                      ).then((value) {
                        // After the dialog closes, refresh the student list
                        if (value != null && value) {
                          showData(scolList.codClass);
                        }
                      });
                    },
                  ),
                  // Delete Button
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Show confirmation dialog before deleting
                      bool? confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Student'),
                            content: Text('Are you sure you want to delete this student?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Perform delete student operation
                                  String strName = students[index].nom;
                                  await helper.deleteStudent(students[index]);
                                  setState(() {
                                    students.removeAt(index); // Remove student from list
                                  });
                                  Navigator.of(context).pop(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("$strName deleted")),
                                  );
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new student functionality
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog.buildAlert(
                context,
                ListEtudiants(0, scolList.codClass, '', '', ''), // New student with default values
                true, // true means adding a new student
              );
            },
          ).then((value) {
            // After the dialog closes, refresh the student list
            if (value != null && value) {
              showData(scolList.codClass);
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future<void> showData(int idList) async {
    await helper.openDb();
    students = await helper.getEtudiants(idList);
    setState(() {
      students = students;
    });
  }
}
