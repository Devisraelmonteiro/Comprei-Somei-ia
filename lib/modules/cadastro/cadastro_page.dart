import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/constants/app_colors.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // ==========================================================
  // ⚙️ CONTROLE VISUAL DO FUNDO (Consistente com Login)
  // ==========================================================
  final double _backgroundOpacity = 0.9;
  final double _blurIntensity = 10.0;
  
  final _emailController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Esconde a barra de status para imersão total
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Criar Conta',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (login.png)
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Opacity(
              opacity: _backgroundOpacity,
              child: Image.asset(
                'assets/images/fundo9.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. LOGO GIGANTE ARTÍSTICA (Background Element)
          Positioned(
            left: -80.w,
            top: 120.h,
            width: 500.w,
            height: 500.h,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
              ),
            ),
          ),

          // 3. CAMADA DE VIDRO (Blur sobre toda a tela para unificar)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _blurIntensity, sigmaY: _blurIntensity),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // 4. CONTEÚDO PRINCIPAL
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    
                    _buildAppleTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'nome@exemplo.com',
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24.h),
                    
                    _buildAppleTextField(
                      controller: _userController,
                      label: 'Usuário',
                      hint: 'Seu nome de usuário',
                    ),
                    SizedBox(height: 24.h),
                    
                    _buildAppleTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      hint: '••••••••',
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    SizedBox(height: 24.h),
                    
                    _buildAppleTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirme sua senha',
                      hint: '••••••••',
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Botão Cadastrar (Gradiente Laranja - Footer Style)
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.bottomNavGradient,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: adicionar lógica de cadastro
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                        child: Text(
                          'Cadastrar',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
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
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
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
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onToggleVisibility,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        obscureText ? 'Mostrar' : 'Ocultar',
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
