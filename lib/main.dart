import 'package:chord_radar_nepal/bloc/favorite_cubit/favorites_cubit.dart';
import 'package:chord_radar_nepal/bloc/home_bloc/home_bloc.dart';
import 'package:chord_radar_nepal/pages/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/tuner_bloc/tuner_bloc.dart';
import 'bloc/tunings_cubit/tunings_cubit.dart';
import 'helpers/db_helper.dart';
import 'utils/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await DBhelper().copyDatabaseToDevice();
  // await DBhelper().initialize();
  await DatabaseConnection().setDatabase();
  await SharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(const SongsEvent(filterBy: 'title')), 
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit()..readDb(), 
        ),
        BlocProvider<TunerBloc>(
          create: (context) => TunerBloc(),
        ),
        BlocProvider<TuningsCubit>(
          create: (context) => TuningsCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Chords Radar',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}