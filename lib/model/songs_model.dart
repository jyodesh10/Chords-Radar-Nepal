
import 'package:cloud_firestore/cloud_firestore.dart';

class SongsModel {
  final int id;
  final String docId;
  final String artist;
  final String title;
  final String album;
  final DateTime timeStamp;
  final String category;
  final String content;
  SongsModel({
    required this.id,
    required this.docId,
    required this.artist,
    required this.title,
    required this.album,
    required this.timeStamp,
    required this.category,
    required this.content,
  });


  SongsModel copyWith({
    int? id,
    String? docId,
    String? singer,
    String? title,
    String? album,
    DateTime? timeStamp,
    String? category,
    String? content,

  }) {
    return SongsModel(
      id: id ?? this.id,
      artist: singer ?? artist,
      docId: docId ?? this.docId,
      title: title ?? this.title,
      album: album ?? this.album,
      timeStamp: timeStamp ?? this.timeStamp,
      category: category ?? this.category,
      content: content ?? this.content,
    );
  }

  SongsModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> map)
    : id = map['id'],
      docId = map['docId'],
      artist = map['artist'],
      title = map['title'],
      album = map['album'],
      timeStamp = DateTime.now(),
      category = map['category'],
      content = map['content'];
}
