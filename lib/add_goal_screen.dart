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
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: targetController,
            decoration: InputDecoration(labelText: 'Target Steps'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final goal = Goal(
                title: titleController.text,
                description: descriptionController.text,
                progress: 0,
                target: int.tryParse(targetController.text) ?? 0,
              );
              widget.onAdd(goal);
              Navigator.pop(context);
            },
            child: Text('Add Goal'),
          ),
        ]),
      ),
    );
  }
}
