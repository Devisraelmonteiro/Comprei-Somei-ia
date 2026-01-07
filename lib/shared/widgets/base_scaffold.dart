import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String? userName;

  const BaseScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
    this.userName,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/lista'); break;
      case 2: context.go('/encartes'); break;
      case 3: context.go('/orcamento'); break;
      case 4: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      drawer: userName != null ? _buildDrawer(context) : null,

      body: child,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF68A07),
                      Color(0xFFE45C00),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (i) => _onItemTapped(context, i),

                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,

                  selectedFontSize: 12,
                  unselectedFontSize: 12,

                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,

                  iconSize: 24,

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
                      label: 'Controle',
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

  // ================= DRAWER =================

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF68A07),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    userName ?? "Usuário",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bem-vindo!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(context, Icons.home, "Home", '/home'),
                  _buildMenuItem(context, Icons.receipt_long, "Minhas Listas", '/lista'),
                  _buildMenuItem(context, Icons.local_offer, "Encartes", '/encartes'),
                  _buildMenuItem(context, Icons.account_balance_wallet, "Controle de Gastos", '/orcamento'),
                  const Divider(height: 24),
                  _buildMenuItem(context, Icons.settings, "Configurações", '/settings'),
                  _buildMenuItem(context, Icons.help_outline, "Ajuda", null),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "CompreiSomei v1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE97F0C), size: 26),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != null) context.go(route);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    );
  }
}