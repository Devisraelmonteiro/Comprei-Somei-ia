import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_controller.dart';
import '../../shared/constants/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // ==========================================================
  // ⚙️ CONTROLE VISUAL DO FUNDO (Edite aqui)
  // ==========================================================
  final double _backgroundOpacity = 0.9; // 0.0 (invisível) a 1.0 (totalmente visível)
  final double _blurIntensity = 10.0;    // Quanto maior, mais desfocado (vidro fosco)
  // ==========================================================

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Configura animação de entrada (Fade + Slide Up)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    // Inicia animação após build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Esconde a barra de status para imersão total
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (login.png)
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Opacity(
              opacity: _backgroundOpacity, // Controlado pela constante acima
              child: Image.asset(
                'assets/images/fundo9.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. LOGO GIGANTE ARTÍSTICA (Background Element)
          // "Logo alinhado a esquerda , gingande ao fundo do header ate o imputs de fundo"
          Positioned(
            left: -80.w, // Alinhado bem à esquerda
            top: 100.h,    // Começando da área do header
            width: 500.w, // Tamanho massivo (10x maior) para dominar o fundo
            height: 500.h, // Altura massiva para permitir a largura crescer
            child: Opacity(
              opacity: 1.0, // Opacidade total para ser o elemento principal
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          // 3. CAMADA DE VIDRO (Blur sobre toda a tela para unificar)
          // "Por cima da tela o blur"
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _blurIntensity, sigmaY: _blurIntensity), // Controlado pela constante
              child: Container(
                color: Colors.black.withOpacity(0.1), // Leve tintura escura para contraste
              ),
            ),
          ),

          // 4. CONTEÚDO PRINCIPAL (Animado)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento Apple style (Esquerda)
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      
                      // Logo Principal (Removida conforme solicitação)
                      // "tem 2 logo o de fundo e o no header o do header apaga"
                      // Hero(
                      //   tag: 'app_logo',
                      //   child: Image.asset(
                      //     'assets/images/logo.png',
                      //     width: 64.w,
                      //     height: 64.w,
                      //   ),
                      // ),
                      
                      SizedBox(height: 100.h), // Espaço compensatório para o header limpo

                      // Título de Boas-vindas (Tipografia Grande e Clean)
                      Text(
                        'Bem-vindo.',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold, // San Francisco Bold
                          color: const Color.fromARGB(255, 233, 118, 3),
                          letterSpacing: -0.5,
                          height: 1.1,
                          fontFamily: '.SF Pro Display', // Força SF Pro no iOS se disponível
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Faça login para continuar.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500, // Medium weight
                          color: const Color.fromARGB(255, 22, 22, 22), // Cor da marca (Laranja) conforme solicitado "não tudo branco"
                          letterSpacing: 0,
                          fontFamily: '.SF Pro Text', // Força SF Pro Text no iOS
                        ),
                      ),

                      SizedBox(height: 60.h),

                      // INPUTS MINIMALISTAS (Apple Style)
                      // "Campos parecidos com esse da imagem" (Linha fina, sem borda boxy)
                      _buildAppleTextField(
                        controller: _emailController,
                        label: 'E-mail',
                        hint: 'nome@exemplo.com',
                        inputType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 32.h),

                      _buildAppleTextField(
                        controller: _passwordController,
                        label: 'Senha',
                        hint: '••••••••',
                        isPassword: true,
                      ),

                      SizedBox(height: 16.h),

                      // Esqueci senha (Discreto)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 240, 154, 6).withOpacity(0.8),
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Esqueceu a senha?',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // BOTÕES DE AÇÃO (Pill Shape)
                      Consumer<LoginController>(
                        builder: (context, controller, child) {
                          return Column(
                            children: [
                              // Botão Acessar (Primário - Branco)
                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading
                                      ? null
                                      : () async {
                                          final success = await controller.login(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                          if (success && mounted) {
                                            context.go('/home');
                                          } else if (controller.errorMessage != null && mounted) {
                                            // Haptic Feedback para erro (Toque Premium)
                                            HapticFeedback.mediumImpact();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(controller.errorMessage!),
                                                backgroundColor: Colors.redAccent,
                                                behavior: SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black, // Contraste máximo
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100.r), // Pílula perfeita
                                    ),
                                  ),
                                  child: controller.isLoading
                                      ? SizedBox(
                                          height: 24.h,
                                          width: 24.h,
                                          child: const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(Colors.black),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Acessar',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Botão Cadastrar (Secundário - Outline)
                              SizedBox(
                                width: double.infinity,
                                height: 56.h,
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.push('/cadastro');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Criar conta',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          keyboardType: inputType,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2), // Highlight branco puro
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        _obscurePassword ? 'Mostrar' : 'Ocultar',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
