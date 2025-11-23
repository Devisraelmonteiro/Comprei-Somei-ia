import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PromoBannerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PromoBannerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95, // 🔥 95% da largura
          height: 60, // 🔥 metade da altura anterior
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0B6B53),
                Color(0xFF094C3D),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // 💸 Fundo animado
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.30,
                    child: Lottie.asset(
                      'assets/lottie/dolarcompreisomei.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                ),

                // 🔥 Conteúdo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Textos à esquerda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "CompreiSomei no dia a dia",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14, // menor porque a altura diminuiu
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Economize usando o CompreiSomei",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ➡ Seta
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
