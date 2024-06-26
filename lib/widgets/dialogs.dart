import 'package:flutter/material.dart';

buildDialog(context,child, {Color? backgroundClr}){
  showDialog(context: context,
   builder:(context) {
     return Dialog(
      backgroundColor:backgroundClr ?? Colors.white70,
      alignment: Alignment.center,
      elevation: 2,
      child: child,
     );
   }, 
  
  );
}