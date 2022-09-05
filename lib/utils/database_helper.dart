import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_app_section4b/models/note.dart';
import 'package:simple_app/model/user_profile.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {

  // singleton object: initialized only once throughout the app and use it till the app shut down
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database;

//  String noteTable = 'note_table';
//  String colId = 'id';
//  String colTitle='title';
//  String colDescription='description';
//  String colPriority = 'priority';
//  String colDate = 'date';

  String userProfileTable='userprofile_table';
  String colId = 'id';
  String colUid = 'uid';
  String colDisplayName = 'userDisplayName';
  String colEmail = 'userEmail';
  String colPassword = 'userPassword';
  String colDate = 'date';
  String colSelfieString = 'selfieString';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if(_databaseHelper==null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database= await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    //String path = directory.path + 'notes.db';
    String path = directory.path+'test.db';

    // Open/ create the database at a given path
    var notesDatabase=openDatabase(path, version:1, onCreate: _createDb);
    return notesDatabase;
  }

//  void _createDb (Database db, int newVersion) async {
//    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
//        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
//  }

  void _createDb (Database db, int newVersion) async {
    await db.execute('CREATE TABLE $userProfileTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUid TEXT, '
        '$colDisplayName TEXT, $colEmail TEXT, $colPassword TEXT, $colDate TEXT, $colSelfieString TEXT)');
  }

  // ######
  // INSERT, UPDATE, DELETE AND FETCH
  // ######

  // Fetch Operation: Get all note objects from database
//  Future<List<Map<String, dynamic>>> getNoteMapList() async {
//    Database db = await this.database;
//    // you can write this...
//    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//    // .. OR ..
//    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
//    return result;
//  }

  Future <List<Map<String, dynamic>>> getUserProfileMapList() async {
    Database db = await this.database;
    var result = await db.query(userProfileTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
//  Future<int> insertNote(Note note) async {
//    Database db = await this.database;
//    var result = await db.insert(noteTable, note.toMap());
//    debugPrint('RESULT IS:'+result.toString());
//    return result;
//  }

  Future <int> insertUserProfile (UserProfile userProfile) async {
    Database db = await this.database;
    var result = await db.insert(userProfileTable, userProfile.toMap());
    debugPrint('RESULT IS:' + result.toString());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
//  Future<int> updateNote(Note note) async {
//    var db = await this.database;
//    var result = await db.update(noteTable, note.toMap(), where: '$colId=?', whereArgs:[note.id]);
//    return result;
//  }

  Future<int> updateUserProfile(UserProfile userProfile) async {
    var db = await this.database;
    var result = await db.update(userProfileTable, userProfile.toMap(), where: '$colUid=?', whereArgs:[userProfile.uid]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
//  Future<int> deleteNote (int id) async {
//    var db = await this.database;
//    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
//    return result;
//  }

  Future<int> deleteUserProfile (int uid) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $userProfileTable WHERE $colUid = $uid');
    return result;
  }

  Future<int> deleteAllUserProfile () async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $userProfileTable');
    return result;
  }

  // Get number of Note objects in database
//  Future<int> getCoutn() async {
//    Database db = await this.database;
//    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) from $noteTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) from $userProfileTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//  Future <List<Note>> getNoteList() async {
//    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
//    int count = noteMapList.length;
//
//    List<Note> noteList = List<Note>();
//    // For loop to create a 'Note List' from a 'Map List'
//    for (int i=0; i< count; i++) {
//      noteList.add(Note.fromMapObject(noteMapList[i]));
//    }
//    return noteList;
//  }

  Future <List<UserProfile>> getUserProfileList() async {
    var userProfileMapList = await getUserProfileMapList(); // Get 'Map List' from database
    int count = userProfileMapList.length;

    List<UserProfile> userProfileList = List<UserProfile>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i=0; i< count; i++) {
      userProfileList.add(UserProfile.fromMapObject(userProfileMapList[i]));
    }
    return userProfileList;
  }
}