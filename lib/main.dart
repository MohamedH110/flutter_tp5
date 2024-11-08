import 'package:flutter/material.dart';
import 'package:tp5_flutter/util/dbuse.dart';
import 'package:tp5_flutter/model/scol_list.dart';
import 'package:tp5_flutter/ui/students_screen.dart';
import 'package:tp5_flutter/ui/ScolListDialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classes List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];
  final DbUse helper = DbUse();
  late ScolListDialog dialog;

  @override
  void initState() {
    super.initState();
    dialog = ScolListDialog();
    showData();
  }

  Future<void> showData() async {
    await helper.openDb();
    List<ScolList> loadedData = await helper.getClasses();
    setState(() {
      scolList = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes List'),
      ),
      body: ListView.builder(
        itemCount: scolList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(scolList[index].nomClass), // Unique key for each item
            onDismissed: (direction) {
              String strName = scolList[index].nomClass;
              helper.deleteClass(scolList[index]); // Delete class
              setState(() {
                scolList.removeAt(index); // Remove the item from the list
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$strName deleted")),
              );
            },
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentsScreen(scolList[index]),
                  ),
                );
              },
              title: Text(scolList[index].nomClass),
              leading: CircleAvatar(
                child: Text(scolList[index].codClass.toString()),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        dialog.buildDialog(context, scolList[index], false),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ScolList(0, '', 0), true),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
