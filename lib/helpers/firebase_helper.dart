import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/songs_model.dart';


class FirebaseHelper {
  final _firestore = FirebaseFirestore.instance;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<List<SongsModel>> getSongs() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _firestore.collection('songs').get();
    log(data.docs.toString());
    return data.docs.map((e) => SongsModel.fromDocumentSnapshot(e)).toList();
  }

  Future<void> addToFBdatabase(SongsModel product) async {
    // Check if the product already exists in the cart
    QuerySnapshot existingProducts = await songs.where('id', isEqualTo: product.id).get();

    if (existingProducts.docs.isNotEmpty) {
      
    } else {
      // Product does not exist in the cart; add it
      Map<String, dynamic> productData = {
        "id": product.id,
        "singer": product.singer,
        "title": product.title,
        "album": product.album,
        "favourite": product.favourite,
        "favTimeStamp": product.favTimeStamp,
        "timeStamp": product.timeStamp,
        "category": product.category,
        "contributer": product.contributer,
        "content": product.content,
        "videoId": product.videoId,
        "apId": product.apId,
      };

      await songs.doc().set(productData).then((value) => 
        log("Added new product to wishlist: ${product.title}")
      );
    }
  }
}