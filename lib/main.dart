import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';

// Controllers
import 'modules/home/home_controller.dart';
// import 'modules/scanner/scanner_controller.dart';
// import 'modules/orcamento/orcamento_controller.dart';
// import 'modules/lista/lista_controller.dart';
// import 'modules/encartes/encartes_controller.dart';
// import 'modules/login/login_controller.dart';
// import 'modules/settings/settings_controller.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
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
