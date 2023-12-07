import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

class DBhelper {
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
      singer: result[index]['singer'] ?? "", 
      title: result[index]['title'] ?? "", 
      album: result[index]['album'] ?? "", 
      favourite: result[index]['favourite'], 
      favTimeStamp: DateTime.parse(result[index]['fav_timestamp'].toString()), 
      timeStamp: DateTime.parse(result[index]['timestamp']), 
      category: result[index]['category'] ?? "", 
      contributer: result[index]['contributor']?? "", 
      content: result[index]['content'] ?? "", 
      videoId: result[index]['video_id'] ?? "", 
      apId: result[index]['api_id'] ?? 0
    ));
  }
}