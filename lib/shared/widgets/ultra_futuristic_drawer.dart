import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UltraFuturisticDrawer extends StatefulWidget {
  const UltraFuturisticDrawer({super.key});

  @override
  State<UltraFuturisticDrawer> createState() => _UltraFuturisticDrawerState();
}

class _UltraFuturisticDrawerState extends State<UltraFuturisticDrawer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _controller.forward();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    if (path != null) {
      setState(() {
        _profileImage = File(path);
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', image.path);
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  void _showImageOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Avatar Futurístico'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text('Capturar Imagem'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Carregar da Base de Dados'),
          ),
          if (_profileImage != null)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('profile_image_path');
                setState(() {
                  _profileImage = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Desmaterializar Avatar'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: 340.w,
      child: Stack(
        children: [
          // Background Glow & Blur
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A1F).withOpacity(0.85),
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -100,
                        right: -100,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orange.withOpacity(0.2 * _pulseController.value),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                // Profile Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showImageOptions,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.5 * _pulseController.value),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: child,
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 70.r,
                                height: 70.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.orange, width: 2),
                                  image: _profileImage != null
                                      ? DecorationImage(
                                          image: FileImage(_profileImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage('assets/images/logo.png'),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.6),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    CupertinoIcons.camera_fill,
                                    color: Colors.white,
                                    size: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Colors.orangeAccent],
                            ).createShader(bounds),
                            child: Text(
                              'CYBER USER',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Text(
                              'LEVEL 10',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50.h),
                
                // Menu Items
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        _buildFuturisticItem(
                          icon: CupertinoIcons.home,
                          title: 'HOME',
                          subtitle: 'Painel Principal',
                          gradient: [const Color(0xFF00C6FF), const Color(0xFF0072FF)],
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/home');
                          },
                          delay: 0,
                        ),
                        _buildFuturisticItem(
                          icon: CupertinoIcons.list_bullet,
                          title: 'LISTAS',
                          subtitle: 'Gerenciamento',
                          gradient: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/lista');
                          },
                          delay: 100,
                        ),
                        _buildFuturisticItem(
                          icon: CupertinoIcons.tag_fill,
                          title: 'ENCARTES',
                          subtitle: 'Ofertas Digitais',
                          gradient: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/encartes');
                          },
                          delay: 200,
                        ),
                        _buildFuturisticItem(
                          icon: CupertinoIcons.money_dollar_circle,
                          title: 'FINANÇAS',
                          subtitle: 'Controle Total',
                          gradient: [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/orcamento');
                          },
                          delay: 300,
                        ),
                        _buildFuturisticItem(
                          icon: CupertinoIcons.flame_fill,
                          title: 'CHURRASCO',
                          subtitle: 'Calculadora Pro',
                          gradient: [const Color(0xFFFA709A), const Color(0xFFFEE140)],
                          onTap: () {
                            Navigator.pop(context);
                            context.go('/churrascometro');
                          },
                          delay: 400,
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      Icon(Icons.power_settings_new, color: Colors.white38, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'SYSTEM V1.0',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white38,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturisticItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutExpo,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: gradient.first.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(icon, color: Colors.white, size: 24.sp),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.white12,
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
