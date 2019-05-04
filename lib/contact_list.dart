import 'package:flutter/material.dart';
import 'package:kararsizim/database/DBHelper.dart';
import 'package:kararsizim/model/contact.dart';
import 'package:fluttertoast/fluttertoast.dart';
class MyContactList extends StatefulWidget {



  @override
  _MyContactListState createState() => _MyContactListState();
}

class _MyContactListState extends State<MyContactList> {

  Future<List<Contact>> getContactFromDB() async {
    var dbHelper = DBHelper();
    Future<List<Contact>> contacts = dbHelper.getContacts();
    return contacts;
  }

  final controlle_name = TextEditingController();
  final controlle_color = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff21cdc0),
        title: Text("Contact List"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<List<Contact>>(
            future: getContactFromDB(), builder: (context, snapshot) {
              if(snapshot.data != null){
                if(snapshot.hasData){
                  return ListView.builder(itemCount: snapshot.data.length,itemBuilder: (context,index){
                      return Row(
                        children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      snapshot.data[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[index].color,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          //CREATE UPDATE DELETE BUTTON
                          GestureDetector(
                            onTap: (){

                              showDialog(context: context,builder: (_) => new AlertDialog(contentPadding: EdgeInsets.all(15),
                              content: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextFormField(
                                          autofocus: true,
                                          decoration: InputDecoration(hintText: '${snapshot.data[index].name}'),
                                          controller: controlle_name,
                                        ),
                                        TextFormField(
                                          autofocus: true,
                                          decoration: InputDecoration(hintText: '${snapshot.data[index].color}'),
                                          controller: controlle_color,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                                actions: <Widget>[
                                  FlatButton(onPressed: (){
                                    Navigator.pop(context);

                                  }, child: Text("CANCEL")
                                  ),
                                   FlatButton(onPressed: (){

                                   var dbHelper = DBHelper();
                                   Contact contact = Contact();
                                   contact.id = snapshot.data[index].id;

                                   contact.name = controlle_name.text != '' ?controlle_name.text:snapshot.data[index].name;
                                   contact.color = controlle_color != '' ?controlle_color.text:snapshot.data[index].color;

                                  dbHelper.updateContact(contact);
                                    Navigator.pop(context);
                                    setState(() {
                                      getContactFromDB();
                                    });

                                  }, child: Text("UPDATE")
                                  ),
                                ],
                              ),);

                            },
                            child: Icon(Icons.update,color: Colors.redAccent,),

                          ),
                            GestureDetector(
                              onTap: (){
                                  var dbHelper = DBHelper();
                                  dbHelper.deleteContact(snapshot.data[index]);
                                  Fluttertoast.showToast(msg: "Contact was deleted", toastLength: Toast.LENGTH_SHORT,backgroundColor: Color(0xff21cdc0),textColor: Color(0xffffffff));
                                  setState(() {
                                    getContactFromDB();
                                  });
                                  },
                              child: Icon(Icons.delete,color: Colors.redAccent,),

                            ),
                        ],
                      );
                  });
                }
              }

              return  new Container(
                alignment: AlignmentDirectional.center,
                child: CircularProgressIndicator(),
              );


        }),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
}
