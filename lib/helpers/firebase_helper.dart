import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/songs_model.dart';


class FirebaseHelper {
  final _firestore = FirebaseFirestore.instance;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<List<SongsModel>> getSongs(String orderBy) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await _firestore.collection('songs').orderBy(orderBy).get();
    log(data.docs.toString());
    return data.docs.map((e) => SongsModel.fromDocumentSnapshot(e)).toList();
  }

  Future deleteSong(String docId) async {
    await _firestore.collection('songs').doc(docId).delete().whenComplete(() => 
      log("delete $docId")
    );
  }

  Future<void> addToFBdatabase(SongsModel product) async {
    // Check if the product already exists in the cart
    QuerySnapshot existingProducts = await songs.where('id', isEqualTo: product.id).get();

    if (existingProducts.docs.isNotEmpty) {
      
    } else {
      // Product does not exist in the cart; add it
      DocumentReference docRef = FirebaseFirestore.instance.collection('songs').doc();

      Map<String, dynamic> productData = {
        "id": product.id,
        "docId": docRef.id,
        "artist": product.artist,
        "title": product.title,
        "album": product.album,
        "timeStamp": product.timeStamp,
        "category": product.category,
        "content": product.content,
      };

      await songs.doc(docRef.id).set(productData).then((value) => 
        log("Added new product to wishlist: ${product.title}")
      );
    }
  }
}