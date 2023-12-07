import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:flutter/material.dart';

class SongchordPage extends StatefulWidget {
  const SongchordPage({super.key, required this.song});
  final SongsModel song;

  @override
  State<SongchordPage> createState() => _SongchordPageState();
}

class _SongchordPageState extends State<SongchordPage> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(() { 
      print(controller.position.maxScrollExtent.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title,overflow: TextOverflow.ellipsis, ),
        actions: [
          IconButton(
            onPressed: () {
              controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: (controller.position.maxScrollExtent.round().toInt()/13).round()), curve: Curves.ease);
            }, 
            icon: const Icon(Icons.play_arrow)
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.song.content.toString()),
            )
          ],
        ),
      ),
    );
  }
}