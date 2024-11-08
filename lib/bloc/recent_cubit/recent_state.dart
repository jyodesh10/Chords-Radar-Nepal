part of 'recent_cubit.dart';

abstract class RecentState extends Equatable {
  const RecentState();

  @override
  List<Object> get props => [];
}

class RecentInitial extends RecentState {}


class LoadRecentState extends RecentState {
  const LoadRecentState(this.recentList);
  final List recentList;

  @override
  List<Object> get props => [recentList];
}