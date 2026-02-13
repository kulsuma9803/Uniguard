import 'package:flutter/material.dart';
import 'package:uniguard/constants/app_colors.dart';

ThemeData appTheme() => ThemeData(
  useMaterial3: false,
  primaryColor: AppColors.primaryDarkGreen,
  scaffoldBackgroundColor: AppColors.secondaryDarkGreen,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryDarkGreen,
    secondary: AppColors.lightGreen,
    surface: AppColors.cardGreen,
    background: AppColors.secondaryDarkGreen,
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    shadowColor: Colors.black26,
    color: AppColors.cardGreen,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white12,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGreen)),
  ),
);