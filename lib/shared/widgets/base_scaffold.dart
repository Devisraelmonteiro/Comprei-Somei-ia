import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 2: context.go('/lista'); break;
      case 3: context.go('/encartes'); break;
      case 4: context.go('/orcamento'); break;
      case 5: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: Stack(
        children: [
          // FUNDO COMPLETO
          Positioned.fill(
            child: Image.asset(
              "assets/images/fundo.png",
              fit: BoxFit.cover,
            ),
          ),

          child,
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: -6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 79, 74, 74).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(22),
                ),

                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (i) => _onItemTapped(context, i),

                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,

                  selectedFontSize: 11,
                  unselectedFontSize: 11,

                  /// 🔥 TEXTO SEMPRE LARANJA
                  selectedItemColor: Color(0xFFE97F0C),
                  unselectedItemColor: Color(0xFFE97F0C),

                  /// 🔥 ÍCONES SEMPRE PRETOS (definidos individualmente)
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.home_2, color: Colors.black),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.note_text, color: Colors.black),
                      label: 'Lista de compras',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.ticket_discount, color: Colors.black),
                      label: 'Encartes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.wallet_3, color: Colors.black),
                      label: 'Controle de Gastos',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.setting_2, color: Colors.black),
                      label: 'Config.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
