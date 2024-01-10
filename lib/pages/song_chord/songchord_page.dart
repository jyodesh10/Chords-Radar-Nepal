import 'package:chord_radar_nepal/bloc/favorite_cubit/favorites_cubit.dart';
import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';

class SongchordPage extends StatefulWidget {
  const SongchordPage(
      {super.key, required this.song});
  final SongsModel song;

  @override
  State<SongchordPage> createState() => _SongchordPageState();
}

class _SongchordPageState extends State<SongchordPage> {
  late ScrollController controller;
  bool autoScroll = false;
  int scrollTime = 6;
  double sliderval = 0.1;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()
      ..addListener(() {
        // debugPrint(controller.offset.toString());
        if (autoScroll) {
          // controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: (controller.position.maxScrollExtent.round().toInt()/scrollTime).round()), curve: Curves.ease);
        }
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
              //contexnt lyrics chords
              InteractiveViewer(
                minScale: 0.1,
                maxScale: 1.6,
                child: Container(
                  padding: const EdgeInsets.all(10.0)
                      .copyWith(top: 200, bottom: 100),
                  width: double.infinity,
                  color: AppColors.charcoal,
                  child: Text(
                    widget.song.content.toString(),
                    style: subtitleStyle.copyWith(color: AppColors.white),
                  ),
                ),
              ),
              //top
              Container(
                height: 130,
                color: AppColors.deepTeal,
                child: Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          FluentIcons.arrow_circle_left_48_regular,
                          size: 40,
                          color: AppColors.charcoal,
                        ),
                      ),
                      title: Text(
                        widget.song.title,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          controller
                              .animateTo(200,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease)
                              .whenComplete(() => animate());
                          setState(() {
                            autoScroll = true;
                          });
                        },
                        tooltip: "Autoplay",
                        icon: const Icon(
                          FluentIcons.play_circle_48_regular,
                          size: 40,
                          color: AppColors.charcoal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //mid song & artist info
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                    return Container(
                      margin: const EdgeInsets.all(30).copyWith(top: 70),
                      height: 125,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.olive,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 20,
                                color: AppColors.charcoal.withOpacity(0.4),
                                offset: const Offset(2, 2))
                          ]),
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
                                  color: AppColors.white.withOpacity(0.7)),
                              child: const Icon(
                                FluentIcons.music_note_2_24_filled,
                                color: AppColors.neonBlue,
                              ),
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
                                Hero(
                                  tag: widget.song.docId,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      widget.song.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: titleStyle.copyWith(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.song.artist,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitleStyle.copyWith(
                                      color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: state is FavoritesLoadedState 
                              ? IconButton(
                                onPressed: () {
                                  if(state.songs.map((e) => e.docId).toList().contains(widget.song.docId)==false) {
                                    BlocProvider.of<FavoritesCubit>(context).writeDb(widget.song);
                                  } else {
                                    BlocProvider.of<FavoritesCubit>(context).deleteDb(widget.song);
                                  }
                                },
                                icon: Icon(
                                  FluentIcons.heart_48_filled,
                                  color: state.songs
                                          .map((e) => e.docId)
                                          .toList()
                                          .contains(widget.song.docId)
                                      ? Colors.red.shade400
                                      : AppColors.charcoal,
                                )
                              )
                              : Container()
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: autoScroll
          ? Container(
              color: AppColors.deepTeal,
              alignment: Alignment.center,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Slider(
                      activeColor: AppColors.gunmetal,
                      value: sliderval,
                      onChanged: (value) {
                        debugPrint((value * 100).round().toString());
                        setState(() {
                          sliderval = value;
                          scrollTime = (5 + (value * 100)).round();
                          animate();
                        });
                      },
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              autoScroll = false;
                              controller.animateTo(0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease);
                            });
                          },
                          icon: const Icon(FluentIcons.pause_48_filled)))
                ],
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  animate() {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(
            seconds: /* scrollTime */
                (controller.position.maxScrollExtent.round().toInt() /
                        scrollTime)
                    .round()),
        curve: Curves.ease);
  }
}
