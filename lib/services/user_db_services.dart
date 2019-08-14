import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator{
  static const userTable = 'user';
  static const id = 'id';
  static const fullName = 'fullName';
  static const password = 'password';
  static const email = 'email';
  static const phoneNo = 'phoneNo';
  static const icPassport = 'icPassport';
  static const isDeleted = 'isDeleted';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertAndUpdateQueryResult, List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createUserTable(Database db) async {
    final userSql = '''CREATE TABLE $userTable
    (
      $id INTEGER PRIMARY KEY,
      $fullName TEXT,
      $password TEXT,
      $email TEXT,
      $phoneNo TEXT,
      $icPassport TEXT,
      $isDeleted BIT NOT NULL
    )''';

    
    await db.execute(userSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('user_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print('dah create database');
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createUserTable(db);
  }
}