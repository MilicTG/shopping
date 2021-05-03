import 'package:flutter/material.dart';
import './util/dbhelper.dart';
import './models/list_items.dart';
import './models/shopping_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Shopping List'),
        ),
        body: ShList(),
      ),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList;

  @override
  Widget build(BuildContext context) {
    showData();
    return ListView.builder(
      itemCount: (shoppingList != null) ? shoppingList.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(shoppingList[index].name),
        );
      },
    );
  }

  Future showData() async {
    await helper.openDb();

    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }
}
