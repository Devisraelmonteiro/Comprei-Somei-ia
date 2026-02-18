import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:comprei_some_ia/shared/widgets/base_scaffold.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import '../controllers/churrascometro_controller.dart';

class ChurrascometroPage extends StatelessWidget {
  const ChurrascometroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 4,
      showBottomNav: false,
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/fundo9.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: -80.w,
            top: 120.h,
            width: 500.w,
            height: 500.h,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // 2. Header Content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                              color: Colors.black.withOpacity(0.06),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20.sp),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 16.r,
                            backgroundColor: Colors.white,
                            backgroundImage: const AssetImage('assets/images/logo.png'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [
                            Color(0xFFFFA726),
                            Color(0xFFFF6D00),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Text(
                        'Churrascômetro',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            top: 140.h,
            bottom: 0,
            child: Consumer<ChurrascometroController>(
              builder: (context, controller, _) {
                final model = controller.model;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('CONVIDADOS'),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteWithOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.55),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildCompactGuestCounter('Adultos', model.adultos, (v) => controller.updateAdultos(v), 'assets/images/homem.jpg', Colors.blue),
                            Container(height: 30.h, width: 1, color: Colors.grey[200]),
                            _buildCompactGuestCounter('Crianças', model.criancas, (v) => controller.updateCriancas(v), 'assets/images/crianca.jpg', const Color.fromARGB(255, 255, 102, 0)),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteWithOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.55),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.timer_outlined, color: Colors.orange, size: 16.sp),
                                    SizedBox(width: 8.w),
                                    Text('Duração', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text('${model.duracaoHoras}h', style: TextStyle(fontSize: 11.sp, color: Colors.orange, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.h),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.orange,
                                inactiveTrackColor: Colors.grey[200],
                                thumbColor: Colors.white,
                                trackHeight: 3.h,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r, elevation: 3),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                              ),
                              child: Slider(
                                value: model.duracaoHoras.toDouble(),
                                min: 2,
                                max: 12,
                                divisions: 10,
                                onChanged: (v) => controller.updateDuracao(v.round()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildSectionTitle('OPÇÕES EXTRAS'),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.whiteWithOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.55),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildToggleTile(context, 'Cerveja', model.bebidaAlcoolica, (v) => controller.toggleBebidaAlcoolica(v), 'assets/images/cerveja.jpg', Colors.amber),
                            _buildToggleTile(context, 'Pão Alho', model.paoDeAlho, (v) => controller.togglePaoDeAlho(v), 'assets/images/pao_de_alho.jpg', Colors.brown),
                            _buildToggleTile(context, 'Carvão', model.carvao, (v) => controller.toggleCarvao(v), 'assets/images/carvao.jpg', Colors.grey),
                            _buildToggleTile(context, 'Gelo', model.gelo, (v) => controller.toggleGelo(v), 'assets/images/gelo.jpg', Colors.cyan),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildSectionTitle('LISTA DE CHURRASCO'),
                      SizedBox(height: 8.h),
                      Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteWithOpacity(0.18),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.55),
                            width: 1.1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                          child: Column(
                            children: [
                              _buildResultItem(context, 'Carne', '${model.carneTotalKg.toStringAsFixed(1)}', 'Quilos', 'assets/images/carne.jpg', Colors.red, isFirst: true),
                              if (model.bebidaAlcoolica)
                                _buildResultItem(context, 'Cerveja', '${model.cervejaTotalLitros.toStringAsFixed(1)}', 'Litros', 'assets/images/cerveja.jpg', Colors.amber),
                              _buildResultItem(context, 'Bebidas', '${model.refrigeranteTotalLitros.toStringAsFixed(1)}', 'Litros', 'assets/images/bebidas.png', Colors.blue),
                              if (model.paoDeAlho)
                                _buildResultItem(context, 'Pão Alho', '${model.paoDeAlhoUnidades}', 'Pacotes', 'assets/images/pao_de_alho.jpg', Colors.brown),
                              if (model.carvao)
                                _buildResultItem(context, 'Carvão', '${model.carvaoSacos}', 'Sacos', 'assets/images/carvao.jpg', Colors.grey),
                              if (model.gelo)
                                _buildResultItem(context, 'Gelo', '${model.geloSacos}', 'Sacos', 'assets/images/gelo.jpg', Colors.cyan),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF8E8E93),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCompactGuestCounter(String label, int value, Function(int) onChanged, String imageAsset, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 8.w),
            Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[700], fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTinyStepper(Icons.remove, () => onChanged(value - 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text('$value', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
            _buildTinyStepper(Icons.add, () => onChanged(value + 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildTinyStepper(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 20.sp, color: Colors.black54),
      ),
    );
  }

  Widget _buildGuestCard(BuildContext context, String label, int value, Function(int) onChanged, String imageAsset, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32.w - 24.w) / 3,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppColors.whiteWithOpacity(0.18),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.55),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            padding: EdgeInsets.all(2.r), // Border width
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStepper(Icons.remove, () => onChanged(value - 1)),
              Text('$value', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              _buildSmallStepper(Icons.add, () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStepper(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 12.sp, color: Colors.black87),
      ),
    );
  }

  Widget _buildToggleTile(BuildContext context, String label, bool value, Function(bool) onChanged, String imageAsset, Color color) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value ? color : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imageAsset),
                      fit: BoxFit.cover,
                      colorFilter: value ? null : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    ),
                  ),
                ),
              ),
              if (value)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(Icons.check, size: 8.sp, color: Colors.white),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: value ? FontWeight.w600 : FontWeight.w500,
              color: value ? Colors.black87 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, String label, String value, String unit, String imageAsset, Color color, {bool isFirst = false}) {
    return Column(
      children: [
        if (!isFirst)
          Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 25.r,
                height: 25.r,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 16.sp, color: Colors.black),
      ),
    );
  }
}
