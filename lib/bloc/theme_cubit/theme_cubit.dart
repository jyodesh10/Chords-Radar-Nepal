import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/shared_pref.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  lightmode(bool isLightMode) {
    SharedPref.write("isLightTheme", isLightMode);
    emit(isLightMode);
  }
}
