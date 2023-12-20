part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error
}

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  const HomeLoadedState({required this.songs});
  final List<SongsModel> songs;
  @override
  List<Object> get props => [songs];
}

class HomeErrorState extends HomeState {
  const HomeErrorState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];

}
