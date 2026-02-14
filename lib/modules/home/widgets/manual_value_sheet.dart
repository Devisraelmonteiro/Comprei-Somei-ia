import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import para Haptics
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../home_controller.dart';

class ManualValueSheet extends StatefulWidget {
  final HomeController controller;

  const ManualValueSheet({super.key, required this.controller});

  @override
  State<ManualValueSheet> createState() => _ManualValueSheetState();
}

class _ManualValueSheetState extends State<ManualValueSheet> {
  String _currentValue = "0,00";
  
  double get _numericValue {
    String clean = _currentValue.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(clean) ?? 0.0;
  }

  void _onKeyPress(String key) {
    HapticFeedback.lightImpact(); // Feedback tátil premium
    setState(() {
      if (key == 'backspace') {
        _removeDigit();
      } else if (key == '00') {
        _addDoubleZero();
      } else {
        _addDigit(int.parse(key));
      }
    });
  }

  // Store as integer cents
  int _rawValue = 0;

  void _addDigit(int digit) {
    if (_rawValue.toString().length >= 9) return;
    setState(() {
      _rawValue = _rawValue * 10 + digit;
      _updateDisplay(_rawValue);
    });
  }

  void _addDoubleZero() {
    if (_rawValue.toString().length >= 8) return;
    setState(() {
      _rawValue = _rawValue * 100;
      _updateDisplay(_rawValue);
    });
  }

  void _removeDigit() {
    setState(() {
      _rawValue = (_rawValue / 10).floor();
      _updateDisplay(_rawValue);
    });
  }

  void _updateDisplay(int raw) {
    double val = raw / 100.0;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
    _currentValue = formatter.format(val).trim();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.r),
        topRight: Radius.circular(32.r),
      ),
      child: Container(
        height: 0.6.sh, // Metade da tela
        decoration: const BoxDecoration(
          color: Colors.black, // Fundo preto igual Login/Profile
        ),
        child: Stack(
          children: [
            // 1. BACKGROUND IMAGE (Igual Login)
            Positioned.fill(
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/images/fundo9.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. LOGO GIGANTE DE FUNDO (Igual Login)
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

            // 3. CAMADA DE VIDRO (Blur Original)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.1), // Tintura escura original
                ),
              ),
            ),

            // 4. CONTEÚDO (Calculadora)
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h), // Padding reduzido
              child: Column(
                children: [
                  // Handle bar (White for contrast)
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
                  
                  SizedBox(height: 4.h), // Reduzido de 8.h

                  // Header (Título e Subtítulo)
                  Column(
                    children: [
                      SizedBox(height: 16.h), // Espaço TOP solicitado
                      Text(
                        'Valor Manual',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Digite o valor do item',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h), // Reduzido de 12.h

                  // Display Limpo Centralizado
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _currentValue,
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20.h), // Margem fixa entre Display e Teclas
                  
                  // Teclado Limpo (Texto Branco)
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildKeyRow(['7', '8', '9']), 
                        SizedBox(height: 6.h), // Reduzido de 8.h
                        _buildKeyRow(['4', '5', '6']), 
                        SizedBox(height: 6.h), // Reduzido de 8.h
                        _buildKeyRow(['1', '2', '3']), 
                        SizedBox(height: 6.h), // Reduzido de 8.h
                        _buildKeyRow(['C', '0', 'backspace']),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h), // Espaço entre Teclas e Botão
                  
                  // Botão Principal de Ação (Outline Style)
          GestureDetector(
            onTap: () {
              final val = _numericValue;
              if (val > 0) {
                HapticFeedback.mediumImpact();
                widget.controller.addManualValue(val);
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 42.h, // Reduzido de 44.h
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                color: Colors.transparent, // Sem preenchimento
                borderRadius: BorderRadius.circular(21.r),
                border: Border.all(
                  color: Colors.white, // Borda Branca
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  "ADICIONAR",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Texto Branco
                    letterSpacing: 1.5,
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
      width: 54.w, // Reduzido de 60.w
      height: 50.h, // Reduzido de 60.h
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
             if (isClear) {
               HapticFeedback.lightImpact();
               setState(() {
                 _rawValue = 0;
                 _updateDisplay(_rawValue);
               });
             } else {
               _onKeyPress(key);
             }
          },
          borderRadius: BorderRadius.circular(14.r), // Arredondamento ajustado
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // Gradiente Laranja (Igual ícones do perfil)
              gradient: const LinearGradient(
                colors: [Color(0xFFF68A07), Color(0xFFE45C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE45C00).withOpacity(0.3),
                  blurRadius: 6, // Reduzido de 8
                  offset: const Offset(0, 3), // Reduzido de 4
                ),
              ],
            ),
            child: isBackspace
                ? Icon(Icons.backspace_outlined, color: Colors.white, size: 20.sp)
                : Text(
                    key,
                    style: TextStyle(
                      fontSize: 20.sp, // Reduzido de 24.sp
                      fontWeight: FontWeight.w600, // Bold para contrastar
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ... (rest of the file)

  
  // Métodos auxiliares removidos pois integrei diretamente (buildButton e buildCancelButton)
  // para simplificar o layout full-screen.
}
