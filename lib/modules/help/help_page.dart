import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/5511999999999');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0,
      showBottomNav: false,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/profile');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20.sp),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Text(
                'Ajuda',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: AppSizes.spacingMedium),
              Container(
                padding: EdgeInsets.all(AppSizes.cardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius * 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suporte via WhatsApp',
                      style: TextStyle(
                        fontSize: AppSizes.titleSmall,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingSmall),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: AppSizes.labelMedium,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingMedium),
                    SizedBox(
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () => _openWhatsApp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                        ),
                        child: Text(
                          'Chamar no WhatsApp',
                          style: TextStyle(
                            fontSize: AppSizes.titleSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Expanded(
                child: ListView(
                  children: const [
                    _FaqItem(
                      question: 'Como adicionar gastos?',
                      answer: 'No Controle de Gastos, digite o valor e toque em “Adicionar gasto”.',
                    ),
                    _FaqItem(
                      question: 'Como finalizar compra?',
                      answer: 'Depois de adicionar os valores, toque em “Finalizar compra” para registrar no histórico.',
                    ),
                    _FaqItem(
                      question: 'Como gerar receitas?',
                      answer: 'Na Lista de Compras, use o botão “Gerar Receitas”. Se a lista não estiver finalizada, finalize antes.',
                    ),
                    _FaqItem(
                      question: 'Como compartilhar a lista?',
                      answer: 'Na Lista de Compras, toque em “Compartilhar Lista” e siga as instruções.',
                    ),
                    _FaqItem(
                      question: 'Como usar o Churrascômetro?',
                      answer: 'Abra o Churrascômetro pelo Perfil, ajuste convidados e duração para ver quantidades sugeridas.',
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
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius * 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => expanded = !expanded),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(expanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey[600]),
                  ],
                ),
                if (expanded) ...[
                  SizedBox(height: 8.h),
                  Text(
                    widget.answer,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
