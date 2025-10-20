import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../shared/theme.dart';

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
