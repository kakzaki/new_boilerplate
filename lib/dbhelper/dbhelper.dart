import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jeteconnect.db");
    Database? theDb;
    try {
      theDb = await openDatabase(path,
          version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
    } catch (e) {
      log("theDb $e");
    }
    return theDb;
  }

  void onDelete() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jeteconnect.db");
    await deleteDatabase(path);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS User");
    _onCreate(db, newVersion);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(no INTEGER PRIMARY KEY, iduser TEXT, namauser TEXT, password TEXT, email TEXT, telepon TEXT, apitoken TEXT)");
    log("Created tables");
  }

  void saveUser(User user) async {
    Database? dbClient = await db;
    await dbClient?.transaction((txn) async {
      return await txn.insert("User", user.toMap());
    });
  }

  void updateUser(User user) async {
    Database? dbClient = await db;
    await dbClient?.transaction((txn) async {
      return await txn
          .update("User", user.toMap(), where: "no = ?", whereArgs: [1]);
    });
  }

  void deleteUser() async {
    Database? dbClient = await db;
    await dbClient?.transaction((txn) async {
      return await txn.rawDelete('DELETE FROM User');
    });
    log("Delete Tabel User");
  }

  Future<List<Map>?> fetchUser() async {
    Database? dbClient = await db;
    List<Map>? results = await dbClient
        ?.query("User", columns: User.columns, where: "no = ?", whereArgs: [1]);
    return results;
  }

  Future<int?> countUser() async {
    Database? dbClient = await db;
    List<Map<String, Object?>> querys =
        await dbClient?.rawQuery('SELECT COUNT(*) FROM User') ?? [];
    log("querys $querys");
    int? results = 0;
    if (querys.isNotEmpty) {
      results = Sqflite.firstIntValue(querys);
      log("results $results");
    }
    return results;
  }
}

var dbHelper = DBHelper();

Future<int?> countUserFromDatabase(BuildContext context) async {
  int? user = 0;
  //await Future.delayed(const Duration(milliseconds: 500));
  if (kIsWeb == true) {
    user = 0;
    log("web");
  } else {
    user = await dbHelper.countUser();
    log("mobile $user");
  }
  return user;
}

Future<User> fetchUserFromDatabase() async {
  List<Map>? users = await dbHelper.fetchUser();
  List<User>? list = users?.map((val) => User.fromMap(val)).toList();
  User? user = list!.isEmpty ? User.nulls() : list.first;
  return user;
}
