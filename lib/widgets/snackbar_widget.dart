import 'package:chord_radar_nepal/constants/constants.dart';
import 'package:flutter/material.dart';

showSnackbar(BuildContext context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
      text,
      style:  subtitleStyle.copyWith(color: AppColors.white),
      ),
      duration: const Duration(
        milliseconds: 400
      ),
      backgroundColor: AppColors.deepTeal,
    )
  ); 
}