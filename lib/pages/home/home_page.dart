
import 'dart:developer';

import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/helpers/db_helper.dart';
import 'package:chord_radar_nepal/pages/song_chord/songchord_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../helpers/firebase_helper.dart';
import '../../model/songs_model.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    readDb();
  }

  List<SongsModel> result = [];
  readDb() async {
    result = await DBhelper().readDb();
    log(result.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      // appBar: AppBar(
      //   title: const Text("Chord Radar Nepal"),
      // ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is HomeLoadingState) {
              return _buildLoading();
            }
            if(state is HomeLoadedState) {
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
                                    builder: (context) =>
                                        SongchordPage(song: result[index]),
                                  ));
                            },
                            title: Text(result[index].title.toString(), style: titleStyle.copyWith(fontSize: 15), ),
                            subtitle: Text(result[index].artist.toString(), style: subtitleStyle),

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
                    _buildTop()
                  ],
                ),
              );
            }
            if(state is HomeErrorState) {
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
          // FloatingActionButton(
          //   heroTag: "f1",
          //   onPressed: () async {
          //     try {
          //       for (var i = 0; i < result.length; i++) {
          //         await FirebaseHelper().addToFBdatabase(result[i]).whenComplete(() => 
          //           log("Complte $i")
          //         );
          //       }
          //     } finally {
          //       log("Compoletr");
          //     }
          //   } 
          // ),
          FloatingActionButton(
            heroTag: "f2",
            backgroundColor: AppColors.deepTeal,
            child: const Icon(FluentIcons.filter_32_filled, color: AppColors.white,),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) => Dialog(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: AppColors.charcoal,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Filter By", style: titleStyle.copyWith(color: AppColors.neonBlue),),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () {
                          BlocProvider.of<HomeBloc>(context).add(const SongsEvent(filterBy: "artist"));
                          Navigator.pop(context);
                        },
                        leading: const Icon(FluentIcons.filter_20_regular, color: AppColors.white,),
                        title: Text("Artist", style:  subtitleStyle.copyWith(color: AppColors.white.withOpacity(0.8))),
                      ),
                      ListTile(
                        onTap: () {
                          BlocProvider.of<HomeBloc>(context).add(const SongsEvent(filterBy: "title"));
                          Navigator.pop(context);
                        },
                        leading: const Icon(FluentIcons.filter_20_regular, color: AppColors.white, ),
                        title: Text("Title", style:  subtitleStyle.copyWith(color: AppColors.white.withOpacity(0.8)),),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            } 
          ),
        ],
      ),
    );
  }
  
  _buildTop() {
    return Container(
      color: AppColors.deepTeal,
      height: 200,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Good Evening,\nUser", style: titleStyle,),
              IconButton(
                onPressed: (){}, 
                icon: const Icon(FluentIcons.settings_48_filled, size: 35, color: AppColors.gunmetal,) 
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            style: subtitleStyle.copyWith(color: AppColors.white),
            cursorColor: AppColors.neonBlue,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "Search songs & artist..",
              hintStyle: subtitleStyle.copyWith(color: AppColors.white.withOpacity(0.8)),
              filled: true,
              isDense: true,
              fillColor: AppColors.gunmetal,
              prefixIcon: const Icon(FluentIcons.search_48_regular, color: AppColors.neonBlue, size: 30,),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              )
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
          _buildTop(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: AppColors.charcoal,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => 
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade500.withOpacity(0.7),
                    highlightColor: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 10,
                          width: 200,
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          height: 10,
                          width: 120,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
              ),
            )
          )
        ],
      ),
    );
  }
}
