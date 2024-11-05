import 'package:coocoo/themes/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    bool isDarkMode = themeCubit.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Column(
        children: [ListTile(
          title: Text('Dark Mode'),
          trailing: CupertinoSwitch(value: isDarkMode, onChanged: (value){
            themeCubit.toogleTheme();
          }),

        )],
      ),
    );
  }
}