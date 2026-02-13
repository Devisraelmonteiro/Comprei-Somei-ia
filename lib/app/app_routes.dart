import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:comprei_some_ia/modules/home/home_page.dart';
import 'package:comprei_some_ia/modules/login/login_page.dart';
import 'package:comprei_some_ia/modules/cadastro/cadastro_page.dart';
import 'package:comprei_some_ia/modules/splash/splash_page.dart'; // Import da Splash
// import '../modules/scanner/scanner_page.dart';
// import '../modules/orcamento/orcamento_page.dart';
import 'package:comprei_some_ia/modules/lista/lista_page.dart';
import 'package:comprei_some_ia/modules/orcamento/orcamento_page.dart';
import 'package:comprei_some_ia/modules/encartes/pages/encarte_page.dart';
import 'package:comprei_some_ia/modules/churrascometro/pages/churrascometro_page.dart';
import 'package:comprei_some_ia/modules/profile/profile_page.dart';

final router = GoRouter(
  initialLocation: '/splash', // Define Splash como inicial
  routes: [
    // Rota raiz redireciona para /splash
    GoRoute(
      path: '/',
      redirect: (context, state) => '/splash',
    ),
    
    // SPLASH
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    
    // HOME
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(), // ← SEM const
    ),
    
    // LOGIN
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    
    // CADASTRO
    GoRoute(
      path: '/cadastro',
      builder: (context, state) => const CadastroPage(),
    ),
    
    // SCANNER (comentado)
    // GoRoute(
    //   path: '/scanner',
    //   builder: (context, state) => const ScannerPage(),
    // ),
    
    // ORÇAMENTO
    GoRoute(
      path: '/orcamento',
      builder: (context, state) => const OrcamentoPage(),
    ),
    
    // LISTA
    GoRoute(
      name: 'lista',
      path: '/lista',
      builder: (context, state) => const ListaPage(),
    ),
    
    // ENCARTES
    GoRoute(
      path: '/encartes',
      builder: (context, state) => const EncartePage(),
    ),
    
    // CHURRASCÔMETRO
    GoRoute(
      path: '/churrascometro',
      builder: (context, state) => const ChurrascometroPage(),
    ),
    
    // PERFIL (MENU)
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProfilePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Efeito de surgir (Fade) suave, sem deslizar
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          );
        },
      ),
    ),
    // GoRoute(
    //   path: '/settings',
    //   builder: (context, state) => const SettingsPage(),
    // ),
  ],
);
