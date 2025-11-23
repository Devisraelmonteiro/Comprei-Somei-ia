// lib/shared/widgets/header_widget.dart

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,

      /// 🔥 Mesma cor / gradiente do fundo da Home!
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(0, 11, 107, 83),
            Color.fromARGB(0, 9, 76, 61),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-------------------------------------
            // Avatar + Nome + Olhinho
            //-------------------------------------
            Row(
              children: [
                AnimatedContainer(
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
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Olá, ${widget.userName}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 11, 0, 0),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () => setState(() => showBalance = !showBalance),
                  child: Icon(
                    showBalance ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 7, 0, 0),
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              "Saldo",
              style: TextStyle(
                color: Color.fromARGB(179, 20, 0, 0),
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 2),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                showBalance
                    ? "R\$ ${widget.remaining.toStringAsFixed(2)}"
                    : "••••••",
                key: ValueKey(showBalance),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 114, 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
