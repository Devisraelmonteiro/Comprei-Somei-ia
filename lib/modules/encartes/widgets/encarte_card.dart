import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../models/encarte_model.dart';
import '../controllers/encarte_controller.dart';
import 'add_encarte_modal.dart';

class EncarteCard extends StatelessWidget {
  final EncarteModel encarte;

  const EncarteCard({super.key, required this.encarte});

  Future<void> _launchUrl(BuildContext context) async {
    final Uri url = Uri.parse(encarte.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF007AFF)),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddEncarteModal(encarte: encarte),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Color(0xFFFF3B30)),
                title: const Text('Remover', style: TextStyle(color: Color(0xFFFF3B30))),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context);
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Encarte?'),
        content: Text('Deseja realmente remover o encarte de "${encarte.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<EncarteController>().removeEncarte(encarte.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF3B30)),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF007AFF), // Blue
      const Color(0xFF34C759), // Green
      const Color(0xFFE8833A), // Orange
      const Color(0xFFAC8E68), // Brown
      const Color(0xFFFF2D55), // Pink
      const Color(0xFF5856D6), // Purple
    ];
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(encarte.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: const Color(0xFFFF3B30),
        child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
      ),
      confirmDismiss: (direction) async {
        _confirmDelete(context);
        return false; // Don't dismiss automatically, let the dialog handle it
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: () => _launchUrl(context),
          onLongPress: () => _showOptions(context),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: _getAvatarColor(encarte.name),
                  child: Text(
                    _getInitials(encarte.name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        encarte.name,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        encarte.url,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Actions
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  icon: Icon(
                    encarte.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: encarte.isFavorite ? const Color(0xFFFFCC00) : Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    context.read<EncarteController>().toggleFavorite(encarte.id);
                  },
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade300,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
