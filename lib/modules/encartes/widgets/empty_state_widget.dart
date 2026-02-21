import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAction;

  const EmptyStateWidget({
    super.key,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.newspaper_rounded,
              size: 60.sp,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Nenhum encarte ainda',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Adicione os encartes dos seus\nmercados favoritos para acessar rápido.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton.icon(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF36607),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            icon: Icon(Icons.add, size: 20.sp),
            label: Text(
              'Adicionar Encarte',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
