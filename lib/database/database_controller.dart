import 'dart:async';
import 'dart:io';

import 'package:etiquette/database/etiquette.dart';
import 'package:etiquette/database/product.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class Serializable {
  Map<String, dynamic> asMap();

  void fromMap(Map<String, dynamic> data);
}

abstract class Model extends Serializable {
  int? id;

  @override
  void fromMap(Map<String, dynamic> data) {
    data.containsKey('id') ? id = data['id'] : 0;
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};

    message['id'] = id;
    return message;
  }

  /// [print] permet de débugger son programme
  /// convertie l'appelant en map et l'affiche en [debugPrint]
  void print() => debugPrint(asMap().toString());
}

abstract class Controller<T extends Model> {
  String table;
  Database db;

  Controller(this.table, this.db);

  Future<T> insert(T model) async {
    model.id = await db.insert(table, model.asMap());
    return model;
  }

  Future<int> update(T model) async {
    return await db
        .update(table, model.asMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete(T model) async {
    return await db.delete(table, where: 'id = ?', whereArgs: [model.id]);
  }
}

class BaseDatabaseController {
  static Database? _database;

  static bool mustBeInitialize = false;

  Future<Database> get database async => (_database ?? await _create());

  /// Create the database
  Future<Database> _create() async {
    sqfliteFfiInit();
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    //Create path for database
    String dbPath = join(appDocumentsDir.path, "etiquette", "etiquette.db");

    var databaseFactory = databaseFactoryFfi;
    _database = await databaseFactory.openDatabase(dbPath,
        options:
            OpenDatabaseOptions(onCreate: _onCreatingDatabase, version: 1));
    return (_database!);
  }

  Future<void> droppingDatabase() async {
    var databaseFactory = databaseFactoryFfi;

    await databaseFactory.deleteDatabase((await database).path);
    _database = null;
  }

  @protected
  FutureOr<void> _onCreatingDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Product.tableName} (
    id INTEGER PRIMARY KEY,
    libelle1 TEXT,
    libelle2 TEXT,
    family TEXT,
    subfamily TEXT,
    medial TEXT,
    quantity INTEGER,
    lieu TEXT,
    modality TEXT,
    dotation TEXT,
    toxicity INTEGER,
    barcode TEXT,
    abri INTEGER,
    fridge INTEGER,
    risque INTEGER
    )''');
    await db.execute('''
    CREATE TABLE ${Etiquette.tableName} (
    id INTEGER PRIMARY KEY,
    name TEXT,
    margelaterale REAL,
    margesuperieur REAL,
    hauteuretiquette REAL,
    largeuretiquette REAL,
    stepvertical REAL,
    stephorizontal REAL,
    nbetiquettehoriz INTEGER,
    nbetiquettevert INTEGER,
    pagename TEXT,
    pagelargeur REAL,
    pagehauteur REAL
    )''');
    mustBeInitialize = true;
  }
}
