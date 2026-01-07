import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String userName;

  const AppDrawer({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // HEADER DO DRAWER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFF6B35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFFFF6B35),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nome do usuário
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Bem-vindo!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // MENU ITEMS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    icon: Icons.home,
                    title: "Home",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.receipt_long,
                    title: "Minhas Listas",
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar para listas
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.local_offer,
                    title: "Encartes",
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar para encartes
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.account_balance_wallet,
                    title: "Controle de Gastos",
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar para controle
                    },
                  ),
                  const Divider(height: 24),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: "Configurações",
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar para config
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "Ajuda",
                    onTap: () {
                      Navigator.pop(context);
                      // Navegar para ajuda
                    },
                  ),
                ],
              ),
            ),
            
            // FOOTER (Versão)
            Container(
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFF6B35),
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1a1a1a),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
