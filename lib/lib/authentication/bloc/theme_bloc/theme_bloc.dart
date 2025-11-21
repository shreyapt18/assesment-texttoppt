import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_shreya/authentication/bloc/theme_bloc/theme_event.dart';
import 'package:task_shreya/authentication/bloc/theme_bloc/theme_state.dart';




// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: ThemeData.light())) {
    on<ToggleThemeEvent>((event, emit) {
      if (state.themeData.brightness == Brightness.light) {
        emit(ThemeState(themeData: ThemeData.dark()));
      } else {
        emit(ThemeState(themeData: ThemeData.light()));
      }
    });
  }
}
