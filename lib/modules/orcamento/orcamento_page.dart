import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';

class OrcamentoPage extends StatefulWidget {
  const OrcamentoPage({super.key});

  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  // Valor em centavos (ex: 1000 = R$ 10,00)
  int _valueInCents = 0;

  // Formatador de moeda
  String get _formattedValue {
    final value = _valueInCents / 100;
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (key == 'backspace') {
        if (_valueInCents > 0) {
          _valueInCents = (_valueInCents / 10).floor();
        }
      } else if (key == 'confirm') {
        // Ação de confirmar
        _saveBudget();
      } else {
        if (_valueInCents.toString().length < 9) { // Limite de dígitos
          final digit = int.tryParse(key) ?? 0;
          _valueInCents = (_valueInCents * 10) + digit;
        }
      }
    });
  }

  void _saveBudget() {
    // TODO: Implementar salvamento do orçamento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orçamento definido: $_formattedValue'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 3,
      child: Column(
        children: [
          // Espaço do topo (Logo e Ilustração)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  
                  // Header / Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Placeholder para o ícone laranja do logo
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF68A07),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shopping_cart, color: Colors.white, size: 18.sp),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'CompreiSomei',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Ilustração (Moedas, Calculadora, Cesta)
                  // Usando um Container placeholder ou Ícone grande por enquanto
                  SizedBox(
                    height: 120.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                         // Fundo decorativo suave
                         Container(
                           width: 200.w,
                           height: 120.h,
                           decoration: BoxDecoration(
                             color: const Color(0xFFE8F5E9), // Verde bem claro
                             borderRadius: BorderRadius.circular(100),
                           ),
                         ),
                         Icon(Icons.shopping_basket_outlined, size: 80.sp, color: const Color(0xFFF68A07)),
                         Positioned(
                           right: 60.w,
                           bottom: 10.h,
                           child: Icon(Icons.calculate, size: 40.sp, color: Colors.blueGrey),
                         ),
                         Positioned(
                           left: 60.w,
                           top: 10.h,
                           child: Icon(Icons.monetization_on, size: 36.sp, color: Colors.amber),
                         ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Pergunta Principal
                  Text(
                    'Qual seu orçamento para compras?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C1C1E),
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Subtítulo
                  Text(
                    'Digite o valor do seu orçamento',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Campo de Valor
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formattedValue,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C1C1E),
                          ),
                        ),
                        Icon(Icons.edit, color: Colors.green[700], size: 20.sp),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Botão Definir Orçamento
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Container(
                      width: double.infinity,
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9F43), Color(0xFFF68A07)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF68A07).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saveBudget,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Definir Orçamento',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // Botão Cancelar
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _valueInCents = 0;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF2F2F7),
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Teclado Numérico
          Container(
            color: const Color(0xFFD1D5DB).withOpacity(0.3), // Fundo levemente cinza estilo iOS
            padding: EdgeInsets.only(
              top: 6.h,
              bottom: 100.h, // Espaço para BottomNav
            ),
            child: Column(
              children: [
                _buildKeypadRow(['1', '2', '3']),
                _buildKeypadRow(['4', '5', '6']),
                _buildKeypadRow(['7', '8', '9']),
                _buildKeypadRow(['plus', '0', 'confirm']), // 'plus' placeholder, 'confirm' check
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildKey(key)).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    if (key == 'plus') {
       // Tecla "+" ou vazia conforme imagem (imagem mostra "+")
       return _buildKeyButton(
         child: Text('+', style: TextStyle(fontSize: 24.sp, color: Colors.grey[600])),
         onTap: () {}, // Sem função clara na imagem de orçamento, talvez seja só decorativo ou placeholder
       );
    }
    
    if (key == 'confirm') {
      return _buildKeyButton(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(10.w),
          decoration: const BoxDecoration(
            color: Color(0xFFF68A07), // Cor do check
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white),
        ),
        onTap: () => _onKeyPressed('confirm'),
        isSpecial: true,
      );
    }

    // Lógica para backspace? Imagem não mostra backspace explícito no grid 1-9-0
    // Mas normalmente o botão ao lado do 0 é backspace ou confirmar.
    // Na imagem enviada:
    // 7 8 9
    // + 0 (check)
    // O check está à direita do 0. O + está à esquerda.
    // Onde estaria o backspace? Talvez o botão de editar no input field limpe?
    // Ou talvez eu deva colocar backspace no lugar do '+' se fizer mais sentido UX.
    // Vou manter '+' conforme imagem.
    
    return _buildKeyButton(
      child: Text(
        key,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      onTap: () => _onKeyPressed(key),
    );
  }

  Widget _buildKeyButton({
    required Widget child,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 100.w, // Largura fixa para alinhar colunas
          height: 46.h,
          alignment: Alignment.center,
          decoration: isSpecial ? null : BoxDecoration(
             color: Colors.white, // Teclas brancas estilo iOS
             borderRadius: BorderRadius.circular(5.r),
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.1),
                 offset: const Offset(0, 1),
                 blurRadius: 0,
               ),
             ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 4.w), // Espaçamento entre teclas
          child: child,
        ),
      ),
    );
  }
}
