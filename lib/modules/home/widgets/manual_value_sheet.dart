import 'package:flutter/material.dart';
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
    // Remove formatting characters (thousands separator dots) and replace decimal comma
    String clean = _currentValue.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(clean) ?? 0.0;
  }

  void _onKeyPress(String key) {
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
    if (_rawValue.toString().length >= 9) return; // Limit length
    setState(() {
      _rawValue = _rawValue * 10 + digit;
      _updateDisplay(_rawValue);
    });
  }

  void _addDoubleZero() {
    if (_rawValue.toString().length >= 8) return; // Ensure space for 2 zeros
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
    return Container(
      height: 0.85.sh, // Mais alto para dar ar de "Apple Design"
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 34.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D6), // iOS Handle color
                borderRadius: BorderRadius.circular(2.5.r),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          
          // Title
          Text(
            "Adicionar valor",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
          
          SizedBox(height: 10.h),
          
          // Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _currentValue,
                style: TextStyle(
                  fontSize: 72.sp, // Muito maior, estilo Calculadora iOS
                  fontWeight: FontWeight.w300, // Mais fino (Light)
                  color: const Color(0xFF000000),
                  letterSpacing: -2.0,
                ),
              ),
            ),
          ),
          
          Spacer(), // Empurra o teclado para baixo
          
          // Keypad
          SizedBox(
            width: 320.w, // Largura controlada para centralizar bem os botões
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildKeyRow(['1', '2', '3']),
                SizedBox(height: 20.h),
                _buildKeyRow(['4', '5', '6']),
                SizedBox(height: 20.h),
                _buildKeyRow(['7', '8', '9']),
                SizedBox(height: 20.h),
                _buildKeyRow(['00', '0', 'backspace']),
              ],
            ),
          ),
          
          Spacer(),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildCancelButton(context),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildApplyButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaçamento igual
      children: keys.map((key) {
        return _buildKey(key);
      }).toList(),
    );
  }

  Widget _buildKey(String key) {
    bool isBackspace = key == 'backspace';
    double size = 82.r; // Botões maiores estilo iOS

    return GestureDetector(
      onTap: () {
        // Feedback tátil leve estilo iOS
        // HapticFeedback.selectionClick(); // Requereria importar services
        _onKeyPress(key);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Sombra muito sutil
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isBackspace
              ? Icon(Icons.backspace_rounded, color: const Color(0xFFE45C00), size: 32.sp)
              : Text(
                  key,
                  style: TextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w400, // Regular weight
                    color: const Color(0xFF000000),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return GestureDetector(
      onTap: () {
        final val = _numericValue;
        if (val > 0) {
          widget.controller.addManualValue(val);
          Navigator.pop(context);
        }
      },
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF68A07), Color(0xFFE45C00)], // User's preferred gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE45C00).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Adicionar",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Text(
            "Cancelar",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 229, 18, 18),
            ),
          ),
        ),
      ),
    );
  }
}
