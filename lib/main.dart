import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytask/Screens/edit_screen.dart';
import 'package:mytask/Screens/home_screen.dart';
import 'package:mytask/bloc/user_bloc.dart';
import 'package:mytask/data_provider/data_provider.dart';
import 'package:mytask/repos/repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepo(
        UserDataProvider(),
      ),
      child: BlocProvider(
        create: (context) => UserBloc(
          context.read<UserRepo>(),
        )..add(InitialLoad()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Users App",
          routes: {
            HomeScreen.routeName: (context) => HomeScreen(),
            EditingScreen.routeName: (context) => EditingScreen()
          },
        ),
      ),
    );
  }
}
