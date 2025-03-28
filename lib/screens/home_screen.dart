import 'package:flutter/material.dart';
import 'package:to_do_app/database/todo_database.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  Future<List<ToDo>> _todoList = Future.value([]); // Initialize here
  final TodoDatabase _db = TodoDatabase();

  @override
  void initState(){
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final todos = await _db.getTodos();
    if(mounted){
      setState(() {
        _todoList = Future.value(todos);  // Set the fetched todos list
      });
    }
  }

  void _addTodo(String title, String description) async{
    ToDo newTodo = ToDo(
      title: title,
      description: description,
    );
    await _db.insertToDo(
      newTodo
    );

    _loadTodos(); //reload list.
  }

  void _updateTodo(ToDo updatedTodo) async {
    // Call the database method to update the todo task
    int result = await _db.updateTodo(updatedTodo);

    // Handle success or failure
    if (result > 0) {
      scaffoldMessage("Task updated successfully");
    } else {
      scaffoldMessage("Failed to update task");
    }

    // Rebuild the list or navigate back if needed
    setState(() {
      _todoList = _db.getTodos();  // Refresh the list after update
    });
  }

  
  void _deleteTodo(int id) async {
    // Call the delete method from the database helper and store the result
    int result = await _db.deleteTodo(id);

    // Check if the widget is still mounted
    if (!mounted) return; // Prevent calling setState or using BuildContext if widget is not mounted

    // Check if the deletion was successful (result = 1 means success)
    if (result > 0) {
      // If successful, refresh the list of todos
      _loadTodos();
      scaffoldMessage("Task is sucessfully deleted!");
    } else {
      // Optionally, show a message if deletion was not successful
      scaffoldMessage("Failed to delete task!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton( 
            icon: Icon(Icons.add),
            onPressed: (){
              // Navigate to AddTaskScreen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddTaskScreen(
                    onAddTodo: _addTodo,
                    onUpdateTodo: (_) {},  // Dummy function for updating a task (does nothing)
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<ToDo>>(
        future: _todoList,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tasks available"));
          } else {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (ctx, index) {
                final todo = todos[index];
                return Container(
                  color: index % 2 == 0 ? Colors.blue.shade50 : Colors.green.shade50,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Call _deleteTodo to delete the item and pass its ID
                                _confirmDelete(todo.id!);
                              },
                              color: Colors.blue,
                            ), 
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,  // You can also use BoxShape.rectangle if you prefer square
                                  border: Border.all(
                                    color: todo.isCompleted ? Colors.green : Colors.red,  // Named argument 'color'
                                    width: 2,  // Named argument 'width'
                                  ),// Border color and width
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      // Toggle the 'done' state of the task
                                      _toggleDone(todo.id!);
                                    }, 
                                    icon: Icon(todo.isCompleted ? Icons.check : Icons.close),
                                    color: todo.isCompleted ? Colors.green : Colors.red,
                                    iconSize: 16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          // Navigate to detail screen (if needed)
                          _navigateToEditTask(todo);
                        },
                      ),
                      const Divider(),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void scaffoldMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(milliseconds: 1500),
        ),
      );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteTodo(id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Function to navigate to the AddTaskScreen for editing an existing task
  void _navigateToEditTask (ToDo todo){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onAddTodo: _addTodo,
          onUpdateTodo: _updateTodo,
          existingTodo: todo, // Pass the existing task for editing
        )
      )
    );
  }

  void _toggleDone(int id) async {
    // Call the method to toggle the 'done' status of the todo
    int result = await TodoDatabase().toggleDoneTodo(id);

    // Check if the widget is still mounted to avoid errors
    if (!mounted) return;

    // Check if the update was successful
    if (result > 0) {
      _loadTodos(); // Refresh the list if successful
      scaffoldMessage("Task status updated!");
    } else {
      scaffoldMessage("Failed to update task status!");
    }
  }
}