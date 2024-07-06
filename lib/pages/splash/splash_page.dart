import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../bloc/theme_cubit/theme_cubit.dart';
import '../../widgets/snackbar_widget.dart';
import '../home/home_page.dart';
import '../saved_songs/saved_songs_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool isLightmode;

  @override
  void initState() {
    super.initState();
    isLightmode = BlocProvider.of<ThemeCubit>(context).state;
    Future.delayed(const Duration(milliseconds: 1880), () async {
      final result = await checkConnection();
      if(result){
        if(mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        }
      } else {
        if(mounted) {
          showSnackbar(context, "No Internet Connection", backclr: AppColors.burntOrange, durationInMill: 1200);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const SavedSongsPage(fromSplash: true,)));
        }
      }
    },);  
  }

  Future<bool> checkConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: isLightmode ? AppColors.white :AppColors.charcoal,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child:
               Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Image.asset("assets/logo.png", height: 150, width: 150, ),
                   const SizedBox(
                    height: 15,
                   ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Chords Radar", 
                          textStyle: titleStyle.copyWith(fontSize: 22, color: AppColors.olive),
                          textAlign: TextAlign.center,
                          speed: const Duration(
                            milliseconds: 100
                          )
                        ),
                      ]),
                   const SizedBox(
                    height: 8,
                   ),
                    AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(
                          "Nepali Music Chords", 
                          textStyle: subtitleStyle.copyWith(fontSize: 18, color: isLightmode ? AppColors.charcoal: AppColors.neonBlue),
                          // speed: const Duration(
                          //   milliseconds: 120
                          // )
                        ),
                      ]),
                 ],
               )
              ),
            // Expanded(
            //   flex: 5,
            //   child: AnimatedTextKit(
            //     animatedTexts: [
            //       TypewriterAnimatedText(
            //         "Chords\nRadar", 
            //         textStyle: titleStyle.copyWith(fontSize: 50),
            //         speed: const Duration(
            //           milliseconds: 110
            //         )
            //       ),
            //       TypewriterAnimatedText(
            //         "Nepali Song Chords", 
            //         textStyle: titleStyle.copyWith(fontSize: 20),
            //         speed: const Duration(
            //           milliseconds: 110
            //         )
            //       ),

            //     ]),
            // ),
          ],
        ),
      ),
    );
  }
}