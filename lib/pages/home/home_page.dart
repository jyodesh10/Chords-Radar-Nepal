import 'package:chord_radar_nepal/bloc/favorite_cubit/favorites_cubit.dart';
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/helpers/firebase_helper.dart';
import 'package:chord_radar_nepal/pages/saved_songs/saved_songs_page.dart';
import 'package:chord_radar_nepal/pages/search/search_page.dart';
import 'package:chord_radar_nepal/pages/song_chord/songchord_page.dart';
import 'package:chord_radar_nepal/pages/tuner/tuner_page.dart';
import 'package:chord_radar_nepal/utils/shared_pref.dart';
import 'package:chord_radar_nepal/widgets/dialogs.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/home_bloc/home_bloc.dart';
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
    getPermissions();
    checkFirstTime();
  }

  List<SongsModel> favs = [];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();


  TextEditingController namecontroller =TextEditingController();
  TextEditingController artistcontroller =TextEditingController();
  TextEditingController songcontroller =TextEditingController();

  checkFirstTime() {
    if(SharedPref.read("isFirstTime") == null || SharedPref.read("isFirstTime") == true ) {
      SharedPref.write("isFirstTime", false);
      Future.delayed(const Duration(seconds: 1), () => 
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
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
                    "Add Username",
                    style: titleStyle.copyWith(color: AppColors.neonBlue),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: namecontroller,
                        textInputAction: TextInputAction.done,
                        style: titleStyle,
                        validator: (value) {
                           if (value == null || value.isEmpty) {
                            return "*required";
                          } 
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if(formKey.currentState!.validate()) {
                            SharedPref.write("username", value.trim().capitalizeWords() ).whenComplete(() {
                              setState(() {
                              });
                              namecontroller.clear();
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: AppColors.deepTeal,
                    child: Text("Submit", style: titleStyle, ),
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        SharedPref.write("username", namecontroller.text.trim().capitalizeWords()).whenComplete(() {
                          setState(() {
                          });
                          namecontroller.clear();
                          Navigator.pop(context);
                        });
                      }
                    }
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )
      );
    }
  }

  getPermissions() async {
    var status = await Permission.microphone.request();
    if(status.isDenied) {
      if(mounted) {
        buildDialog(
          context,  
          const Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              ListTile(
                title: Text("Premission required for guitar tuner"),
              )
            ]
          )  
        );
      } 
    }
  }

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
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.deepTeal),
              child: Container(
                height: 150,
                width: 150,
                margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 5 ),
                // decoration: BoxDecoration(
                //   color: AppColors.charcoal,
                //   borderRadius: BorderRadius.circular(20),
                //   boxShadow: const [
                //     BoxShadow(
                //       blurRadius: 10,
                //       offset: Offset(0, 2),
                //     )
                //   ]
                // ),
                child: Image.asset("assets/logo.png")
              )
            ),
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoadingState) {
                  return Container();
                }
                if (state is FavoritesLoadedState) {
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
                      style: titleStyle.copyWith(fontSize: 18),
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
                style: titleStyle.copyWith(fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () {
                Share.share('Check out Chords Radar Nepal: https://play.google.com/store/apps/details?id=com.zyodes.chord_radar_nepal', subject: 'Nepali Music Chords Application');
              },
              leading: const Icon(
                FluentIcons.share_24_regular,
                color: AppColors.white,
              ),
              title: Text(
                "Share",
                style: titleStyle.copyWith(fontSize: 18)
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                buildDialog(
                  context,
                  backgroundClr: AppColors.charcoal,
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Artist",
                          style: subtitleStyle.copyWith(color: AppColors.neonBlue),
                        ),
                        TextFormField(
                          controller: artistcontroller,
                          textInputAction: TextInputAction.done,
                          style: subtitleStyle.copyWith(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "*required";
                            } 
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Song",
                          style: subtitleStyle.copyWith(color: AppColors.neonBlue),
                        ),
                        TextFormField(
                          controller: songcontroller,
                          textInputAction: TextInputAction.done,
                          style: subtitleStyle.copyWith(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "*required";
                            } 
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          color: AppColors.deepTeal,
                          child: Text("Submit", style: titleStyle, ),
                          onPressed: () {
                            FirebaseHelper().addRequest(context, artistcontroller.text, songcontroller.text);
                          }
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                );
              },
              leading: const Icon(
                FluentIcons.more_circle_24_regular,
                color: AppColors.white,
              ),
              title: Text(
                "Request For Song Chords",
                style: titleStyle.copyWith(fontSize: 18)
              ),
            ),
            const Spacer(),
            Text("App Version: 1.0.0", style: subtitleStyle.copyWith(fontSize: 12),),
            const SizedBox(
              height: 10,
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
                                    builder: (context) =>
                                        SongchordPage(song: result[index]),
                                  ));
                            },
                            title: Hero(
                              tag: result[index].docId,
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  result[index].title.toString(),
                                  style: titleStyle.copyWith(fontSize: 15),
                                ),
                              ),
                            ),
                            subtitle: Text(result[index].artist.toString(),
                                style: subtitleStyle),

                            //delete
                            // trailing: IconButton(
                            //   onPressed: () async {
                            //     await FirebaseHelper().deleteSong(result[index].docId).whenComplete(() {
                            //       // BlocProvider.of<HomeBloc>(context).add(const SongsEvent()); 
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
          // FloatingActionButton(
          //     heroTag: "f1",
          //     child: const Icon(Icons.add),
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const AddSongsPage(),
          //           ));
          //     }),
          FloatingActionButton(
              heroTag: "f2",
              backgroundColor: AppColors.deepTeal,
              child: const Icon(
                FluentIcons.filter_32_filled,
                color: AppColors.white,
              ),
              onPressed: () {
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
                            FluentIcons.person_24_regular,
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
                            FluentIcons.list_24_regular,
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
                  icon: Icon(
                    FluentIcons.options_24_filled,
                    color: AppColors.white7,
                    size: 30,
                  )),
              const SizedBox(
                width: 20,
              ),
              TimeGreeting(
                username: SharedPref.read("username") ?? "User" 
              ),
              const Spacer(),
              // Builder(
              //     builder: (context) => IconButton(
              //         onPressed: () {},
              //         icon: const Icon(
              //           FluentIcons.settings_48_filled,
              //           size: 35,
              //           color: AppColors.gunmetal,
              //         )))
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          query: value,
                          songsList: songs,
                        ),
                      ));
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
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
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
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 10,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
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
