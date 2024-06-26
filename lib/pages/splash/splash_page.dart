import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:chord_radar_nepal/pages/home/home_page.dart';
import 'package:chord_radar_nepal/pages/saved_songs/saved_songs_page.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../widgets/snackbar_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
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
        color: AppColors.charcoal,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded(
            //   flex: 4,
            //   child: Image.asset("assets/no_bg.png", height: 130, width: 130, )),
            Expanded(
              flex: 5,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Chords\nRadar", 
                    textStyle: titleStyle.copyWith(fontSize: 50),
                    speed: const Duration(
                      milliseconds: 110
                    )
                  ),
                  TypewriterAnimatedText(
                    "Nepali Song Chords", 
                    textStyle: titleStyle.copyWith(fontSize: 20),
                    speed: const Duration(
                      milliseconds: 110
                    )
                  ),

                ]),
            ),
          ],
        ),
      ),
    );
  }
}