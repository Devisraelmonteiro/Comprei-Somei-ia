import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<double> priceList = [];
  double get total => priceList.fold(0, (sum, item) => sum + item);

  double? lastCaptured = 0.0;

  void addPrice(double value) {
    setState(() {
      priceList.add(value);
      lastCaptured = value;
    });
  }

  void clearPrices() {
    setState(() {
      priceList.clear();
      lastCaptured = 0.0;
    });
  }

  void multiplyLast() {
    if (lastCaptured == null || lastCaptured == 0) return;

    showDialog(
      context: context,
      builder: (ctx) {
        TextEditingController qty = TextEditingController();

        return AlertDialog(
          title: const Text("Multiplicar"),
          content: TextField(
            controller: qty,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Quantidade",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                final q = int.tryParse(qty.text) ?? 1;
                for (int i = 0; i < q; i++) {
                  addPrice(lastCaptured!);
                }
                Navigator.pop(ctx);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void addManual() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Adicionar manualmente"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Preço"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                final value = double.tryParse(
                  controller.text.replaceAll(",", "."),
                );
                if (value != null) {
                  addPrice(value);
                }
                Navigator.pop(ctx);
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TOPO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    Icon(Icons.menu, color: Colors.black54),
                  ],
                ),
              ),

              // SCANNER (só visual)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/camera_placeholder.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "Scanner aqui",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          const Text("Capturado", style: TextStyle(color: Colors.white)),
                          Text(
                            "R\$ ${lastCaptured?.toStringAsFixed(2) ?? "0.00"}",
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // BOTÕES iOS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: iosButton(
                        label: "Confirmar",
                        color: Colors.green,
                        onPressed: () => addPrice((lastCaptured ?? 0)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: iosButton(
                        label: "Cancelar",
                        color: Colors.red,
                        onPressed: clearPrices,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: iosButton(
                        label: "Multiplicar",
                        color: Colors.orange,
                        onPressed: multiplyLast,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: iosButton(
                        label: "Add Manual",
                        color: Colors.blue,
                        onPressed: addManual,
                      ),
                    ),
                  ],
                ),
              ),

              // SALDO
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.remove_red_eye, color: Colors.white),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Saldo Disponível", style: TextStyle(color: Colors.white70)),
                        Text(
                          "R\$ ${(total - 320.89).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              // LISTA
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Lista", style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 10),

                    if (priceList.isEmpty)
                      const Center(
                        child: Text("Nenhum item adicionado", style: TextStyle(color: Colors.grey)),
                      ),

                    for (int i = 0; i < priceList.length; i++)
                      ListTile(
                        title: Text("Item ${i + 1} - R\$ ${priceList[i].toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              priceList.removeAt(i);
                            });
                          },
                        ),
                      ),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "R\$ ${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    OutlinedButton(
                      onPressed: clearPrices,
                      child: const Text("Excluir todos", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // RODAPÉ
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF8B5E3C),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Encarte"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Gastos"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Compras"),
        ],
      ),
    );
  }

  // BOTÃO ESTILO iPHONE
  Widget iosButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
