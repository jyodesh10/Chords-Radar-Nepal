
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/pages/song_chord/songchord_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc/home_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWood,
      // appBar: AppBar(
      //   title: const Text("Chord Radar Nepal"),
      // ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if(state is HomeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(state is HomeLoadedState) {
              final result = state.songs;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    ListView.builder(
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
                          subtitle: Text(result[index].singer.toString(), style: subtitleStyle),
                        );
                      },
                    ),
                    Container(
                      color: AppColors.warmWood,
                      height: 200,
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good Evening", style: titleStyle,),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Search songs & artist..",
                              hintStyle: subtitleStyle.copyWith(color: AppColors.white.withOpacity(0.8)),
                              filled: true,
                              fillColor: AppColors.honeyOak,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              )
                            ),
                          )
                        ],
                      ),
                    )
                    // FloatingActionButton(
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
    );
  }
}
