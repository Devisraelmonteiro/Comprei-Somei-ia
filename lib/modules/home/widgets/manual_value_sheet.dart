import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home_controller.dart';

class ManualValueSheet extends StatefulWidget {
  final HomeController controller;

  const ManualValueSheet({super.key, required this.controller});

  @override
  State<ManualValueSheet> createState() => _ManualValueSheetState();
}

class _ManualValueSheetState extends State<ManualValueSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _valueController;
  late final FocusNode _nameFocus;
  late final FocusNode _qtyFocus;
  late final FocusNode _valueFocus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _qtyController = TextEditingController();
    _valueController = TextEditingController();
    _nameFocus = FocusNode();
    _qtyFocus = FocusNode();
    _valueFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_nameFocus);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _valueController.dispose();
    _nameFocus.dispose();
    _qtyFocus.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  double _parseMoney(String input) {
    String s = input.replaceAll(RegExp(r'[^\d,\.]'), '');
    if (s.contains(',')) {
      s = s.replaceAll('.', '');
      s = s.replaceAll(',', '.');
    }
    return double.tryParse(s) ?? 0.0;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final qty = int.parse(_qtyController.text);
    final value = _parseMoney(_valueController.text);
    if (value <= 0 || qty <= 0) return;
    HapticFeedback.mediumImpact();
    widget.controller.addManualValue(value, customName: name, multiplier: qty);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.r),
        topRight: Radius.circular(32.r),
      ),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 8.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                
                SizedBox(height: 8.h),
                Column(
                  children: [
                    SizedBox(height: 8.h),
                    Text(
                      'Valor Manual',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Nome do produto',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Ex: Arroz 5kg',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.shopping_cart_outlined),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Digite o nome do produto';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _qtyController,
                              focusNode: _qtyFocus,
                              decoration: InputDecoration(
                                labelText: 'Quantidade',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: '1',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.numbers),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Informe a quantidade';
                                final n = int.tryParse(v);
                                if (n == null || n <= 0) return 'Quantidade inválida';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextFormField(
                              controller: _valueController,
                              focusNode: _valueFocus,
                              decoration: InputDecoration(
                                labelText: 'Valor (R\$)',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: '0,00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.attach_money),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.\s]')),
                              ],
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Informe o valor';
                                final val = _parseMoney(v);
                                if (val <= 0) return 'Valor inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF36607),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Adicionar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
