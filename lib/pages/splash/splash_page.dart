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
        // child: Center(child: Image.asset("assets/logo.png")),
        child: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "Chords\nRadar", 
                textStyle: titleStyle.copyWith(fontSize: 80 ),
                speed: const Duration(
                  milliseconds: 110
                )
              )
            ])
        ),
      ),
    );
  }
}