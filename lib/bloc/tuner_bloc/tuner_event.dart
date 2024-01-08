part of 'tuner_bloc.dart';

abstract class TunerEvent extends Equatable {
  const TunerEvent();

  @override
  List<Object> get props => [];
}

class StartRecordingEvent extends TunerEvent {
  const StartRecordingEvent();

  @override
  List<Object> get props => [];
}

class StopRecordingEvent extends TunerEvent {
  const StopRecordingEvent();

  @override
  List<Object> get props => [];
}