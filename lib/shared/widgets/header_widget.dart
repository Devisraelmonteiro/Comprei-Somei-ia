// lib/shared/widgets/header_widget.dart

import 'dart:ui';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  final String userName;
  final double remaining;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.remaining,
  });

  @override
  HeaderWidgetState createState() => HeaderWidgetState();
}

class HeaderWidgetState extends State<HeaderWidget> {
  double avatarSize = 40;
  bool showBalance = true;

  void updateAvatarSize(double newSize) {
    setState(() => avatarSize = newSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //-----------------------------------------
                // Avatar + "Olá, Fulano" + Olho
                //-----------------------------------------
                Row(
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        _openUserMenu(context, details.globalPosition);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/user.jpg"),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Olá, ${widget.userName}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () =>
                          setState(() => showBalance = !showBalance),
                      child: Icon(
                        showBalance ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                        color: const Color.fromARGB(255, 231, 148, 4),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                //-----------------------------------------
                // Texto "Saldo"
                //-----------------------------------------
                const Text(
                  "Saldo",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 231, 148, 4),
                  ),
                ),

                const SizedBox(height: 2),

                //-----------------------------------------
                // Valor / Oculto com Animação
                //-----------------------------------------
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    showBalance
                        ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
                        : "••••••",
                    key: ValueKey(showBalance),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 218, 145, 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------------------------------------
  // MENU DO AVATAR (Perfil, Configurações, Logout)
  //-------------------------------------------------------
  void _openUserMenu(BuildContext context, Offset tapPosition) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: "profile", child: Text("Meu Perfil")),
        PopupMenuItem(value: "settings", child: Text("Configurações")),
        PopupMenuItem(value: "logout", child: Text("Sair")),
      ],
    );

    if (result != null) {
      debugPrint("MENU → $result");
    }
  }
}
