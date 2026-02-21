import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
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
    FocusScope.of(context).unfocus();

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
    controller.clearAll();
    controller.setBudget(0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compra finalizada, saldo e itens capturados limpos'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final safeBottom = media.padding.bottom;
    final double bottomNavHeight = AppSizes.bottomNavHeight;
    // LEGENDAS DE CONFIGURAÇÃO (ajuste visual rápido da página):
    // - Banner topo:
    //   • Altura: Positioned(height: 280.h)
    //   • Fit da imagem: BoxFit.contain (troque para cover se quiser preencher)
    //   • Gradiente de legibilidade do voltar: opacidade em Colors.black.withOpacity(0.6)
    // - Cabeçalho (voltar + título):
    //   • Padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h)
    //   • Ícone voltar: size: 20.sp | fundo: .withOpacity(0.2)
    //   • Título: fontSize: 18.sp, weight bold, color branco
    // - Folha branca de conteúdo:
    //   • Top offset: Positioned.fill(top: 150.h)
    //   • Bottom offset: bottomNavHeight + safeBottom (não sobrepor footer)
    //   • Fundo: 0xFFF5F5F7 | Raio topo: 30.r
    // - Card “Adicionar gasto”:
    //   • Margem lateral: 20.w | Raio: 24.r | Sombra: blur 15
    //   • Campo valor: fonte 18.sp bold | hint “R$ 0,00”
    //   • Botões: altura 40.h, raio 28.r, gap 12.w
    //     · Primário (preenchido): gradient [0xFFFFA726, 0xFFFF7043]
    //     · Secundário (outlined): borda 0xFFFF7043
    // - Card “Relatórios”:
    //   • Raio: 24.r | padding interno: EdgeInsets.fromLTRB(20.r, 24.r, 20.r, 20.r)
    //   • Título: 15.sp | mês chip: 12.sp
    //   • Linha de resumo: despesa 14.sp vermelha (0xFFE57373), saldo 14.sp verde (0xFF4DB6AC) se >= 0
    // - Gráfico:
    //   • Altura: 90.h | Padding horizontal interno: 12.w
    //   • Linha: barWidth 3.5 | curva 0.35 | cor 0xFFFF8A3C
    //   • Pontos: raio 5, stroke 2.5, strokeColor 0xFFFF8A3C
    //   • Área inferior: gradient/top opacidades baixas
    //   • Rótulos bottom: reservedSize 46, tag valor com maxWidth ~68.w e ellipsis

    return BaseScaffold(
      currentIndex: 1,
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
              top: 150.h,
              bottom: bottomNavHeight + safeBottom,
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
                        child: _buildContentCard(
                          backgroundColor: const Color.fromARGB(10, 244, 132, 4),
                          padding: EdgeInsets.all(20.r),
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
                                'Adicione o valor e acompanhe seus gastos',
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
                                          fontSize: 18.sp,
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

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
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
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppStrings.btnAddExpense,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40.h,
                                      child: OutlinedButton(
                                        onPressed: _finishPurchase,
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xFFFF7043),
                                            width: 1.5,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(28.r),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppStrings.btnFinishPurchase,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFFFF7043),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 24.h),

                      // Card de Relatórios dentro do conteúdo (layout padrão)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _buildRecentPurchasesCard(),
                      ),

                      // Espaço extra para scroll quando teclado aparecer + footer
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 20.h,
                      ),
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

  Widget _buildContentCard({
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    double? borderRadius,
    List<BoxShadow>? boxShadow,
    required Widget child,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
      ),
      child: child,
    );
  }

  Widget _buildRecentPurchasesCard() {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        final purchases = controller.purchases.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        final recent = purchases.take(4).toList().reversed.toList();

        final totalDespesa = controller.total;
        final orcamento = controller.budget;
        final saldo = orcamento - totalDespesa;
        final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

        if (recent.isEmpty) {
          return _buildContentCard(
            padding: EdgeInsets.all(24.r),
            borderRadius: 20.r,
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

        return _buildContentCard(
          padding: EdgeInsets.fromLTRB(20.r, 24.r, 20.r, 20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(totalDespesa),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE57373),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'despesa',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatter.format(saldo),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: saldo < 0
                              ? const Color(0xFFE57373)
                              : const Color(0xFF4DB6AC),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'saldo',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SizedBox(
                  height: 90.h,
                  child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    minX: 0,
                    maxX: recent.length - 1.toDouble(),
                    minY: 0,
                    maxY: maxY,
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => Colors.black.withOpacity(0.85),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final idx = spot.x.round();
                            final date = recent[idx].date;
                            final dateLabel = DateFormat('dd/MM').format(date);
                            final valueLabel = formatter.format(spot.y);
                            return LineTooltipItem(
                              '$dateLabel\n$valueLabel',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
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
                          reservedSize: 46,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= recent.length) return const SizedBox.shrink();
                            if (recent.length > 5 && idx % 2 != 0) return const SizedBox.shrink();
                            
                            final purchase = recent[idx];
                            final dateLabel = DateFormat('dd/MM').format(purchase.date);
                            final valueLabel = formatter.format(purchase.total);
                            return SideTitleWidget(
                              meta: meta,
                              space: 12,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dateLabel,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 68.w),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2F2F7),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        valueLabel,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 14, 126, 4),
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                        color: const Color(0xFFFF8A3C), // Laranja mais vibrante
                        barWidth: 3.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: Colors.white,
                              strokeWidth: 2.5,
                              strokeColor: const Color(0xFFFF8A3C),
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFFFF8A3C).withOpacity(0.08),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFFF8A3C).withOpacity(0.35),
                              const Color(0xFFFF8A3C).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ],
          ),
        );
      },
    );
  }
}
