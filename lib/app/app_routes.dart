import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Alias para evitar conflitos entre páginas com nomes iguais
import '../modules/login/login_page.dart' as login;
import '../modules/home/home_page.dart' as home;
import '../modules/scanner/scanner_page.dart';
import '../modules/lista/lista_page.dart';
import '../modules/encartes/encartes_page.dart';
import '../modules/orcamento/orcamento_page.dart';
import '../modules/settings/settings_page.dart';
import '../modules/cadastro/cadastro_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const login.LoginPage(),
    ),
    GoRoute(
      path: '/cadastro',
      name: 'cadastro',
      builder: (context, state) => const CadastroPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const home.HomePage(),
    ),
    GoRoute(
      path: '/scanner',
      name: 'scanner',
      builder: (context, state) => const ScannerPage(),
    ),
    GoRoute(
      path: '/lista',
      name: 'lista',
      builder: (context, state) => const ListaPage(),
    ),
    GoRoute(
      path: '/encartes',
      name: 'encartes',
      builder: (context, state) => const EncartesPage(),
    ),
    GoRoute(
      path: '/orcamento',
      name: 'orcamento',
      builder: (context, state) => const OrcamentoPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
