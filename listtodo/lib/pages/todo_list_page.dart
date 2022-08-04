import 'package:flutter/material.dart';
import 'package:listtodo/widgets/todo_list_item.dart';
import 'package:listtodo/models/todo.dart';
import 'package:listtodo/repositories/todo_repository.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoRepository todoRepository = TodoRepository();
  final TextEditingController taskController = TextEditingController();

  List<Todo> tasks = [];
  List<Todo> tasksDeleted = [];
  Todo? deletedTodo;
  int? positionDeleted;

  String? textError;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            labelText: 'Adicione uma tarefa',
                            border: OutlineInputBorder(),
                            errorText: textError,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff00d7f3),
                                width: 2,
                              )
                            ),
                            labelStyle: TextStyle(
                              color: Color(0xff00d7f3),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: addtask,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(14),
                          primary: Color(0xff00d7f3),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Todo task in tasks)
                          TodoListItem(
                            todo: task,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text('${tasks.length} Tarefas Pendentes!'),
                      ),
                      ElevatedButton(
                        onPressed: (deleteAllTasks),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff00d7f3),
                          padding: EdgeInsets.all(14),
                        ),
                        child: Text('Limpar Tudo'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void deleteAllTasks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apagar tudo'),
        content: Text('Deseja apagar todas as suas tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
            style: TextButton.styleFrom(
              primary: Color(0xff00d7f3),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deletingAllTasks();
            },
            child: Text('Apagar Tudo'),
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void deletingAllTasks() {
    setState(() {
      tasks.clear();
    });
    todoRepository.saveTodoList(tasks);
  }

  void addtask() {
    String text = taskController.text;

    if (text.isEmpty) {
      setState(() {
        textError = 'Esse capo não pode ficar vazio!';
      });
      return;
    }

    textError = null;

    setState(() {
      Todo newTodo = Todo(
        title: text,
        date: DateTime.now()
      );
      tasks.add(newTodo);
      taskController.clear();
      todoRepository.saveTodoList(tasks);
    });
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    positionDeleted = tasks.indexOf(todo);
    setState(() {
      tasks.remove(todo);
    });
    todoRepository.saveTodoList(tasks);


    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('Tarefa ${todo.title} foi removida com sucesso!'),
      action: SnackBarAction(
        label: "Desfazer",
        textColor: Color(0xff00d7f3),
        onPressed: () {
          setState(() {
            tasks.insert(positionDeleted!, deletedTodo!);
          });
          todoRepository.saveTodoList(tasks);
        },
      ),
        duration: const Duration(seconds: 7),
      ),
    );
  }
}
