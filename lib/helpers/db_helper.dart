import 'dart:developer';

import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {

  static Database? _database;
  Future<Database?>get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await DatabaseConnection().setDatabase();
      return _database;
    }
  }

  Future<void> copyDatabaseToDevice() async {
    String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
    // Get the path to the documents directory.

    // Create the path for the pre-populated database in the documents directory.
    String databasePath = '$documentsDirectory/lyrics_nchords.db';

    // Check if the database already exists in the documents directory.
    if (FileSystemEntity.typeSync(databasePath) == FileSystemEntityType.notFound) {
      // Copy the database from the assets folder to the documents directory.
      ByteData data = await rootBundle.load('assets/db/lyrics_n_chords.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(databasePath).writeAsBytes(bytes);
    }
  }

  Future<List<SongsModel>> readDb() async {
    String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
    Database database = await openDatabase(
      '$documentsDirectory/lyrics_nchords.db',
      version: 1,
      // ... other parameters as needed
    );


    List<Map<String, dynamic>> result = await database.query('song');
    return List.generate(result.length, (index) => SongsModel(
      id: result[index]['id'], 
      artist: result[index]['singer'] ?? "", 
      title: result[index]['title'] ?? "", 
      album: result[index]['album'] ?? "", 
      timeStamp: DateTime.parse(result[index]['timestamp']), 
      category: result[index]['category'] ?? "", 
      content: result[index]['content'] ?? "", 
      docId: result[index]['docId'] ?? "", 
    ));
  }

  Future writeFavDb(SongsModel song) async {
    var db = await database;
    db!.insert('songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore  
    ).whenComplete(() => 
      log("Favourite ${song.title}")
    );
  }

  Future deleteFavDb(SongsModel song) async {
    var db = await database;
    db!.delete('songs',
      where: 'docId=?',
      whereArgs: [song.docId]
    ).whenComplete(() => 
      log("delete ${song.title}")
    );
  }

  Future<List<SongsModel>> readFavDb() async {
    var db = await database;
    List<Map<String, dynamic>> result = await db!.query('songs');
    return List.generate(result.length, (index) => SongsModel(
      id: result[index]['id'], 
      artist: result[index]['artist'] ?? "", 
      title: result[index]['title'] ?? "", 
      album: result[index]['album'] ?? "", 
      timeStamp: DateTime.now(), 
      category: result[index]['category'] ?? "", 
      content: result[index]['content'] ?? "", 
      docId: result[index]['docId'] ?? "", 
    ));
  }
}


class DatabaseConnection{
	Future<Database>setDatabase() async {
		var directory = await getApplicationDocumentsDirectory();
		var path = join(directory.path, 'songs_db');
		var database =
		await openDatabase(path, version: 1, onCreate: _createDatabase);
		return database;
	}

	Future<void>_createDatabase(Database database, int version) async {
		String sql= 'CREATE TABLE songs(id INTEGER, artist TEXT NULL, title TEXT NULL, album TEXT NULL, timeStamp DATETIME NULL, category TEXT NULL,content TEXT NULL,docId TEXT)';
		await database.execute(sql);
	}
}