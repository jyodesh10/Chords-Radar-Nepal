import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/shared_pref.dart';

part 'recent_state.dart';

class RecentCubit extends Cubit<RecentState> {
  RecentCubit() : super(RecentInitial());
  List recentlist = [];

  checkRecent() {
    recentlist.clear();
    var recentprevdata = SharedPref.read("recent");
    if(recentprevdata != null) {
      Map data = jsonDecode(recentprevdata);
      recentlist.addAll(data["data"]);
      recentlist = recentlist.reversed.toList();
      emit(LoadRecentState(recentlist));
    }
  }

  addRecent({docId, artist, title, album, category, content}) {
    var recentprevdata = SharedPref.read("recent");
    if(recentprevdata == null) {
      SharedPref.write("recent", {
        "data" : [
          {
            "docId": docId,
            "artist": artist,
            "title": title,
            "album": album,
            "date": DateTime.now().toString(),
            "category": category,
            "content": content
          }
        ]
      });
      // setState(() {
        checkRecent();
      // });
    } else {
      Map oldData = jsonDecode(recentprevdata);
      if(oldData['data'].map((e) => e["docId"]).toList().contains(docId)){
        oldData['data'].removeWhere((element) => element["docId"] == docId);
      }
      oldData['data'].add({
        "docId": docId,
        "artist": artist,
        "title": title,
        "album": album,
        "date": DateTime.now().toString(),
        "category": category,
        "content": content           
      });
      Map newData = oldData;
      SharedPref.write("recent", newData);
      // setState(() {
        checkRecent();
      // });
    }
  }
}
