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
import 'package:comprei_some_ia/modules/profile/edit_profile_page.dart';
import 'package:comprei_some_ia/modules/calculator/calculator_page.dart';
import 'package:comprei_some_ia/modules/help/help_page.dart';
import 'package:comprei_some_ia/modules/login/forgot_password_page.dart';

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
      pageBuilder: (context, state) => _fadeTransition(context, state, const SplashPage()),
    ),
    
    // HOME
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _fadeTransition(context, state, HomePage()), // ← SEM const
    ),
    
    // LOGIN
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _fadeTransition(context, state, const LoginPage()),
    ),
    GoRoute(
      path: '/forgot_password',
      pageBuilder: (context, state) => _fadeTransition(context, state, const ForgotPasswordPage()),
    ),
    
    // CADASTRO
    GoRoute(
      path: '/cadastro',
      pageBuilder: (context, state) => _fadeTransition(context, state, const CadastroPage()),
    ),
    
    // SCANNER (comentado)
    // GoRoute(
    //   path: '/scanner',
    //   builder: (context, state) => const ScannerPage(),
    // ),
    
    // ORÇAMENTO
    GoRoute(
      path: '/orcamento',
      pageBuilder: (context, state) => _fadeTransition(context, state, const OrcamentoPage()),
    ),
    
    // LISTA - Mantém a transição padrão (Slide)
    GoRoute(
      name: 'lista',
      path: '/lista',
      builder: (context, state) => const ListaPage(),
    ),
    
    // ENCARTES
    GoRoute(
      path: '/encartes',
      pageBuilder: (context, state) => _fadeTransition(context, state, const EncartePage()),
    ),
    
    GoRoute(
      path: '/help',
      pageBuilder: (context, state) => _fadeTransition(context, state, const HelpPage()),
    ),
    
    // CHURRASCÔMETRO
    GoRoute(
      path: '/churrascometro',
      pageBuilder: (context, state) => _fadeTransition(context, state, const ChurrascometroPage()),
    ),
    
    // PERFIL (MENU)
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => _fadeTransition(context, state, const ProfilePage()),
    ),

    // EDITAR PERFIL
    GoRoute(
      path: '/edit_profile',
      pageBuilder: (context, state) => _fadeTransition(context, state, const EditProfilePage()),
    ),
    
    // CALCULADORA
    GoRoute(
      path: '/calculator',
      pageBuilder: (context, state) => _fadeTransition(context, state, const CalculatorPage()),
    ),
    
    // GoRoute(
    //   path: '/settings',
    //   builder: (context, state) => const SettingsPage(),
    // ),
  ],
);

// Helper para transição de Fade
Page<dynamic> _fadeTransition(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeIn).animate(animation),
        child: child,
      );
    },
  );
}
