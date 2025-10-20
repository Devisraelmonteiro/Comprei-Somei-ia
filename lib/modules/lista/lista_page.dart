import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final List<String> categorias = ['Alimentos', 'Limpeza', 'Higiene'];
  String categoriaSelecionada = 'Alimentos';

  List<_ItemLista> items = [
    _ItemLista(nome: 'arroz', quantidade: 2),
    _ItemLista(nome: 'feijão', quantidade: 2),
    _ItemLista(nome: 'macarrão', quantidade: 2),
    _ItemLista(nome: 'fubá', quantidade: 2),
    _ItemLista(nome: 'farinha de trigo', quantidade: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 2, // use o índice real da aba “Lista”
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildCategoriaChips(),
          const SizedBox(height: 12),
          _buildAddButton(),
          const SizedBox(height: 12),
          Expanded(child: _buildItemList()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            'Sua Lista de Compras',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categorias.map((cat) {
          final selected = cat == categoriaSelecionada;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: selected,
              onSelected: (sel) {
                setState(() {
                  categoriaSelecionada = cat;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              side: BorderSide(color: selected ? AppColors.primary : Colors.grey),
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.black,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // ação de adicionar produto
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          elevation: 2,
        ),
        child: const Text(
          'Adicionar Produto',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) => _buildItemCard(items[index], index),
    );
  }

  Widget _buildItemCard(_ItemLista item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(0,1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            item.nome,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            'Qtd: ${item.quantidade}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // editar
            },
            icon: const Icon(Icons.edit, color: Colors.orange),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class _ItemLista {
  final String nome;
  final int quantidade;
  _ItemLista({required this.nome, this.quantidade = 1});
}
