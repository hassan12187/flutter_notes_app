import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final getInstance = DBHelper._();
  static final TABLE_NOTE = {
    'table_name': 'Note',
    'id': 'Id',
    'name': 'Name',
    'description': 'Description'
  };

  Database? myDb;

  Future<Database> getDb() async {
    return myDb ??= await openDb();
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, "myDb.db");
    return await openDatabase(path, onCreate: (db, version) {
      db.execute(
          'create table ${TABLE_NOTE['table_name']} (${TABLE_NOTE['id']} INTEGER PRIMARY KEY AUTOINCREMENT,${TABLE_NOTE['name']} TEXT,${TABLE_NOTE['description']} Text)');
    }, version: 1);
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    var db = await getDb();
    List<Map<String, dynamic>> result =
        await db.query('${TABLE_NOTE['table_name']}');
    return result;
  }

  Future<bool> addNote(String name, String description) async {
    var db = await getDb();
    int result = await db.insert('${TABLE_NOTE['table_name']}', {
      TABLE_NOTE['name'] as String: name,
      TABLE_NOTE['description'] as String: description
    });
    return result > 0;
  }

  Future<bool> editNote(id, String title, String description) async {
    var db = await getDb();
    int result = await db.update(TABLE_NOTE['table_name'] as String, {
      '${DBHelper.TABLE_NOTE['name']}':title,
      '${DBHelper.TABLE_NOTE['description']}':description
    },
        where: "${TABLE_NOTE['id']} = $id");
    return result > 0;
  }

  Future<bool> deleteNote(id) async {
    var db = await getDb();
    int result = await db.delete('${TABLE_NOTE['table_name']}',
        where: "${TABLE_NOTE['id']}=$id");
    return result > 0;
  }
}
