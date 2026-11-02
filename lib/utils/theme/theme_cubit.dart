import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/utils/theme/app_theme.dart';

class ThemeCubit extends Cubit<BaseAppTheme> {
  ThemeCubit() : super(LightAppTheme()) {
    _getDefaultTheme();
  }

  void changeTheme(bool isDark) async {
    if (isDark) {
      emit(LightAppTheme());
    } else {
      emit(LightAppTheme());
    }
  }

  void setDefaultTheme() async {
    emit(LightAppTheme());
  }

  void _getDefaultTheme() async {
    // const isDark = false;
    // if (isDark) {
    //   emit(LightAppTheme());
    // } else {
    emit(LightAppTheme());
    // }
  }
}
