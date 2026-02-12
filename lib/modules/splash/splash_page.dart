import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../shared/constants/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // Configura imersão (tela cheia)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // 1. Animação de "Respiração" (Pulse) do Logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Animação de Rotação (para o efeito de "loading" estilo Apple dots)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Rotação lenta e elegante
    )..repeat();

    // 3. Navegação após delay
    Timer(const Duration(seconds: 4), () {
      // Retorna a barra de status ao normal antes de sair
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.white, // Fundo branco profissional e limpo
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Efeito de Fundo (Opcional - Círculos sutis para profundidade)
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.05), // Laranja bem suave
                ),
              ),
            ),
            
            // Centro: Logo + Animação estilo Apple
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Círculo de Pontos (Apple Style Dots) - Animado
                  RotationTransition(
                    turns: _rotationController,
                    child: SizedBox(
                      width: 250.w, // Aumentado para acomodar os múltiplos anéis
                      height: 250.w,
                      child: CustomPaint(
                        painter: ComplexDotsPainter(
                          colors: [
                            AppColors.primary,    // Laranja Principal
                            AppColors.primaryLight, // Laranja Claro
                            AppColors.secondary,  // Verde
                            AppColors.accent,     // Azul
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Logo Central (Pulsando)
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Hero(
                      tag: 'app_logo', // Hero animation para a tela de login
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 140.w, // Aumentado de 100 para 140
                        height: 140.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Texto de Carregando (Opcional, minimalista)
            Positioned(
              bottom: 80.h,
              child: Text(
                'Carregando...',
                style: TextStyle(
                  color: AppColors.primary, // Texto na cor da marca
                  fontSize: 12.sp,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter Avançado (Estilo Apple Multi-layer Dots)
class ComplexDotsPainter extends CustomPainter {
  final List<Color> colors;

  ComplexDotsPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    
    // Configurações dos anéis (Rings)
    // Cada anel tem: raio relativo, quantidade de dots, tamanho base do dot
    final rings = [
      _RingConfig(radiusFactor: 1.0, dotCount: 24, baseDotSize: 6.0),
      _RingConfig(radiusFactor: 0.85, dotCount: 20, baseDotSize: 5.0),
      _RingConfig(radiusFactor: 0.70, dotCount: 16, baseDotSize: 4.0),
      _RingConfig(radiusFactor: 0.55, dotCount: 12, baseDotSize: 3.0),
    ];

    for (int r = 0; r < rings.length; r++) {
      final ring = rings[r];
      final currentRadius = maxRadius * ring.radiusFactor;
      
      for (int i = 0; i < ring.dotCount; i++) {
        // Ângulo para cada ponto
        final angle = (i * 2 * math.pi) / ring.dotCount;
        
        // Offset (deslocamento) para criar o padrão espiral/intercalado
        // Cada anel começa um pouco rotacionado em relação ao anterior
        final rotationOffset = (r * math.pi / 8); 
        final finalAngle = angle + rotationOffset;

        final x = center.dx + currentRadius * math.cos(finalAngle);
        final y = center.dy + currentRadius * math.sin(finalAngle);

        // Variação de tamanho baseada na posição (Senoide) para dar movimento visual
        // Isso faz alguns pontos serem maiores que outros em um padrão suave
        final sizeVariation = 1.0 + 0.3 * math.sin(i * 0.5); 
        final dotSize = ring.baseDotSize * sizeVariation;

        // Gradiente de Cores
        // Seleciona a cor baseada no índice do ponto para criar o degradê
        final colorIndex = (i / ring.dotCount * colors.length).floor() % colors.length;
        final nextColorIndex = (colorIndex + 1) % colors.length;
        final t = (i / ring.dotCount * colors.length) - colorIndex;
        
        final color = Color.lerp(colors[colorIndex], colors[nextColorIndex], t) ?? Colors.white;

        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingConfig {
  final double radiusFactor;
  final int dotCount;
  final double baseDotSize;

  _RingConfig({
    required this.radiusFactor,
    required this.dotCount,
    required this.baseDotSize,
  });
}
