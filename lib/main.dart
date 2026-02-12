import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app.dart';

// Controllers
import 'modules/home/home_controller.dart';
import 'modules/login/login_controller.dart';
import 'modules/lista/controllers/shopping_list_controller.dart';
import 'modules/encartes/controllers/encarte_controller.dart';
import 'modules/churrascometro/controllers/churrascometro_controller.dart';

/// 🔥 LISTA GLOBAL DE CÂMERAS (OBRIGATÓRIO NO iOS)
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 📸 INICIALIZA AS CÂMERAS
  cameras = await availableCameras();

  /// ✅ EDGE-TO-EDGE (ANDROID + IOS)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// 🎨 STATUS BAR TRANSPARENTE
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
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
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ShoppingListController()),
        ChangeNotifierProvider(create: (_) => EncarteController()),
        ChangeNotifierProvider(create: (_) => ChurrascometroController()),
      ],
      child: ScreenUtilInit(
        /// 📐 BASE DE DESIGN (layout travado)
        designSize: const Size(375, 812),
        minTextAdapt: false,
        splitScreenMode: true,

        builder: (context, child) {
          final media = MediaQuery.of(context);

          return MediaQuery(
            data: media.copyWith(
              /// 🔒 TRAVA DEFINITIVA DO TAMANHO DA FONTE
              textScaleFactor: 1.0,
            ),
            child: child!,
          );
        },

        child: const App(),
      ),
    );
  }
}
