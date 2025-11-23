import 'package:go_router/go_router.dart';

import '../modules/home/home_page.dart';
// import '../modules/login/login_page.dart';
// import '../modules/scanner/scanner_page.dart';
// import '../modules/orcamento/orcamento_page.dart';
// import '../modules/lista/lista_page.dart';
// import '../modules/encartes/encartes_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    // GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    // GoRoute(path: '/scanner', builder: (_, __) => const ScannerPage()),
    // GoRoute(path: '/orcamento', builder: (_, __) => const OrcamentoPage()),
    // GoRoute(path: '/lista', builder: (_, __) => const ListaPage()),
    // GoRoute(path: '/encartes', builder: (_, __) => const EncartesPage()),
  ],
);
