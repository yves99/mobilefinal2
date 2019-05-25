import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/todoDb.dart';
import './friend.dart';


class todoScreen extends StatefulWidget {
  int id;
  String name;
  Account account;
  todoScreen({Key key, this.id, this.name, this.account}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return todoScreenState();
  }
}

class todoScreenState extends State<todoScreen> {
  TodoProvider todoProvider = TodoProvider();

  Widget listTodos(BuildContext context, AsyncSnapshot snapshot) {
    int id = widget.id;
    List<Todo> todos = snapshot.data;
    return Expanded(
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Text(
                    todos[index].id.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    todos[index].title,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    todos[index].completed ? "Completed" : "",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    String name = widget.name;
    Account myself = widget.account;
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("Back"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => friendScreen(
                                account: myself,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: todoProvider.loadTodo(id.toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return listTodos(context, snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
