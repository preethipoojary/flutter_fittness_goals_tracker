import 'package:flutter/material.dart';
import 'goal.dart';

class AddGoalScreen extends StatefulWidget {
  final Function(Goal) onAdd;

  AddGoalScreen({required this.onAdd});

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final targetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title *'),
            textInputAction: TextInputAction.next,
            autofocus: true,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            controller: targetController,
            decoration: InputDecoration(labelText: 'Target Steps *'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String title = titleController.text.trim();
              String description = descriptionController.text.trim();
              int? target = int.tryParse(targetController.text.trim());

              if (title.isEmpty || target == null || target <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a valid title and steps > 0'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final goal = Goal(
                title: title,
                description: description,
                progress: 0,
                target: target,
              );

              widget.onAdd(goal);
              Navigator.pop(context);
            },
            child: Text('Add Goal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ]),
      ),
    );
  }
}
