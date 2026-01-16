import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app.dart';

// Controllers
import 'modules/home/home_controller.dart';
import 'modules/lista/controllers/shopping_list_controller.dart';

/// 🔥 LISTA GLOBAL DE CÂMERAS (OBRIGATÓRIO NO iOS)
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 📸 INICIALIZA AS CÂMERAS
  cameras = await availableCameras();

  /// ✅ EDGE-TO-EDGE (ANDROID + iOS IGUAIS)
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  /// 🎨 STATUS BAR TRANSPARENTE (INVASÃO CONTROLADA PELO LAYOUT)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 🔥 FUNDAMENTAL
      statusBarIconBrightness: Brightness.light, // Android
      statusBarBrightness: Brightness.light, // iOS
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
      ],

      /// ✅ SCREENUTIL INIT - PADRÃO 2025
      child: ScreenUtilInit(
        // 📱 BASE DE DESIGN (iPhone 11)
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,

        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              /// 🔒 CONTROLE DE ESCALA DE TEXTO (UX + OCR)
              textScaleFactor: MediaQuery.of(context)
                  .textScaleFactor
                  .clamp(0.9, 1.2),
            ),
            child: child!,
          );
        },

        child: const App(),
      ),
    );
  }
}
