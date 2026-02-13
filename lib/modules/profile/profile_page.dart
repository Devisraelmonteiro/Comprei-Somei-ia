import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        //title: Text(
          //'Menu',
          //style: TextStyle(
           // color: const Color.fromARGB(255, 208, 204, 204),
            //fontWeight: FontWeight.bold,
            //fontSize: 18.sp,
          ),
        //),
        //centerTitle: true,
      //),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [
                  Color.fromARGB(255, 236, 113, 6),
                  Color.fromARGB(255, 236, 113, 6),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  
                  // Profile Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100.r,
                              height: 100.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: _profileImage != null
                                    ? DecorationImage(
                                        image: FileImage(_profileImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage('assets/images/user.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 3.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.edit, color: const Color(0xFFE45C00), size: 14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Olá, Visitante',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Bem-vindo de volta',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromARGB(255, 246, 187, 10).withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                  
                  // Menu Items
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      'OPÇÕES',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  _buildMenuItem(
                    icon: CupertinoIcons.home,
                    title: 'Editar Perfil',
                    subtitle: 'Atualize seu dados',
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildMenuItem(
                    icon: CupertinoIcons.question_circle,
                    title: 'Ajuda',
                    subtitle: 'Dúvidas e suporte',
                    onTap: () {
                      // Implement help navigation
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildMenuItem(
                    icon: Icons.exit_to_app,
                    title: 'Sair',
                    subtitle: 'Encerrar sessão',
                    onTap: () => context.go('/login'),
                    isDestructive: true,
                  ),

                  SizedBox(height: 40.h),

                  // Footer
                  Center(
                    child: Text(
                      'Versão 2.0.0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20.r),
              highlightColor: Colors.white.withOpacity(0.1),
              splashColor: Colors.white.withOpacity(0.2),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: isDestructive 
                            ? Colors.red.withOpacity(0.2) 
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        icon, 
                        color: isDestructive ? Colors.white : Colors.white, 
                        size: 24.sp
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDestructive ? const Color.fromARGB(255, 239, 40, 40) : Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: Colors.white.withOpacity(0.5),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
