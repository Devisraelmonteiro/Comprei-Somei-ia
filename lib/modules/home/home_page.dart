import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';
import 'package:comprei_some_ia/shared/widgets/header_widget.dart';
import 'package:comprei_some_ia/shared/widgets/promo_banner_widget.dart';
import 'package:comprei_some_ia/shared/widgets/button_compreisomei.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

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
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildTopBar(remaining),
              const SizedBox(height: 10),
              _buildScannerCard(context, controller),
              const SizedBox(height: 10),
              _buildQuickActionsRow(context, controller),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PromoBannerWidget(
                  onTap: () => print("Banner clicado!"),
                ),
              ),
              const SizedBox(height: 4),
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
                  width:  180,
                  height:  180,
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
// ROW DE AÇÕES  — com borda lateral configurável
// -------------------------------------------------------------------------
Widget _buildQuickActionsRow(
  BuildContext context,
  HomeController controller, {

  double sidePadding = 40, // 🔥 EDITÁVEL: controla a distância da borda
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: sidePadding),
    child: Column(
      children: [
        // ---------------- ROW 1 ----------------
        Row(
          children: [
            Expanded(
              child: ButtonCompreiSomei(
                icon: Iconsax.tick_circle,
                color: Colors.green,
                label: "Confirmar",
                onTap: () => _onConfirm(context, controller),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ButtonCompreiSomei(
                icon: Iconsax.close_circle,
                color: Colors.red,
                label: "Cancelar",
                onTap: () => _onCancel(context, controller),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ---------------- ROW 2 ----------------
        Row(
          children: [
            Expanded(
              child: ButtonCompreiSomei(
                icon: Iconsax.repeat,
                color: Colors.orange,
                label: "Multiplicador",
                onTap: () => _showMultiplySheet(context, controller),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ButtonCompreiSomei(
                icon: Iconsax.edit_2,
                color: Colors.blue,
                label: "Adiciona Manual",
                onTap: () => _showManualCaptureSheet(context, controller),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// LISTA DE ITENS CAPTURADOS (SEM LINHAS)
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

        // HEADER - sem linha
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: const Text(
            "Itens Capturados",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        // LISTA DE ITENS
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

                // ITEM SEM LINHA INFERIOR
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

                  child: Row(
                    children: [

                      // LIXEIRA
                      GestureDetector(
                        onTap: () => controller.deleteItem(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(28, 244, 67, 54).withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete, color: Colors.red, size: 14),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // DESCRIÇÃO
                      Expanded(
                        child: Text(
                          "Preço Capturado ${index + 1}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),

                      // PREÇO
                      Text(
                        "+R\$ ${item.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color.fromARGB(255, 3, 157, 44),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        // TOTAL + EXCLUIR TUDO (SEM LINHA)
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            children: [

              // TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(color: Colors.grey)),
                  Text(
                    "R\$ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 234, 98, 7),
                    ),
                  ),
                ],
              ),

              if (items.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: controller.clearAll,
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.red),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "Excluir tudo",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
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
// DESENHO DO QUADRO DO SCANNER (ATUALIZADO - PROPORCIONAL)
// -----------------------------------------------------------------------------
class _ScannerFramePainter extends CustomPainter {
  final double cornerLength;     // Tamanho dos cantos
  final double cornerThickness;  // Espessura das linhas
  final double paddingInside;    // Distância interna do canto
  final double offsetX;          // Deslocamento horizontal
  final double offsetY;          // Deslocamento vertical

  _ScannerFramePainter({
    this.cornerLength = 30,
    this.cornerThickness = 1,
    this.paddingInside = 20,
    this.offsetX = -30,
    this.offsetY = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = cornerThickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double L = cornerLength;
    final double P = paddingInside;

    // Move todo o scanner pelo canvas
    canvas.translate(offsetX, offsetY);

    final double w = size.width - offsetX * 2;
    final double h = size.height - offsetY * 2;

    // CANTO SUPERIOR ESQUERDO
    canvas.drawLine(Offset(P, P), Offset(P + L, P), paint);
    canvas.drawLine(Offset(P, P), Offset(P, P + L), paint);

    // CANTO SUPERIOR DIREITO
    canvas.drawLine(Offset(w - P, P), Offset(w - L - P, P), paint);
    canvas.drawLine(Offset(w - P, P), Offset(w - P, P + L), paint);

    // CANTO INFERIOR ESQUERDO
    canvas.drawLine(Offset(P, h - P), Offset(P + L, h - P), paint);
    canvas.drawLine(Offset(P, h - P), Offset(P, h - L - P), paint);

    // CANTO INFERIOR DIREITO
    canvas.drawLine(Offset(w - P, h - P), Offset(w - L - P, h - P), paint);
    canvas.drawLine(Offset(w - P, h - P), Offset(w - P, h - L - P), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
