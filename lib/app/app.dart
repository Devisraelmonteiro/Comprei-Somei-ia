import 'package:flutter/material.dart';
import 'package:comprei_some_ia/shared/theme/theme.dart';
import 'app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Comprei.Somei.IA',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
