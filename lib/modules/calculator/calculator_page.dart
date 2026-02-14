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
  String _output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  bool _shouldClear = false;

  void _buttonPressed(String buttonText) {
    HapticFeedback.lightImpact();

    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        num1 = 0;
        num2 = 0;
        operand = "";
        _shouldClear = false;
      } else if (buttonText == "backspace") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else if (buttonText == "+/-") {
        if (_output != "0") {
          if (_output.startsWith("-")) {
            _output = _output.substring(1);
          } else {
            _output = "-$_output";
          }
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "/" ||
          buttonText == "X") {
        num1 = double.tryParse(_output.replaceAll(',', '.')) ?? 0;
        operand = buttonText;
        _shouldClear = true;
      } else if (buttonText == ",") {
        if (_shouldClear) {
          _output = "0,";
          _shouldClear = false;
        } else if (!_output.contains(",")) {
          _output = _output + buttonText;
        }
      } else if (buttonText == "=") {
        if (operand.isEmpty) return;
        
        num2 = double.tryParse(_output.replaceAll(',', '.')) ?? 0;
        double result = 0;

        if (operand == "+") {
          result = num1 + num2;
        } else if (operand == "-") {
          result = num1 - num2;
        } else if (operand == "X") {
          result = num1 * num2;
        } else if (operand == "/") {
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            _output = "Erro";
            return;
          }
        }

        _output = _formatNumber(result);
        operand = "";
        _shouldClear = true;
      } else if (buttonText == "%") {
        double val = double.tryParse(_output.replaceAll(',', '.')) ?? 0;
        _output = _formatNumber(val / 100);
      } else {
        // Numbers
        if (_shouldClear) {
          _output = buttonText;
          _shouldClear = false;
        } else {
          if (_output == "0") {
            _output = buttonText;
          } else {
            _output += buttonText;
          }
        }
      }
    });
  }

  String _formatNumber(double num) {
    // Remove .0 if integer
    if (num % 1 == 0) {
      return num.toInt().toString();
    }
    // Limit decimals and use comma
    return NumberFormat("#,##0.########", "pt_BR").format(num);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
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
                        color: const Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _output,
                    style: TextStyle(
                      fontSize: 80.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Keypad Area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  _buildRow(["backspace", "AC", "%", "/"]),
                  SizedBox(height: 16.h),
                  _buildRow(["7", "8", "9", "X"]),
                  SizedBox(height: 16.h),
                  _buildRow(["4", "5", "6", "-"]),
                  SizedBox(height: 16.h),
                  _buildRow(["1", "2", "3", "+"]),
                  SizedBox(height: 16.h),
                  _buildRow(["+/-", "0", ",", "="]),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
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
    bool isOperator = ["/", "X", "-", "+", "="].contains(text);
    // All other buttons are Dark Grey in the user's specific image
    
    Color bgColor = isOperator ? const Color(0xFFFF9F0A) : const Color(0xFF333333);
    Color textColor = Colors.white;

    Widget content;
    if (text == "backspace") {
      content = Icon(Icons.backspace_outlined, color: textColor, size: 28.sp);
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
      height: 75.w, // Circle
      child: Material(
        color: bgColor,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _buttonPressed(text),
          customBorder: const CircleBorder(),
          child: Center(
            child: content,
          ),
        ),
      ),
    );
  }
}
