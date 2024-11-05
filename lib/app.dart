import 'package:coocoo/features/Profile/data/firebase_profile_repo.dart';
import 'package:coocoo/features/Profile/presentation/blocs/profile_cubit.dart';
import 'package:coocoo/features/auth/data/firebase_auth_repo.dart';

import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/Home/presentation/pages/home_screen.dart';
import 'package:coocoo/features/auth/presentation/pages/auth_page.dart';
import 'package:coocoo/features/post/data/firebase_post_repo.dart';
import 'package:coocoo/features/post/presentation/blocs/post_cubit.dart';
import 'package:coocoo/features/search/data/firebase_search_repo.dart';
import 'package:coocoo/features/search/presentation/cubits/search_cubit.dart';
import 'package:coocoo/features/storage/data/firebase_storage_repo.dart';
import 'package:coocoo/themes/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo(); 

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepo: firebaseAuthRepo)..checkAuth()),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
              profileRepo: firebaseProfileRepo,
              storageRepo: firebaseStorageRepo),
        ),
        BlocProvider(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        BlocProvider<SearchCubit>(create:(context)=>SearchCubit(searchRepo: firebaseSearchRepo),),
        BlocProvider(create: (context)=>ThemeCubit())
      ],
      child:BlocBuilder<ThemeCubit,ThemeData>(builder: (context,currentTheme)=> 
      MaterialApp(
        routes: {
          // '/profile':(context)=>ProfilePage(uid: ,)
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: currentTheme,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthUnAuthenicated) {
              return const AuthPage();
            }
            if (state is AuthAuthenicated) {
              return const HomeScreen();
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('error')));
            }
          },
        ),
      ),)
    );
  }
}
