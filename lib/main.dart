import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import 'app/app.dart';

// Controllers
import 'modules/home/home_controller.dart';
import 'modules/lista/controllers/shopping_list_controller.dart';
// import 'modules/scanner/scanner_controller.dart';
// import 'modules/orcamento/orcamento_controller.dart';
// import 'modules/lista/lista_controller.dart';
// import 'modules/encartes/encartes_controller.dart';
// import 'modules/login/login_controller.dart';
// import 'modules/settings/settings_controller.dart';

/// 🔥 LISTA GLOBAL DE CÂMERAS (OBRIGATÓRIO NO iOS)
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 📸 INICIALIZA AS CÂMERAS ANTES DO APP
  cameras = await availableCameras();

  /// 🔥 STATUS BAR VERDE + ÍCONES BRANCOS
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0B6B53), // fundo verde
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.dark, // iOS
    ),
  );

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ShoppingListController()),
        // ChangeNotifierProvider(create: (_) => ScannerController()),
        // ChangeNotifierProvider(create: (_) => OrcamentoController()),
        // ChangeNotifierProvider(create: (_) => ListaController()),
        // ChangeNotifierProvider(create: (_) => EncartesController()),
        // ChangeNotifierProvider(create: (_) => LoginController()),
        // ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: const App(),
    );
  }
}
