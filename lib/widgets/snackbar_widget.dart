import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:flutter/material.dart';

showSnackbar(BuildContext context, text, {Color? backclr, int? durationInMill}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
      text,
      style:  subtitleStyle.copyWith(color: AppColors.white),
      ),
      duration: Duration(
        milliseconds: durationInMill ?? 400
      ),
      backgroundColor: backclr ?? AppColors.deepTeal,
    )
  ); 
}