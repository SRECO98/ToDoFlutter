// lib/widgets/task_input.dart
import 'package:flutter/material.dart';

class TaskInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;

  TaskInput({
    required this.controller,
    required this.labelText,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      maxLines: isMultiline ? null : 1,
    );
  }
}
