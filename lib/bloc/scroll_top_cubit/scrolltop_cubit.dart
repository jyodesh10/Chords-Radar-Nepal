
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scrolltop_state.dart';

class ScrolltopCubit extends Cubit<bool> {
  ScrolltopCubit() : super(false);

  scrollToTop (bool scrollTop) {
    emit(scrollTop);
  }
}
