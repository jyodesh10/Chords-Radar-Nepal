
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_cubit/theme_cubit.dart';
import '../song_chord/songchord_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.songsList});

  final List<SongsModel> songsList;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SongsModel> searchResult = [];
  final searchCon = TextEditingController();
  late bool isLightmode;

  @override
  void initState() {
    super.initState();
    // searchProduct(widget.query);
    isLightmode = BlocProvider.of<ThemeCubit>(context).state;
    // searchCon.text = widget.query;
    
  }

  searchProduct(query) {
    searchResult = searchSentences(widget.songsList, query);
    setState(() {
    });
  }
  
  List<SongsModel> searchSentences(List<SongsModel> songs, String searchTerm) {
    searchTerm = searchTerm.toLowerCase().trim();
    List<String> listTitle = songs.map((e) => e.title.toLowerCase()).toList();
    List<String> listArtist = songs.map((e) => e.artist.toLowerCase()).toList();

    List<SongsModel> results = [];

    for (var j = 0; j < songs.length; j++) {
      if (listTitle[j].contains(searchTerm)) {
        results.add(songs[j]);
      }
      for (int i = 0; i < listArtist.length; i++) {
        if (listArtist[i].contains(searchTerm)) {
          if(listArtist[i].contains(songs[j].artist.toLowerCase())){
            results.add(songs[j]);
          }
        }
      }
    }
    // for (int i = 0; i < listArtist.length; i++) {
    //   if (listArtist[i].contains(searchTerm)) {
    //     for (var j = 0; j < songs.length; j++) {
    //       if(listArtist[i].contains(songs[j].artist.toLowerCase())){
    //         results.add(songs[j]);
    //       }
    //     }
    //   }
    // }


    return results.toSet().toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightmode? AppColors.white : AppColors.charcoal,
      appBar: AppBar(
        backgroundColor: AppColors.deepTeal,
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
          "Search",
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 100), 
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Hero(
              tag: 'search',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: searchCon,
                  style: subtitleStyle.copyWith(color: AppColors.white),
                  cursorColor: AppColors.neonBlue,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  onSubmitted: (value) {
                    searchProduct(value);
                  },
                  onChanged: (value) {
                    searchProduct(value);
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
            ),
          )
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics (),
          itemCount: searchResult.length,
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: isLightmode? AppColors.white : AppColors.charcoal,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongchordPage(
                          song: searchResult[index]
                          ),
                    ));
              },
              title: Text(
                searchResult[index].title.toString(),
                style: titleStyle.copyWith(fontSize: 15, color: isLightmode? AppColors. gunmetal.withOpacity(0.8) : AppColors.white),
              ),
              subtitle: Text(searchResult[index].artist.toString(),
                  style: subtitleStyle),
            );
          },
        ),
      ),
    );
  }
}