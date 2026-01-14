import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🎨 Tema do App - VERSÃO 2025
/// 
/// Configurações globais de cores, fontes e estilos.
/// Usa ScreenUtil para tamanhos responsivos.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: Colors.orange,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    
    // ✅ Tamanhos de texto responsivos
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      
      headlineLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      
      titleLarge: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      
      bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),
      
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
    ),
    
    // ✅ Botões responsivos
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    ),
    
    // ✅ Input fields responsivos
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      labelStyle: TextStyle(fontSize: 14.sp),
      hintStyle: TextStyle(fontSize: 14.sp),
    ),
    
    // ✅ Cards responsivos
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    ),
    
    // ✅ Dialogs responsivos
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: Colors.black87,
      ),
    ),
    
    // ✅ Bottom sheets responsivos
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    ),
    
    // ✅ Snackbars responsivos
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      contentTextStyle: TextStyle(fontSize: 14.sp),
    ),
  );
}