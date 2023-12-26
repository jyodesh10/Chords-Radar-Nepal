import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../song_chord/songchord_page.dart';

class SavedSongsPage extends StatefulWidget {
  const SavedSongsPage({super.key, required this.songs});

  final List<SongsModel> songs;

  @override
  State<SavedSongsPage> createState() => _SavedSongsPageState();
}

class _SavedSongsPageState extends State<SavedSongsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: AppBar(
        backgroundColor: AppColors.deepTeal,
        leading: IconButton(
          onPressed: () { Navigator.pop(context); }, 
          icon: const Icon(FluentIcons.arrow_circle_left_48_regular, size: 40, color: AppColors.charcoal,),
        ),
        title: Text("Saved",overflow: TextOverflow.ellipsis, style: titleStyle, ),
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: AppColors.charcoal,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SongchordPage(song: widget.songs[index], savedSongs: widget.songs),
                    ));
              },
              title: Text(widget.songs[index].title.toString(), style: titleStyle.copyWith(fontSize: 15), ),
              subtitle: Text(widget.songs[index].artist.toString(), style: subtitleStyle),

              //delete
              trailing: IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.delete)),
            );
          },
        ),
      ),
    );
  }
}