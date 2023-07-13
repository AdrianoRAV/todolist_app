import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/src/data/database.dart';

import 'dialog_box.dart';
import 'to_do_list.dart';

class screen extends StatefulWidget {
  const screen({super.key});

  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {
  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      db.creatrInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color.fromRGBO(255, 254, 255, 1),
      backgroundColor: Color.fromRGBO(40, 30, 65, 1),

      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(0, 197, 205, 1),
        backgroundColor: Color.fromRGBO(5, 255, 155, 1),

        title: Center(
            child: Text(
          'Lista de Tarefas',
          style: TextStyle(color: Colors.black),
        )),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(5, 255, 155, 1),
        foregroundColor: Colors.black, //<-- SEE HERE
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoList(
            taskCompleted: db.toDoList[index][1],
            taskName: db.toDoList[index][0],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
      /*   body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintText: 'exemple@exemple.com',
              //border: InputBorder.none;
              errorText: null,
            ),
            //obscureText: false,
          ),
        ),
      ),*/
    );
  }
}
