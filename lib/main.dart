import 'package:flutter/material.dart';
import 'package:kararsizim/contact_list.dart';
import 'package:kararsizim/database/DBHelper.dart';
import 'package:kararsizim/model/contact.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact contact = new Contact();

  String name, color;

  final scaffolKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffolKey,
      appBar: AppBar(
        backgroundColor: Color(0xff21cdc0),
        title: Text("CREATE CONTACT"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.view_list),
            tooltip: 'View List',
            onPressed: () {
              startContactList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(
                    Icons.add,
                    color: Color(0xff21cdc0),
                  ),
                ),
                validator: (val) => val.length == 0 ? "Enter your name" : null,
                onSaved: (val) => this.name = val,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  labelText: "Color",
                  prefixIcon: Icon(
                    Icons.add,
                    color: Color(0xff21cdc0),
                  ),
                ),
                validator: (val) => val.length == 0 ? "Enter your color" : null,
                onSaved: (val) => this.color = val,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: submitContact,
                  color: Color(0xff21cdc0),
                  child: Text("ADD NEW CONTACT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startContactList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyContactList()));
  }

  void submitContact() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return null;
    }
    var contact = Contact();
    contact.name = name;
    contact.color = color;

    var dbHelper = DBHelper();
    dbHelper.addNewContact(contact);
    Fluttertoast.showToast(
        msg: "Contact was saved",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xff21CDC0),
        textColor: Color(0xffffffff));
  }
}
