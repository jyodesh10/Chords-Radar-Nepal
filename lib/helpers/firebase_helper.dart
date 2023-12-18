import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/songs_model.dart';


class FirebaseHelper {
  CollectionReference wishlist = FirebaseFirestore.instance.collection('songs');
  Future<void> addToWishlist(SongsModel product) async {
    // Check if the product already exists in the cart
    QuerySnapshot existingProducts = await wishlist.where('id', isEqualTo: product.id).get();

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

      await wishlist.doc().set(productData).then((value) => 
        log("Added new product to wishlist: ${product.title}")
      );
    }
  }
}