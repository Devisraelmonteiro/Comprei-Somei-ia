import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:comprei_some_ia/shared/constants/app_sizes.dart';
import 'package:comprei_some_ia/shared/constants/app_colors.dart';
import 'package:comprei_some_ia/shared/constants/app_strings.dart';

class PromoBannerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PromoBannerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0B6B53),
                Color(0xFF094C3D),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                // 💸 Fundo animado
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.30,
                    child: Lottie.asset(
                      'assets/lottie/dolarcompreisomei.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                ),

                // 🔥 Conteúdo
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding.w),
                  child: Row(
                    children: [
                      // Textos à esquerda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "CompreiSomei no dia a dia",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              AppStrings.appTagline,
                              style: TextStyle(
                                color: AppColors.whiteWithOpacity(0.7),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ➡ Seta
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteWithOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.white,
                          size: 14.sp,
                        ),
                      )
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