class Goal {
  String title;
  String description;
  int progress;
  int target;
  bool isCompleted;

  Goal({
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    this.isCompleted = false,
  });
}
