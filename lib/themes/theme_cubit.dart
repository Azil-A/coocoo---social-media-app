import 'package:coocoo/themes/dark_mode.dart';
import 'package:coocoo/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData>{
  bool _isDarkMode = false;
  ThemeCubit() : super(lightMode);
  bool get isDarkMode => _isDarkMode;

   void toogleTheme(){
    _isDarkMode = !_isDarkMode;
    if(isDarkMode){
      emit(darkMode);
    }
    else{
      emit(lightMode);
    }
   }
}