import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/widgets/task_input.dart';  

class AddTaskScreen extends StatefulWidget{
  
  final Function(ToDo) onUpdateTodo;
  final ToDo? existingTodo;
  final Function(String, String) onAddTodo; // Callback to handle adding a new todo

  const AddTaskScreen({
    super.key,
    required this.onAddTodo,
    required this.onUpdateTodo,
    this.existingTodo,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>{
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingTodo != null) {
      titleController.text = widget.existingTodo!.title;
      descriptionController.text = widget.existingTodo!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTodo == null ? 'Add To-Do Task' : 'Edit To-Do Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TaskInput(
              controller: titleController, 
              labelText: "Title",
            ),
            SizedBox(
              height: 10
            ),
            TaskInput(
              controller: descriptionController, 
              labelText: "Description",
              isMultiline: true,
            ),
            SizedBox(
              height: 10
            ),
            // Add Task Button
            ElevatedButton(
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;

                if (title.isNotEmpty) {
                  if (widget.existingTodo == null) {
                    widget.onAddTodo(
                      title, 
                      description
                    ); // Add new todo
                  } else {
                    widget.onUpdateTodo(
                      widget.existingTodo!.copyWith(
                        title: title, 
                        description: description
                      ),
                    ); // Update existing todo
                  }

                  // Pop the screen and return to HomeScreen
                  Navigator.of(context).pop();
                }
              },
              child: Text(widget.existingTodo == null ? 'Add Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}