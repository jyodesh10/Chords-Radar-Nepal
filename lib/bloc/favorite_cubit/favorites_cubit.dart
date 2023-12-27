import 'package:chord_radar_nepal/model/songs_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/db_helper.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  readDb() async {
    try {
      emit(FavoritesLoadingState());
      var favs = await DBhelper().readFavDb();
      emit(FavoritesLoadedState(favs));
    } on Exception {
      emit(FavoritesErrorState());
    }
    
  }

  writeDb(SongsModel song) async {
    await DBhelper().writeFavDb(song).whenComplete(() {
      emit(const SnackBarState("Saved Offlne"));
      readDb();
    }
    );
  }
  deleteDb(SongsModel song) async {
    await DBhelper().deleteFavDb(song).whenComplete(() {
      emit(const SnackBarState("Removed Saved"));
      readDb();
    }
    );
  }

}
