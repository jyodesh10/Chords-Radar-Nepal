import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

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
      debugPrint(controller.position.maxScrollExtent.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0).copyWith(top: 200),
                width: double.infinity,
                color: AppColors.charcoal,
                child: Text(widget.song.content.toString(), style: subtitleStyle.copyWith(color: AppColors.white), ),
              ),
              Container(
                height: 130,
                color: AppColors.deepTeal,
                child: Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        onPressed: () { Navigator.pop(context); }, 
                        icon: const Icon(FluentIcons.arrow_circle_left_48_regular, size: 40, color: AppColors.charcoal,),
                      ),
                      title: Text(widget.song.title,overflow: TextOverflow.ellipsis, style: titleStyle, ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: (controller.position.maxScrollExtent.round().toInt()/13).round()), curve: Curves.ease);
                        },
                        icon: const Icon(FluentIcons.play_circle_48_regular, size: 40, color: AppColors.charcoal,), 
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30).copyWith(top: 70),
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.olive,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: AppColors.charcoal.withOpacity(0.4),
                      offset: const Offset(2, 2)
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.white.withOpacity(0.7)
                        ),
                        child: const Icon(FluentIcons.music_note_2_24_filled, color: AppColors.neonBlue,),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.song.title,overflow: TextOverflow.ellipsis, maxLines: 2, style: titleStyle.copyWith(fontSize: 16),),
                          const SizedBox(height: 5,),
                          Text(widget.song.singer,overflow: TextOverflow.ellipsis, style: subtitleStyle.copyWith(color: AppColors.white),),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(onPressed: () {}, icon: const Icon(FluentIcons.heart_48_filled) ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}