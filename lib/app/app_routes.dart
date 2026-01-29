import 'package:go_router/go_router.dart';

import 'package:comprei_some_ia/modules/home/home_page.dart';
// import '../modules/login/login_page.dart';
// import '../modules/scanner/scanner_page.dart';
// import '../modules/orcamento/orcamento_page.dart';
import 'package:comprei_some_ia/modules/lista/lista_page.dart';
import 'package:comprei_some_ia/modules/orcamento/orcamento_page.dart';
// import '../modules/encartes/encartes_page.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    // Rota raiz redireciona para /home
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),
    
    // HOME
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(), // ← SEM const
    ),
    
    // LOGIN (comentado)
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) => const LoginPage(),
    // ),
    
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
    
    // ENCARTES (comentado)
    // GoRoute(
    //   path: '/encartes',
    //   builder: (context, state) => const EncartesPage(),
    // ),
    
    // SETTINGS (adicional - para o drawer)
    // GoRoute(
    //   path: '/settings',
    //   builder: (context, state) => const SettingsPage(),
    // ),
  ],
);
