import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../home_controller.dart';

class MultiplierSheet extends StatefulWidget {
  final HomeController controller;

  const MultiplierSheet({super.key, required this.controller});

  @override
  State<MultiplierSheet> createState() => _MultiplierSheetState();
}

class _MultiplierSheetState extends State<MultiplierSheet> {
  String _multStr = '';
  double _baseValue = 0.0;

  @override
  void initState() {
    super.initState();
    _baseValue = widget.controller.capturedValue;
    // Se não houver valor capturado, assume 0 (ou poderia ser 1 para teste)
    if (_baseValue <= 0) _baseValue = 0.0;
  }

  void _onKeyPress(String key) {
    HapticFeedback.lightImpact();
    setState(() {
      if (key == 'backspace') {
        _removeDigit();
      } else if (key == 'C') {
        _clearInput();
      } else {
        _addDigit(int.parse(key));
      }
    });
  }

  void _addDigit(int digit) {
    // Limita a 2 dígitos (até 99x)
    if (_multStr.length >= 2) return;
    // Não permitir começar com 0
    if (_multStr.isEmpty && digit == 0) return;
    _multStr += digit.toString();
  }

  void _removeDigit() {
    if (_multStr.isEmpty) return;
    _multStr = _multStr.substring(0, _multStr.length - 1);
  }
  
  void _clearInput() {
    _multStr = '';
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final multiplier = int.tryParse(_multStr) ?? 1;
    final totalValue = _baseValue * multiplier;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.r),
        topRight: Radius.circular(32.r),
      ),
      child: Container(
        height: 0.6.sh, // Metade da tela
        decoration: const BoxDecoration(
          color: Colors.black, // Fundo preto
        ),
        child: Stack(
          children: [
            // 1. BACKGROUND IMAGE
            Positioned.fill(
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/images/fundo9.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. LOGO GIGANTE DE FUNDO
            Positioned(
              left: -80.w,
              top: -50.h,
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

            // 3. CAMADA DE VIDRO
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),

            // 4. CONTEÚDO
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
              child: Column(
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 36.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 4.h),

                  // Header
                  Column(
                    children: [
                      Text(
                        'Multiplicar valor',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Escolha um multiplicador',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),

                  // Display (Valor Final + Multiplicador)
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _formatCurrency(totalValue),
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'x$multiplier',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE45C00), // Laranja destaque
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Teclado
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildKeyRow(['1', '2', '3']), 
                        SizedBox(height: 6.h),
                        _buildKeyRow(['4', '5', '6']), 
                        SizedBox(height: 6.h),
                        _buildKeyRow(['7', '8', '9']), 
                        SizedBox(height: 6.h),
                        _buildKeyRow(['C', '0', 'backspace']),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Botões de Ação (Dois Botões)
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h), // Espaçamento extra inferior
                    child: Row(
                      children: [
                        // Botão CANCELAR (Vermelho)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 48.h, // Altura confortável
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: const Color(0xFFFF453A), // Vermelho iOS
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "CANCELAR",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFF453A), // Texto Vermelho
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 16.w),
                        
                        // Botão APLICAR (Verde)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_baseValue > 0) {
                                HapticFeedback.mediumImpact();
                                widget.controller.addMultipliedValue(_baseValue, multiplier);
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 48.h, // Altura confortável
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 4, 142, 25), // Verde iOS
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "APLICAR",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromARGB(255, 3, 146, 24), // Texto Verde
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildKey(keys[0]),
        SizedBox(width: 16.w),
        _buildKey(keys[1]),
        SizedBox(width: 16.w),
        _buildKey(keys[2]),
      ],
    );
  }

  Widget _buildKey(String key) {
    bool isBackspace = key == 'backspace';
    bool isClear = key == 'C';
    
    return Container(
      width: 54.w,
      height: 50.h,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onKeyPress(key),
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF68A07), Color(0xFFE45C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE45C00).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: isBackspace
                ? Icon(Icons.backspace_outlined, color: Colors.white, size: 20.sp)
                : Text(
                    key,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
