import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String userTable = "userTable";
final String idCol = "_id";
final String useridCol = "userid";
final String nameCol = "name";
final String ageCol = "age";
final String passwordCol = "password";
final String quoteCol = "quote";

class Account {
  int id;
  String userid;
  String password;
  String name;
  String age;
  String quote;

  Account({this.userid, this.password, this.name, this.age});
  Account.formMap(Map<String, dynamic> map) {
    this.id = map[idCol];
    this.userid = map[useridCol];
    this.name = map[nameCol];
    this.age = map[ageCol];
    this.password = map[passwordCol];
    this.quote = map[quoteCol];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      useridCol: userid,
      nameCol: name,
      ageCol: age,
      passwordCol: password,
      quoteCol: quote,
    };
    if (id != null) {
      map[idCol] = id;
    }

    return map;
  }
}

class UserProvider {
  Database db;
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $idCol integer primary key autoincrement,
        $useridCol text not null unique,
        $nameCol text not null,
        $ageCol text not null,
        $passwordCol text not null,
        $quoteCol text
      )
      ''');
    });
  }

  Future<List<Account>> getUsers() async {
    var res = await db.query(userTable,
        columns: [idCol, useridCol, nameCol, ageCol, passwordCol, quoteCol]);
    return res.isNotEmpty ? res.map((c) => Account.formMap(c)).toList() : [];
  }

  Future<List<Account>> getUser(int id) async {
    var res = await db.query(userTable,
        columns: [idCol, useridCol, nameCol, ageCol, passwordCol, quoteCol],
        where: '$idCol = ?',
        whereArgs: [id]);
    return res.isNotEmpty ? res.map((c) => Account.formMap(c)).toList() : [];
  }

  Future<Account> insert(Account account) async {
    await db.insert(userTable, account.toMap());
  }

  Future<int> updateUser(Account account) async {
    return await db.update(userTable, account.toMap(),
        where: '$idCol = ?', whereArgs: [account.id]);
  }

  Future<int> deleteUsers() async {
    return await db.delete(userTable);
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(userTable, where: '$idCol = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}
