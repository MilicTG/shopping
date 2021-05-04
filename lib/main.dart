import 'package:flutter/material.dart';
import './util/dbhelper.dart';
import './models/shopping_list.dart';
import './ui/item_screen.dart';
import './ui/shopping_list_dialog.dart';

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
  ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return ListView.builder(
      itemCount: (shoppingList != null) ? shoppingList.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsScreen(shoppingList[index])));
          },
          title: Text(shoppingList[index].name),
          leading: CircleAvatar(
            child: Text(shoppingList[index].priority.toString()),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      dialog.buildDialog(context, shoppingList[index], false));
            },
          ),
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
