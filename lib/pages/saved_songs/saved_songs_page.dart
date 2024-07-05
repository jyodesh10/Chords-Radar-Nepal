import 'package:chord_radar_nepal/bloc/favorite_cubit/favorites_cubit.dart';
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/pages/home/home_page.dart';
import 'package:chord_radar_nepal/widgets/snackbar_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_cubit/theme_cubit.dart';
import '../../model/songs_model.dart';
import '../../widgets/shimmer_widget.dart';
import '../song_chord/songchord_page.dart';

class SavedSongsPage extends StatefulWidget {
  const SavedSongsPage({super.key, this.fromSplash = false});
  final bool? fromSplash;

  @override
  State<SavedSongsPage> createState() => _SavedSongsPageState();
}

class _SavedSongsPageState extends State<SavedSongsPage> {
  late bool isLightmode;

  @override
  void initState() {
    super.initState();
    isLightmode = BlocProvider.of<ThemeCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightmode? AppColors.white : AppColors.charcoal,
      appBar: AppBar(
        backgroundColor: AppColors.deepTeal,
        leading: IconButton(
          onPressed: () {
            if(widget.fromSplash == true) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => true,);
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            FluentIcons.arrow_circle_left_48_regular,
            size: 40,
            color: AppColors.white7,
          ),
        ),
        title: Text(
          "Saved",
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
      ),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if(state is SnackBarState) {
            showSnackbar(context, state.msg);
          }
        },
        builder: (context, state) {
          if(state is FavoritesLoadingState) {
            return const ShimmerWidget();
          }
          if(state is FavoritesLoadedState) {
            List<SongsModel> songs = state.songs.reversed.toList();
            return SafeArea(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: isLightmode? AppColors.white : AppColors.charcoal,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongchordPage(
                                song: songs[index]
                                ),
                          ));
                    },
                    title: Text(
                      songs[index].title.toString(),
                      style: titleStyle.copyWith(
                        color:  isLightmode? AppColors.gunmetal.withOpacity(0.8) : AppColors.white.withOpacity(0.8),
                        fontSize: 15),                    ),
                    subtitle: Text(songs[index].artist.toString(),
                        style: subtitleStyle),

                    //delete
                    trailing: IconButton(
                        onPressed: () {
                          BlocProvider.of<FavoritesCubit>(context)
                              .deleteDb(songs[index]);
                        },
                        icon: const Icon(Icons.delete, color: AppColors.burntOrange,)),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
