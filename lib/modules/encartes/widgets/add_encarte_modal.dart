import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controllers/encarte_controller.dart';
import '../models/encarte_model.dart';

class AddEncarteModal extends StatefulWidget {
  final EncarteModel? encarte;

  const AddEncarteModal({super.key, this.encarte});

  @override
  State<AddEncarteModal> createState() => _AddEncarteModalState();
}

class _AddEncarteModalState extends State<AddEncarteModal> {
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.encarte?.name ?? '');
    _urlController = TextEditingController(text: widget.encarte?.url ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<EncarteController>();
      
      if (widget.encarte != null) {
        // Editar
        final updatedEncarte = widget.encarte!.copyWith(
          name: _nameController.text.trim(),
          url: _urlController.text.trim(),
        );
        controller.updateEncarte(updatedEncarte);
      } else {
        // Adicionar
        controller.addEncarte(
          _nameController.text.trim(),
          _urlController.text.trim(),
        );
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.encarte != null ? 'Editar Encarte' : 'Novo Encarte',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            
            // Campo Nome
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Mercado',
                hintText: 'Ex: Supermercado Preço Bom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF007AFF)),
                ),
                prefixIcon: const Icon(Icons.store_mall_directory_rounded),
                filled: true,
                fillColor: const Color(0xFFF5F5F7),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, digite o nome do mercado';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            
            // Campo URL
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Link do Encarte',
                hintText: 'Cole o link aqui',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF007AFF)),
                ),
                prefixIcon: const Icon(Icons.link_rounded),
                filled: true,
                fillColor: const Color(0xFFF5F5F7),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, cole o link do encarte';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            
            // Botão Salvar
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.encarte != null ? 'Salvar Alterações' : 'Adicionar Encarte',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
