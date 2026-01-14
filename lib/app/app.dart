import 'package:flutter/material.dart';
import 'package:comprei_some_ia/shared/theme/theme.dart';
import 'app_routes.dart';

/// ✅ APP.DART JÁ ESTÁ CORRETO!
/// 
/// O ScreenUtil foi configurado no main.dart (AppRoot),
/// então este arquivo não precisa de modificações.
/// 
/// A configuração de textScaleFactor também já está
/// aplicada no nível superior (main.dart).
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Comprei.Somei.IA',
      theme: buildAppTheme(),
      routerConfig: router,
      
      // ✅ OPCIONAL: Desabilitar banner de debug
      debugShowCheckedModeBanner: false,
    );
  }
}