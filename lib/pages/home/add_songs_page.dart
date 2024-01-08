import 'package:chord_radar_nepal/helpers/firebase_helper.dart';
import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class AddSongsPage extends StatefulWidget {
  const AddSongsPage({super.key});

  @override
  State<AddSongsPage> createState() => _AddSongsPageState();
}

class _AddSongsPageState extends State<AddSongsPage> {
  TextEditingController id = TextEditingController();
  TextEditingController docId = TextEditingController();
  TextEditingController artist = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController album = TextEditingController();
  TextEditingController timeStamp = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildTextField(artist, "artist"),
            const SizedBox(
              height: 10,
            ),
            _buildTextField(title, "title"),
            const SizedBox(
              height: 10,
            ),
            _buildTextField(album, "album"),
            const SizedBox(
              height: 10,
            ),
            _buildTextField(category, "category"),
            const SizedBox(
              height: 10,
            ),
            _buildTextField(content, "content", maxlines: 10),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: AppColors.neonBlue,
              onPressed: () {
                FirebaseHelper().addToFBdatabase(SongsModel(
                  id: 0,
                  docId: "", 
                  artist: (artist.text).capitalizeWords(), 
                  title: (title.text).capitalizeWords(), 
                  album: (album.text).capitalizeWords(), 
                  timeStamp: DateTime.now(), 
                  category: (category.text).capitalizeWords(), 
                  content: (content.text)
                )).whenComplete(() => 
                  Navigator.pop(context)
                );
              },
              child: const Text("Add") 
            )
          ],
        ),
      ),
    );
  }

  _buildTextField(controller, hint, {int? maxlines}) {
    return TextField(
      controller: controller,
      style: subtitleStyle.copyWith(color: AppColors.white),
      cursorColor: AppColors.neonBlue,
      maxLines: maxlines ?? 1,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: subtitleStyle.copyWith(
              color: AppColors.white.withOpacity(0.8)),
          filled: true,
          isDense: true,
          fillColor: AppColors.gunmetal,
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15))),
    );
  }
}


extension CapitalizeAfterSpace on String {
  String capitalizeWords() {
    final words = split(' ');
    return words.map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}