import 'package:flutter/material.dart';
import 'services/database_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final DatabaseServices _databaseServices = DatabaseServices.instance; 
  String? _task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Todo'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), 
          child: Container(
            color: Colors.grey,
            height: 1,
          )),
      ),
      body: FutureBuilder(future: _databaseServices.getTasks(), builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index].content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: snapshot.data![index].status == 1 ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      _databaseServices.updateTask(snapshot.data![index].id, snapshot.data![index].status == 1 ? 0 : 1);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _databaseServices.deleteTask(snapshot.data![index].id);
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        );
      },),
      floatingActionButton: _actionButton(),
    );
  }

  Widget _actionButton() {
  return FloatingActionButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Todo'),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter your todo'),
              onChanged: (value) {
                setState(() {
                  _task = value;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  if (_task == null || _task!.isEmpty) return;
                  _databaseServices.insertTask(_task!);
                  setState(() => _task = null);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
    child: Icon(Icons.add),
  );
}
}

