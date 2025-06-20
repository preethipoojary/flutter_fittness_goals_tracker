import 'package:flutter/material.dart';
import 'goal.dart';
import 'add_goal_screen.dart';

void main() {
  runApp(FitnessGoalsApp());
}

class FitnessGoalsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Goals Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: GoalsHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GoalsHomePage extends StatefulWidget {
  @override
  _GoalsHomePageState createState() => _GoalsHomePageState();
}

class _GoalsHomePageState extends State<GoalsHomePage> {
  List<Goal> goals = [];

  void addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
    });
  }

  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void markComplete(int index) {
    setState(() {
      goals[index].isCompleted = true;
    });
  }

  void updateProgress(int index) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Progress'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter steps done today',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              int steps = int.tryParse(controller.text) ?? 0;
              setState(() {
                goals[index].progress += steps;
                if (goals[index].progress >= goals[index].target) {
                  goals[index].isCompleted = true;
                }
              });
              Navigator.pop(context);
            },
            child: Text('Update'),
          )
        ],
      ),
    );
  }

  void editGoal(int index) {
    final goal = goals[index];
    final titleController = TextEditingController(text: goal.title);
    final descController = TextEditingController(text: goal.description);
    final targetController =
        TextEditingController(text: goal.target.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: descController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: targetController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Target Steps')),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: () {
              setState(() {
                goals[index] = Goal(
                  title: titleController.text,
                  description: descController.text,
                  progress: goal.progress,
                  target: int.tryParse(targetController.text) ?? goal.target,
                  isCompleted: goal.isCompleted,
                );
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildGoalCard(Goal goal, int index) {
    double percent = goal.target == 0 ? 0 : (goal.progress / goal.target).clamp(0, 1);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(goal.isCompleted ? Icons.check_circle : Icons.directions_walk,
                    color: goal.isCompleted ? Colors.green : Colors.blue, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(goal.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ],
            ),
            SizedBox(height: 8),
            Text(goal.description, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[300],
              color: goal.isCompleted ? Colors.green : Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(height: 6),
            Text('${goal.progress}/${goal.target} steps',
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => editGoal(index)),
                IconButton(
                    icon: Icon(Icons.update, color: Colors.indigo),
                    onPressed: () => updateProgress(index)),
                IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => markComplete(index)),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteGoal(index)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Goals Tracker'),
        centerTitle: true,
      ),
      body: goals.isEmpty
          ? Center(
              child: Text(
                'No goals yet. Tap + to add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return buildGoalCard(goals[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AddGoalScreen(onAdd: addGoal)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
