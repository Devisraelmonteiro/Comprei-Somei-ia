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
      case 1: context.go('/scanner'); break;
      case 2: context.go('/lista'); break;
      case 3: context.go('/encartes'); break;
      case 4: context.go('/orcamento'); break;
      case 5: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // 🔥 deixa o fundo visível atrás do footer
      body: Stack(
        children: [
          // 🔥 FUNDO DA TELA COMPLETA
          Positioned.fill(
            child: Image.asset(
              "assets/images/fundo.png",
              fit: BoxFit.cover,
            ),
          ),

          // CONTEÚDO NORMAL
          child,
        ],
      ),

      // FOOTER
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
                  color: Colors.white.withOpacity(0.10), // 🔥 Transparente
                  borderRadius: BorderRadius.circular(22),
                ),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (i) => _onItemTapped(context, i),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,

                  iconSize: 22,
                  selectedFontSize: 11,
                  unselectedFontSize: 11,

                  selectedItemColor: Color(0xFFE97F0C), // 🔥 laranja bonito
                  unselectedItemColor: Colors.black87, // 🔥 ícones pretos

                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.home_2),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.note_text),
                      label: 'Lista',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.ticket_discount),
                      label: 'Encartes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.wallet_3),
                      label: 'Orçamento',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Iconsax.setting_2),
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
