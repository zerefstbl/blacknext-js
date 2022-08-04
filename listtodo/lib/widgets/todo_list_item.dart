import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:listtodo/models/todo.dart';
import 'package:intl/intl.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function onDelete;

  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {
              onDelete(todo);
            },
          )
        ],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(DateFormat('dd/MM/yyyy - HH:mm').format(todo.date), style: TextStyle(
                fontSize: 12,
              )),
              Text(todo.title, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
            ],
          ),
        ),
      ),
    );
  }
}