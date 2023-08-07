import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

class ToDoItem extends StatelessWidget {
  ToDoItem({
    super.key,
    required this.taskName,
    required this.isDone,
    required this.uniqueKey,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
    required this.myController,
    required this.time,
  });
  final String taskName;
  final bool isDone;
  final int uniqueKey;
  final String time;
  final onChanged;
  final onDelete;
  final onEdit;
  final myController;
  String? setTime;

  // time initializer
  TimeOfDay timeOfDay = TimeOfDay.now();

  // time dialog
  Future<String?> displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: timeOfDay,
    );
    if (time != null) {
      return "${time.hour}:${time.minute}";
    } else {
      return null;
    }
  }

  // Edit dialog
  Future openDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Center(
              child: Text("Edit your task"),
            ),
            actions: [
              TextField(
                controller: myController,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setTime ??= time;
                      onEdit(uniqueKey, myController.text, setTime);

                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async =>
                        setTime = await displayTimePicker(context),
                    child: const Text('Set Time'),
                  ),
                ],
              )
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          openDialog(context);
        },
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Color(0xFF1D1F33),
        leading: Column(
          children: [
            Expanded(
                child: Container(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.access_alarms_sharp,
                    color: tdBlue,
                    size: 15,
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            )),
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: () {
                  onChanged(uniqueKey);
                },
                child: Icon(
                  isDone ? Icons.check_box : Icons.check_box_outline_blank,
                  color: tdBlue,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        title: Column(
          children: [
            Text(
              taskName,
              style: TextStyle(
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: Colors.red,
                decorationThickness: 2.5,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Color(0xFFF0E7F8),
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete(uniqueKey);
            },
          ),
        ),
      ),
    );
  }
}
