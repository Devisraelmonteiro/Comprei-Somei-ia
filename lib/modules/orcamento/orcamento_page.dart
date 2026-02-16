import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:comprei_some_ia/modules/home/home_controller.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';
import 'dart:math';

class OrcamentoPage extends StatefulWidget {
  const OrcamentoPage({super.key});

  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  final TextEditingController _moneyController = TextEditingController(text: 'R\$ 0,00');
  final TextEditingController _orcamentoController = TextEditingController(text: 'R\$ 0,00');
  final FocusNode _budgetFocus = FocusNode();
  final FocusNode _orcamentoFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _moneyController.addListener(() => _onTextChanged(_moneyController));
    _orcamentoController.addListener(() => _onTextChanged(_orcamentoController));
  }

  @override
  void dispose() {
    _moneyController.dispose();
    _orcamentoController.dispose();
    _budgetFocus.dispose();
    _orcamentoFocus.dispose();
    super.dispose();
  }

  void _onTextChanged(TextEditingController controller) {
    // Remove tudo que não é dígito
    String text = controller.text;
    String digits = text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.isEmpty) digits = '0';
    int value = int.parse(digits);
    
    final double doubleValue = value / 100;
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    String newText = 'R\$ ${formatter.format(doubleValue)}';
    
    if (controller.text != newText) {
        controller.value = controller.value.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
        );
    }
  }

  void _saveBudget() {
    double value = 0.0;
    try {
      final cleanValue = _orcamentoController.text
          .replaceAll(RegExp(r'[^\d,]'), '')
          .replaceAll(',', '.');
      value = double.tryParse(cleanValue) ?? 0.0;
    } catch (_) {}

    context.read<HomeController>().setBudget(value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orçamento definido: ${_orcamentoController.text}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addExpense() {
    double value = 0.0;
    try {
      final cleanValue = _moneyController.text
          .replaceAll(RegExp(r'[^\d,]'), '')
          .replaceAll(',', '.');
      value = double.tryParse(cleanValue) ?? 0.0;
    } catch (_) {}

    context.read<HomeController>().setBudget(value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saldo da compra definido: ${_moneyController.text}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _finishPurchase() {
    final controller = context.read<HomeController>();
    if (controller.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum item capturado para finalizar'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    controller.addFinishedPurchase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compra finalizada e adicionada ao gráfico'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 3,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // 1. Imagem de Fundo (Banner) - Fixo no topo
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 280.h, // Altura maior para cobrir bem
              child: Stack(
                children: [
                  Container(color: Colors.black), // Fundo escuro para destacar a imagem
                  Image.asset(
                    'assets/images/gastos.png',
                    fit: BoxFit.contain, // Sem zoom (mostra a imagem inteira)
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                  ),
                  // Gradiente leve para garantir legibilidade do botão voltar
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 2. Botão Voltar e Título (Sobre a imagem)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/home');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            backgroundImage: const AssetImage('assets/images/logo.png'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // CONTROLE DE POSIÇÃO DO TÍTULO "Controle de Gastos"
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.w,  // Edite aqui: Esquerda
                          top: 0.h,   // Edite aqui: Cima
                          right: 0.w, // Edite aqui: Direita
                          bottom: 0.h // Edite aqui: Baixo
                        ),
                        child: Text(
                          'Controle de Gastos', // Título em 2 linhas
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 3. Conteúdo em "Folha Branca" (Bottom Sheet look)
            Positioned.fill(
              top: 150.h, // Ajustado para subir mais (era 180.h)
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7), // Fundo levemente cinza do app
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30.h, bottom: 40.h),
                  child: Column(
                    children: [
                      // Card "Adicionar gasto"
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(10, 244, 132, 4),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Adicionar gasto',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6.r),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit, size: 16.sp, color: const Color.fromARGB(255, 189, 189, 189)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Adicione o valor gasto em suas compras\ne acompanhe seus gastos',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey[500],
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              
                              // Input Field Grande
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _moneyController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        focusNode: _budgetFocus,
                                        onTap: () => _budgetFocus.requestFocus(),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'R\$ 0,00',
                                          hintStyle: TextStyle(color: Colors.grey[400]),
                                          contentPadding: EdgeInsets.zero,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                   // Container(
                                     // padding: EdgeInsets.all(8.r),
                                      //decoration: const BoxDecoration(
                                        //color: Color(0xFFE8F5E9),
                                        //shape: BoxShape.circle,
                                      //),
                                      //child: Icon(
                                        //Icons.edit,
                                        //color: const Color.fromARGB(255, 76, 175, 79),
                                        //size: 8.sp,
                                      //),
                                   // ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 24.h),
                              
                              // Botão Laranja
                              Container(
                                width: double.infinity,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(28.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF7043).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _addExpense,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Adicionar ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                width: double.infinity,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(28.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF7043).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _finishPurchase,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Finalizar compra',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                      // Card de Relatórios
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _buildRecentPurchasesCard(),
                      ),
                      // Espaço extra para scroll quando teclado aparecer
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPurchasesCard() {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final purchases = controller.purchases.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        final recent = purchases.take(7).toList().reversed.toList();

        final totalDespesa = controller.total;
        final orcamento = controller.budget;
        final saldo = orcamento - totalDespesa;
        final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

        if (recent.isEmpty) {
          return Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.bar_chart_rounded, color: Colors.grey[300], size: 40.sp),
                  SizedBox(height: 8.h),
                  Text(
                    'Sem dados recentes',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final values = recent.map((e) => e.total).toList();
        final maxY = (values.isEmpty ? 100.0 : values.reduce((a, b) => a > b ? a : b)) * 1.25;

        return Container(
          padding: EdgeInsets.fromLTRB(20.r, 24.r, 20.r, 20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r), // Bordas mais arredondadas como na imagem
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CONTROLE DE POSIÇÃO DO TÍTULO "Relatórios"
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0.w,  // Edite aqui: Esquerda
                      top: 0.h,   // Edite aqui: Cima
                      right: 0.w, // Edite aqui: Direita
                      bottom: 0.h // Edite aqui: Baixo
                    ),
                    child: Text(
                      'Relatórios',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'JAN', // Placeholder para mês atual
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32.h),
              
              // Gráfico
              SizedBox(
                height: 50.h,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[200],
                          strokeWidth: 1,
                          dashArray: [5, 5], // Linha tracejada
                        );
                      },
                    ),
                    minX: 0,
                    maxX: recent.length - 1.toDouble(),
                    minY: 0,
                    maxY: maxY,
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => Colors.black.withOpacity(0.8),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              formatter.format(spot.y),
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= recent.length) return const SizedBox.shrink();
                            if (recent.length > 5 && idx % 2 != 0) return const SizedBox.shrink();
                            
                            final date = recent[idx].date;
                            final label = DateFormat('dd/MM').format(date);
                            return SideTitleWidget(
                              meta: meta,
                              space: 12,
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      // Linha de Despesas (Colorida)
                      LineChartBarData(
                        spots: recent.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.total);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: const Color(0xFFFF7043), // Laranja/Vermelho suave
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: const Color(0xFFFF7043),
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFFFF7043).withOpacity(0.1),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFFF7043).withOpacity(0.2),
                              const Color(0xFFFF7043).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24.h),
              Divider(height: 1, color: Colors.grey[100]),
              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        formatter.format(totalDespesa),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE57373),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'despesa',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40.h,
                    width: 1,
                    color: Colors.grey[200],
                  ),
                  Column(
                    children: [
                      Text(
                        formatter.format(saldo),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: saldo < 0
                              ? const Color(0xFFE57373)
                              : const Color(0xFF4DB6AC),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'saldo',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
