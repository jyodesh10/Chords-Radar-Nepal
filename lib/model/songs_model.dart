
import 'package:cloud_firestore/cloud_firestore.dart';

class SongsModel {
  final int id;
  final String singer;
  final String title;
  final String album;
  final int favourite;
  final DateTime favTimeStamp;
  final DateTime timeStamp;
  final String category;
  final String contributer;
  final String content;
  final String videoId;
  final int apId;
  SongsModel({
    required this.id,
    required this.singer,
    required this.title,
    required this.album,
    required this.favourite,
    required this.favTimeStamp,
    required this.timeStamp,
    required this.category,
    required this.contributer,
    required this.content,
    required this.videoId,
    required this.apId,
  });


  SongsModel copyWith({
    int? id,
    String? singer,
    String? title,
    String? album,
    int? favourite,
    DateTime? favTimeStamp,
    DateTime? timeStamp,
    String? category,
    String? contributer,
    String? content,
    String? videoId,
    int? apId,
  }) {
    return SongsModel(
      id: id ?? this.id,
      singer: singer ?? this.singer,
      title: title ?? this.title,
      album: album ?? this.album,
      favourite: favourite ?? this.favourite,
      favTimeStamp: favTimeStamp ?? this.favTimeStamp,
      timeStamp: timeStamp ?? this.timeStamp,
      category: category ?? this.category,
      contributer: contributer ?? this.contributer,
      content: content ?? this.content,
      videoId: videoId ?? this.videoId,
      apId: apId ?? this.apId,
    );
  }

  SongsModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> map)
    : id = map['id'],
      singer = map['singer'],
      title = map['title'],
      album = map['album'],
      favourite = map['favourite'],
      favTimeStamp = DateTime.now(),
      timeStamp = DateTime.now(),
      category = map['category'],
      contributer = map['contributer'],
      content = map['content'],
      videoId = map['videoId'],
      apId = map['apId'];
}
