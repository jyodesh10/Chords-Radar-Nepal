
import 'dart:convert';

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
    String? artist,
    String? title,
    String? album,
    DateTime? timeStamp,
    String? category,
    String? content,
  }) {
    return SongsModel(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      artist: artist ?? this.artist,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'docId': docId,
      'artist': artist,
      'title': title,
      'album': album,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'category': category,
      'content': content,
    };
  }

  factory SongsModel.fromMap(Map<String, dynamic> map) {
    return SongsModel(
      id: map['id']?.toInt() ?? 0,
      docId: map['docId'] ?? '',
      artist: map['artist'] ?? '',
      title: map['title'] ?? '',
      album: map['album'] ?? '',
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp']),
      category: map['category'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongsModel.fromJson(String source) => SongsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SongsModel(id: $id, docId: $docId, artist: $artist, title: $title, album: $album, timeStamp: $timeStamp, category: $category, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SongsModel &&
      other.id == id &&
      other.docId == docId &&
      other.artist == artist &&
      other.title == title &&
      other.album == album &&
      other.timeStamp == timeStamp &&
      other.category == category &&
      other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      docId.hashCode ^
      artist.hashCode ^
      title.hashCode ^
      album.hashCode ^
      timeStamp.hashCode ^
      category.hashCode ^
      content.hashCode;
  }
}
