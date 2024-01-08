import 'package:chord_radar_nepal/bloc/favorite_cubit/favorites_cubit.dart';
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/pages/saved_songs/saved_songs_page.dart';
import 'package:chord_radar_nepal/pages/search/search_page.dart';
import 'package:chord_radar_nepal/pages/song_chord/songchord_page.dart';
import 'package:chord_radar_nepal/pages/tuner/tuner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../model/songs_model.dart';
import '../../widgets/time_greetings.dart';
import 'add_songs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  List<SongsModel> favs = [];

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.deepTeal,
      // appBar: AppBar(
      //   title: const Text("Chord Radar Nepal"),
      // ),
      drawer: Drawer(
        backgroundColor: AppColors.charcoal,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.deepTeal),
                child: Container()),
            BlocBuilder<FavoritesCubit,FavoritesState>(
              builder: (context, state) {
                if(state is FavoritesLoadingState) {
                  return Container();
                } 
                if(state is FavoritesLoadedState) {
                  favs.addAll(state.songs);
                  return ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedSongsPage(),
                        )),
                    leading: const Icon(
                      FluentIcons.arrow_circle_down_right_24_regular,
                      color: AppColors.white,
                    ),
                    title: Text(
                      "Saved",
                      style: titleStyle,
                    ),
                  );
                }
                return Container();
              },
            ),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TunerPage(),
                  )),
              leading: const Icon(
                FluentIcons.music_note_1_24_regular,
                color: AppColors.white,
              ),
              title: Text(
                "Tuner",
                style: titleStyle,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return _buildLoading();
            }
            if (state is HomeLoadedState) {
              final result = state.songs;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: AppColors.charcoal,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongchordPage(
                                        song: result[index]),
                                  ));
                            },
                            title: Text(
                              result[index].title.toString(),
                              style: titleStyle.copyWith(fontSize: 15),
                            ),
                            subtitle: Text(result[index].artist.toString(),
                                style: subtitleStyle),

                            //delete
                            // trailing: IconButton(
                            //   onPressed: () async {
                            //     await FirebaseHelper().deleteSong(result[index].docId).whenComplete(() {
                            //       // BlocProvider.of<HomeBloc>(context).add(const SongsEvent());
                            //       log("delete ${result[index].docId}");
                            //     });
                            //     // FirebaseHelper().deleteSong(result[index].id.toString());
                            //   } ,
                            //   icon: const Icon(Icons.delete)),
                          );
                        },
                      ),
                    ),
                    _buildTop(result)
                  ],
                ),
              );
            }
            if (state is HomeErrorState) {
              return Center(
                child: Text(state.message.toString()),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "f1",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSongsPage(),) );
            }
          ),
          FloatingActionButton(
              heroTag: "f2",
              backgroundColor: AppColors.deepTeal,
              child: const Icon(
                FluentIcons.filter_32_filled,
                color: AppColors.white,
              ),
              onPressed: () {
                debugPrint(favs.toString());
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: AppColors.charcoal,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Filter By",
                          style: titleStyle.copyWith(color: AppColors.neonBlue),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          onTap: () {
                            BlocProvider.of<HomeBloc>(context)
                                .add(const SongsEvent(filterBy: "artist"));
                            Navigator.pop(context);
                          },
                          leading: const Icon(
                            FluentIcons.filter_20_regular,
                            color: AppColors.white,
                          ),
                          title: Text("Artist",
                              style: subtitleStyle.copyWith(
                                  color: AppColors.white.withOpacity(0.8))),
                        ),
                        ListTile(
                          onTap: () {
                            BlocProvider.of<HomeBloc>(context)
                                .add(const SongsEvent(filterBy: "title"));
                            Navigator.pop(context);
                          },
                          leading: const Icon(
                            FluentIcons.filter_20_regular,
                            color: AppColors.white,
                          ),
                          title: Text(
                            "Title",
                            style: subtitleStyle.copyWith(
                                color: AppColors.white.withOpacity(0.8)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  _buildTop(List<SongsModel> songs) {
    return Container(
      color: AppColors.deepTeal,
      height: 200,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  )),
              const SizedBox(
                width: 20,
              ),
              const TimeGreeting(),
              const Spacer(),
              Builder(
                  builder: (context) => IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FluentIcons.settings_48_filled,
                        size: 35,
                        color: AppColors.gunmetal,
                      )))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Hero(
            tag: "search",
            child: Material(
              color: Colors.transparent,
              child: TextField(
                style: subtitleStyle.copyWith(color: AppColors.white),
                cursorColor: AppColors.neonBlue,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SearchPage(
                      query: value,
                      songsList: songs,
                    ), 
                    )
                  );
                },
                decoration: InputDecoration(
                    hintText: "Search songs & artist..",
                    hintStyle: subtitleStyle.copyWith(
                        color: AppColors.white.withOpacity(0.8)),
                    filled: true,
                    isDense: true,
                    fillColor: AppColors.gunmetal,
                    prefixIcon: const Icon(
                      FluentIcons.search_48_regular,
                      color: AppColors.neonBlue,
                      size: 30,
                    ),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTop([]),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: AppColors.charcoal,
            child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade500.withOpacity(0.7),
                      highlightColor: Colors.grey.shade200.withOpacity(0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 10,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 10,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ],
                      ),
                    )),
          ))
        ],
      ),
    );
  }
}
