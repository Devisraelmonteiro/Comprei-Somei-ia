import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';
import 'package:comprei_some_ia/shared/widgets/header_widget.dart';
import 'package:comprei_some_ia/shared/widgets/promo_banner_widget.dart';
import 'package:comprei_some_ia/shared/widgets/button_compreisomei.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';

// 👉 IMPORTANTE

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double mockBudget = 500.0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final remaining = mockBudget - controller.total;

   return BaseScaffold(
  currentIndex: 0,
  child: SafeArea(
    child: Stack(
      children: [

        /// ░░░ FUNDO DA TELA INTEIRA COM O LOGO ░░░
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fundo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        /// ░░░ CONTEÚDO NORMAL POR CIMA ░░░
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildTopBar(remaining),
              const SizedBox(height: 16),
              _buildScannerCard(context, controller),
              const SizedBox(height: 16),
              _buildQuickActionsRow(context, controller),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PromoBannerWidget(
                  onTap: () => print("Banner clicado!"),
                ),
              ),
              const SizedBox(height: 16),
              _buildItemsCard(controller),
              const SizedBox(height: 40),
            ],
          ),
        ),

        if (controller.loading)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    ),
  ),
);


  }

  Widget _buildTopBar(double remaining) {
    return HeaderWidget(
      userName: "Israel",
      remaining: remaining,
    );
  }

  // -------------------------------------------------------------------------
  // CARD SCANNER
  // -------------------------------------------------------------------------
  Widget _buildScannerCard(BuildContext context, HomeController controller) {
    final captured = controller.capturedValue;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.70,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 180,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: screenWidth * 0.35,
                  height: screenWidth * 0.35,
                  child: CustomPaint(
                    painter: _ScannerFramePainter(),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text(
                      "Capturado",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "R\$ ${captured.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showManualCaptureSheet(context, controller),
                      child: const Text(
                        "Definir valor manualmente",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // ROW DE AÇÕES
  // -------------------------------------------------------------------------
  Widget _buildQuickActionsRow(BuildContext context, HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ButtonCompreiSomei(
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  label: "Confirmar",
                  onTap: () => _onConfirm(context, controller),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ButtonCompreiSomei(
                  icon: Icons.close_rounded,
                  color: Colors.red,
                  label: "Cancelar",
                  onTap: () => _onCancel(context, controller),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ButtonCompreiSomei(
                  icon: Icons.close_fullscreen_rounded,
                  color: Colors.orange,
                  label: "Multiplicar",
                  onTap: () => _showMultiplySheet(context, controller),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ButtonCompreiSomei(
                  icon: Icons.edit_note_rounded,
                  color: Colors.blue,
                  label: "Manual",
                  onTap: () => _showManualCaptureSheet(context, controller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
// -------------------------------------------------------------------------
// LISTA DE ITENS CAPTURADOS
// -------------------------------------------------------------------------
Widget _buildItemsCard(HomeController controller) {
  final items = controller.items;
  final total = controller.total;

  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
     // HEADER
Container(
  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
  decoration: const BoxDecoration(
    border: Border(
      bottom: BorderSide(color: Color(0xFFF1F1F1), width: 1),
    ),
  ),
  child: const Text(
    "Itens Capturados",
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  ),
),


        // LISTA
        if (items.isEmpty)
          SizedBox(
            height: 100,
            child: Center(
              child: Text(
                "Nenhum item capturado ainda",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 400 + (index * 80)),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 10),
                    child: child,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF1F1F1), width: 0.8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Captura ${index + 1}",
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                      Text(
                        "R\$ ${item.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Color(0xFFF5A742),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => controller.deleteItem(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete, color: Colors.red, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // footer total
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              border: Border(
                top: BorderSide(color: Color(0xFFF1F1F1), width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total", style: TextStyle(color: Colors.grey)),
                    Text(
                      "R\$ ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFF5A742),
                      ),
                    ),
                  ],
                ),

                if (items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: controller.clearAll,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.red),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "Excluir todos os itens",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // AÇÕES
  // -------------------------------------------------------------------------

  void _onConfirm(BuildContext context, HomeController controller) async {
    if (controller.capturedValue <= 0) {
      _showSnack(context, "Defina um valor antes de confirmar.");
      return;
    }

    await controller.addCapturedValue();
    controller.setCapturedValue(0.0);

    _showSnack(context, "Valor adicionado na lista!");
  }

  void _onCancel(BuildContext context, HomeController controller) {
    controller.setCapturedValue(0.0);
    _showSnack(context, "Valor capturado foi limpo.");
  }

  void _showManualCaptureSheet(BuildContext context, HomeController controller) {
    final textController = TextEditingController(
      text: controller.capturedValue == 0
          ? ''
          : controller.capturedValue.toStringAsFixed(2),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Inserir valor manualmente",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: "Valor (em reais)",
                  prefixText: "R\$ ",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final raw = textController.text
                            .replaceAll("R\$", "")
                            .replaceAll(" ", "")
                            .replaceAll(",", ".");
                        final value = double.tryParse(raw);

                        if (value == null || value <= 0) {
                          _showSnack(context, "Digite um valor válido.");
                          return;
                        }

                        controller.setCapturedValue(value);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Aplicar"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showMultiplySheet(BuildContext context, HomeController controller) {
    if (controller.capturedValue <= 0) {
      _showSnack(context, "Defina um valor para multiplicar.");
      return;
    }

    final multiplierController = TextEditingController(text: "2");

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Multiplicar valor capturado",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: multiplierController,
                decoration: const InputDecoration(
                  labelText: "Multiplicador",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final m = int.tryParse(
                                multiplierController.text) ??
                            0;

                        if (m <= 0) {
                          _showSnack(context,
                              "Multiplicador inválido.");
                          return;
                        }

                        controller.setCapturedValue(
                            controller.capturedValue * m);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Aplicar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

// -----------------------------------------------------------------------------
// DESENHO DO QUADRO DO SCANNER
// -----------------------------------------------------------------------------
class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double corner = 18.0;

    final double w = size.width;
    final double h = size.height;

    canvas.drawLine(const Offset(0, 0), Offset(corner, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, corner), paint);

    canvas.drawLine(Offset(w, 0), Offset(w - corner, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, corner), paint);

    canvas.drawLine(Offset(0, h), Offset(0, h - corner), paint);
    canvas.drawLine(Offset(0, h), Offset(corner, h), paint);

    canvas.drawLine(Offset(w, h), Offset(w - corner, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - corner), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
