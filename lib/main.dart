import 'package:flutter/material.dart';
import 'app/app_routes.dart';
import 'shared/styles/theme_styles.dart';
import 'shared/constants/app_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: customTheme, // 👉 Aqui aplica o tema customizado
    );
  }
}
