import 'package:chord_radar_nepal/helpers/firebase_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// import '../../helpers/db_helper.dart';
import '../../model/songs_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<SongsEvent>((event, emit) async {
      try {
        emit(HomeLoadingState());
        final data = await FirebaseHelper().getSongs(event.filterBy); 
        // await DBhelper().readDb();
        if(data.isNotEmpty){
          emit(HomeLoadedState(songs: data));
        }else{
          emit(const HomeErrorState(message: "Error Loading Songs"));
        }
      } on Exception catch (e) {
        emit(HomeErrorState(message: e.toString()));
      }
    });
  }
}
