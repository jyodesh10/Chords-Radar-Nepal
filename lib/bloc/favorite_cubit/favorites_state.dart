part of 'favorites_cubit.dart';

enum Status {
  initial,
  loading,
  loaded,
  error
}

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  const FavoritesLoadedState(this.songs);
  final List<SongsModel> songs;

  @override
  List<Object> get props => [songs];
}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesErrorState extends FavoritesState {}

