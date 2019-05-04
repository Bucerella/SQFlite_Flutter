import 'dart:io' as io;
import 'dart:async';
import 'package:kararsizim/model/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  final String TABLE_NAME = "Contact";
  static Database db_instance;

  Future<Database> get db async {
    if (db_instance == null) db_instance = await initDB();
    return db_instance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "veritabani.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);
    return db;
  }

  void onCreateFunc(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE_NAME(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, color TEXT);');
  }

  //CRUD FUNCTİON

  Future<List<Contact>> getContacts() async {
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_NAME');
    List<Contact> contacts = new List();
    for (int i = 0; i < list.length; i++) {
      Contact contact = new Contact();
      contact.id = list[i]['id'];
      contact.name = list[i]['name'];
      contact.color = list[i]['color'];

      contacts.add(contact);
    }
    return contacts;
  }

  void addNewContact(Contact contact) async {
    var db_connection = await db;
    String query =
        'INSERT INTO $TABLE_NAME(name,color) VALUES(\'${contact.name}\',\'${contact.color}\')';
    await db_connection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
  }

  void updateContact(Contact contact) async {
    var db_connection = await db;
    String query =
        'UPDATE $TABLE_NAME SET name=\'${contact.name}\',color=\'${contact.color}\' WHERE id=${contact.id}';
    await db_connection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }

  void deleteContact(Contact contact) async{
    var db_connection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE id=${contact.id}';
    await db_connection.transaction((transaction)async{
      return await transaction.rawInsert(query);
    });

  }

}
