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
      appBar: AppBar(
        title: const Text("Chord Radar Nepal"),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if(state is HomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is HomeLoadedState) {
            final result = state.songs;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SongchordPage(song: result[index]),
                              ));
                        },
                        title: Text(result[index].title.toString()),
                        subtitle: Text(result[index].singer.toString()),
                      );
                    },
                  )
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
      )
    );
  }
}
