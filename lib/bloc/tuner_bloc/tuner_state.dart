part of 'tuner_bloc.dart';

abstract class TunerState extends Equatable {
  const TunerState();
  
  @override
  List<Object> get props => [];
}

class TunerInitial extends TunerState {}


class RecordingState extends TunerState {
  final String note;
  final String status;

  const RecordingState({
    required this.note,
    required this.status,
  });

  @override
  List<Object> get props => [note, status];
}
class NotRecordingState extends TunerState {}

class RE extends TunerState {}