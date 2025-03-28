class ToDo{
  
  final int? id; // id can be null when creating a new todo
  final String title;
  final String description;
  final bool isCompleted;  

  ToDo({
    this.id, 
    required this.title, 
    required this.description,
    this.isCompleted = false, // Default value is false
  });

  // Convert a ToDo object into a map (used for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // if null, it will be automatically handled by SQLite
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // Convert boolean to int (SQLite doesn't support bool)
    };
  }

  // Convert a map into a ToDo object
  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1, // Convert int back to boolean
    );
  }

  // Add this method
  ToDo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return ToDo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}