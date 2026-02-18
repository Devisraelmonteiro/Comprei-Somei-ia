import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Variáveis de Estado
  String _display = "0";
  String _history = "";
  double? _firstOperand;
  double? _secondOperand; // Para repetição de operação com '='
  String? _operator;
  bool _shouldResetDisplay = false;
  
  // Constantes de Operadores
  static const String opAdd = "+";
  static const String opSub = "-";
  static const String opMul = "x";
  static const String opDiv = "/";

  // Formatação
  final NumberFormat _formatter = NumberFormat("#,##0.########", "pt_BR");

  // Helper para converter string formatada em double
  double _parseDisplay() {
    String cleanStr = _display.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleanStr) ?? 0.0;
  }

  // Helper para formatar double em string
  String _formatValue(double value) {
    if (value.isInfinite || value.isNaN) return "Erro";
    
    // Se for inteiro, remove decimais .0
    if (value % 1 == 0) {
      return NumberFormat("#,###", "pt_BR").format(value);
    }
    return _formatter.format(value);
  }

  void _onDigitPress(String digit) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_shouldResetDisplay) {
        _display = digit == "," ? "0," : digit;
        _shouldResetDisplay = false;
        _secondOperand = null; // Reseta operando repetido se começar novo número
      } else {
        if (_display == "0" && digit != ",") {
          _display = digit;
        } else {
          // Evita múltiplas vírgulas
          if (digit == "," && _display.contains(",")) return;
          
          // Limite de caracteres para evitar overflow visual
          if (_display.replaceAll('.', '').length >= 15) return;
          
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPress(String op) {
    HapticFeedback.mediumImpact();
    
    // Se o usuário troca de operador antes de digitar o segundo número
    if (_firstOperand != null && _shouldResetDisplay) {
      setState(() {
        _operator = op;
        _history = "${_formatValue(_firstOperand!)} $op";
      });
      return;
    }

    // Se já existe uma operação pendente, calcula o resultado parcial
    if (_firstOperand != null && _operator != null) {
      _calculateResult(isIntermediate: true);
    } else {
      // Primeira operação
      double currentValue = _parseDisplay();
      setState(() {
        _firstOperand = currentValue;
      });
    }

    setState(() {
      _operator = op;
      _history = "${_formatValue(_firstOperand!)} $op";
      _shouldResetDisplay = true;
      _secondOperand = null;
    });
  }

  void _calculateResult({bool isIntermediate = false}) {
    if (_firstOperand == null || _operator == null) return;

    // Se for operação intermediária, usa o display atual como segundo operando
    // Se for '=', usa _secondOperand se disponível (repetição), ou pega do display
    double secondOp = _secondOperand ?? _parseDisplay();
    
    // Armazena para repetição com '='
    if (!isIntermediate) {
        _secondOperand = secondOp;
    }

    double result = 0.0;

    switch (_operator) {
      case opAdd:
        result = _firstOperand! + secondOp;
        break;
      case opSub:
        result = _firstOperand! - secondOp;
        break;
      case opMul:
      case 'X': // Compatibilidade
        result = _firstOperand! * secondOp;
        break;
      case opDiv:
        if (secondOp != 0) {
          result = _firstOperand! / secondOp;
        } else {
          // Divisão por zero
          setState(() {
            _display = "Erro";
            _firstOperand = null;
            _operator = null;
            _history = "";
            _shouldResetDisplay = true;
          });
          return;
        }
        break;
    }

    setState(() {
      _display = _formatValue(result);
      
      if (isIntermediate) {
        _firstOperand = result;
        // O operador será atualizado pelo caller (_onOperatorPress)
      } else {
        // Finalizou com '='
        _firstOperand = result; // Permite continuar operando sobre o resultado
        _history = ""; 
        // _operator não é limpo para permitir repetição? 
        // Em calculadoras padrão, '=' limpa o operador pendente visualmente mas mantém estado lógico?
        // Vamos limpar visualmente, mas manter _firstOperand como base.
        _operator = null; 
      }
      _shouldResetDisplay = true;
    });
  }

  void _onEqualPress() {
    HapticFeedback.mediumImpact();
    // Se não tiver operador, não faz nada
    if (_operator == null) return;
    
    _calculateResult();
  }

  void _onClearPress() {
    HapticFeedback.lightImpact();
    setState(() {
      _display = "0";
      _history = "";
      _firstOperand = null;
      _secondOperand = null;
      _operator = null;
      _shouldResetDisplay = false;
    });
  }

  void _onBackspacePress() {
    HapticFeedback.lightImpact();
    if (_shouldResetDisplay) return; // Não apaga resultado calculado
    
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = "0";
      }
    });
  }

  void _onPercentPress() {
    HapticFeedback.lightImpact();
    double currentValue = _parseDisplay();
    double result = currentValue / 100;

    // Se tiver operação pendente (+ ou -), calcula porcentagem DO primeiro operando
    if (_firstOperand != null && (_operator == opAdd || _operator == opSub)) {
        result = _firstOperand! * result; // Ex: 100 + 10% -> 10% de 100 = 10
    }

    setState(() {
      _display = _formatValue(result);
      // Não reseta display para permitir que o usuário veja o valor calculado antes de operar
      // Mas se ele digitar número novo, deve substituir? 
      // Geralmente % finaliza a entrada do número atual.
      _shouldResetDisplay = true; 
    });
  }

  void _onSignChangePress() {
    HapticFeedback.lightImpact();
    double currentValue = _parseDisplay();
    double result = currentValue * -1;
    setState(() {
      _display = _formatValue(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
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
                color: Colors.black.withOpacity(0.3), 
              ),
            ),
          ),

          // 4. CONTEÚDO
          SafeArea(
            child: Column(
              children: [
                // Header with Back Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.06),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ),

                // Display Area
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_history.isNotEmpty)
                          Text(
                            _history,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        SizedBox(height: 8.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            _display,
                            style: TextStyle(
                              fontSize: 80.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Keypad Area
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    children: [
                      _buildRow(["AC", "backspace", "%", opDiv]),
                      SizedBox(height: 16.h),
                      _buildRow(["7", "8", "9", opMul]),
                      SizedBox(height: 16.h),
                      _buildRow(["4", "5", "6", opSub]),
                      SizedBox(height: 16.h),
                      _buildRow(["1", "2", "3", opAdd]),
                      SizedBox(height: 16.h),
                      _buildRow(["+/-", "0", ",", "="]),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons.map((btn) {
        return _buildButton(btn);
      }).toList(),
    );
  }

  Widget _buildButton(String text) {
    bool isOperator = [opDiv, opMul, opSub, opAdd, "="].contains(text);
    bool isAction = ["AC", "backspace", "%", "+/-"].contains(text);
    
    // Cores translúcidas para combinar com o fundo
    Color bgColor = isOperator 
        ? const Color(0xFFFF9F0A).withOpacity(0.9) 
        : isAction 
            ? Colors.grey.withOpacity(0.4)
            : Colors.white.withOpacity(0.15);
            
    Color textColor = Colors.white;

    Widget content;
    if (text == "backspace") {
      content = Icon(Icons.backspace_outlined, color: textColor, size: 28.sp);
    } else if (text == opMul) {
      content = Icon(Icons.close, color: textColor, size: 28.sp); // X icon
    } else if (text == opDiv) {
       // Ícone de divisão ou texto /
       content = Text("÷", style: TextStyle(fontSize: 32.sp, color: textColor));
    } else if (text == opAdd) {
       content = Icon(Icons.add, color: textColor, size: 32.sp);
    } else if (text == opSub) {
       content = Icon(Icons.remove, color: textColor, size: 32.sp);
    } else {
      content = Text(
        text,
        style: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      );
    }

    return Container(
      width: 75.w,
      height: 75.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            if (text == "AC") _onClearPress();
            else if (text == "backspace") _onBackspacePress();
            else if (text == "%") _onPercentPress();
            else if (text == "+/-") _onSignChangePress();
            else if (text == "=") _onEqualPress();
            else if ([opAdd, opSub, opMul, opDiv].contains(text)) _onOperatorPress(text);
            else _onDigitPress(text);
          },
          customBorder: const CircleBorder(),
          child: Center(
            child: content,
          ),
        ),
      ),
    );
  }
}
