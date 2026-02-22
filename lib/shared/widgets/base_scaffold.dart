import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';

/// ✅ Centro (Lista) maior, circular e SEM cortar em cima
/// ✅ Outros ícones = CupertinoIcons (Apple) em iOS e Android
/// ✅ Churrascômetro no footer (último)
class BaseScaffold extends StatelessWidget {
  final Widget child;

  /// 0 Home | 1 Orçamento | 2 Lista (centro) | 3 Encartes | 4 Churrascômetro
  final int currentIndex;

  /// ✅ Volta pra compatibilidade com seu código (home_page.dart)
  final String? userName;

  final bool showBottomNav;

  const BaseScaffold({
    super.key,
    required this.child,
    this.currentIndex = 2,
    this.userName, // ✅ agora existe de novo
    this.showBottomNav = true,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/orcamento');
        break;
      case 2:
        context.go('/lista');
        break;
      case 3:
        context.go('/encartes');
        break;
      case 4:
        context.go('/churrascometro');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: showBottomNav ? _buildBottomNav(context) : null,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final isAndroid = Platform.isAndroid;

    final barHeight = AppSizes.bottomNavHeight;
    final baseIcon = AppSizes.bottomNavIconSize;
    final baseText = AppSizes.bottomNavTextSize;

    final sideIcon = (baseIcon * 1.15).clamp(baseIcon, baseIcon + 6.0);
    final sideText = baseText * 1.2;

    final centerIcon = (baseIcon * 1.25).clamp(baseIcon, baseIcon + 10.0);
    final centerDiameter = (baseIcon * 2.35).clamp(50.0, 66.0);
    final centerLift = (barHeight * 0.35).clamp(10.0, 18.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.bottomNavPaddingHorizontal,
        AppSizes.bottomNavPaddingTop,
        AppSizes.bottomNavPaddingHorizontal,
        bottomSafeArea + AppSizes.bottomNavPaddingBottom,
      ),
      child: SizedBox(
        height: barHeight + centerLift, // ✅ não corta o botão central
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.bottomNavRadius),
                child: isAndroid
                    ? _AndroidFooterBase(
                        height: barHeight,
                        currentIndex: currentIndex.clamp(0, 4),
                        onTap: (i) => _onItemTapped(context, i),
                        iconSize: sideIcon,
                        textSize: sideText,
                        centerGapWidth: centerDiameter,
                      )
                    : _IOSFooterBase(
                        height: barHeight,
                        currentIndex: currentIndex.clamp(0, 4),
                        onTap: (i) => _onItemTapped(context, i),
                        iconSize: sideIcon,
                        textSize: sideText,
                        centerGapWidth: centerDiameter,
                      ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: barHeight - (centerDiameter / 2) - centerLift,
              child: Center(
                child: _CenterFooterButton(
                  label: AppStrings.listTitle,
                  icon: CupertinoIcons.cart_fill, // Apple icon
                  diameter: centerDiameter,
                  iconSize: centerIcon,
                  isSelected: currentIndex == 2,
                  onTap: () => _onItemTapped(context, 2),
                  background: AppColors.primaryWithOpacity(0.85),
                  border: AppColors.whiteWithOpacity(0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IOSFooterBase extends StatelessWidget {
  final double height;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize;
  final double textSize;
  final double centerGapWidth;

  const _IOSFooterBase({
    required this.height,
    required this.currentIndex,
    required this.onTap,
    required this.iconSize,
    required this.textSize,
    required this.centerGapWidth,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.white;
    final unselectedColor = AppColors.whiteWithOpacity(0.7);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: AppColors.bottomNavGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackWithOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: _FooterRow(
          currentIndex: currentIndex,
          onTap: onTap,
          iconSize: iconSize,
          textSize: textSize,
          centerGapWidth: centerGapWidth,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
      ),
    );
  }
}

class _AndroidFooterBase extends StatelessWidget {
  final double height;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize;
  final double textSize;
  final double centerGapWidth;

  const _AndroidFooterBase({
    required this.height,
    required this.currentIndex,
    required this.onTap,
    required this.iconSize,
    required this.textSize,
    required this.centerGapWidth,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.white;
    final unselectedColor = Colors.white.withOpacity(0.7);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF36607),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _FooterRow(
        currentIndex: currentIndex,
        onTap: onTap,
        iconSize: iconSize,
        textSize: textSize,
        centerGapWidth: centerGapWidth,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
      ),
    );
  }
}

class _FooterRow extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize;
  final double textSize;
  final double centerGapWidth;
  final Color selectedColor;
  final Color unselectedColor;

  const _FooterRow({
    required this.currentIndex,
    required this.onTap,
    required this.iconSize,
    required this.textSize,
    required this.centerGapWidth,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem(0, 'Início', CupertinoIcons.house),
      _NavItem(1, 'Gasto', CupertinoIcons.money_dollar_circle),
      _NavItem(3, 'Encartes', CupertinoIcons.doc_text_search),
      _NavItem(4, 'Churrasco', CupertinoIcons.flame),
    ];

    return Row(
      children: [
        Expanded(
          child: _FooterItem(
            item: items[0],
            isSelected: currentIndex == items[0].index,
            iconSize: iconSize,
            textSize: textSize,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: onTap,
          ),
        ),
        Expanded(
          child: _FooterItem(
            item: items[1],
            isSelected: currentIndex == items[1].index,
            iconSize: iconSize,
            textSize: textSize,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: onTap,
          ),
        ),
        SizedBox(width: centerGapWidth),
        Expanded(
          child: _FooterItem(
            item: items[2],
            isSelected: currentIndex == items[2].index,
            iconSize: iconSize,
            textSize: textSize,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: onTap,
          ),
        ),
        Expanded(
          child: _FooterItem(
            item: items[3],
            isSelected: currentIndex == items[3].index,
            iconSize: iconSize,
            textSize: textSize,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final int index;
  final String label;
  final IconData icon;
  const _NavItem(this.index, this.label, this.icon);
}

class _FooterItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final double iconSize;
  final double textSize;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onTap;

  const _FooterItem({
    required this.item,
    required this.isSelected,
    required this.iconSize,
    required this.textSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkResponse(
        onTap: () => onTap(item.index),
        radius: 28,
        splashColor: Colors.white.withOpacity(0.12),
        highlightColor: Colors.white.withOpacity(0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: iconSize, color: color),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: textSize,
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterFooterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final double diameter;
  final double iconSize;
  final bool isSelected;
  final VoidCallback onTap;

  final Color background;
  final Color border;

  const _CenterFooterButton({
    required this.label,
    required this.icon,
    required this.diameter,
    required this.iconSize,
    required this.isSelected,
    required this.onTap,
    required this.background,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(diameter / 2),
          splashColor: Colors.white.withOpacity(0.18),
          highlightColor: Colors.white.withOpacity(0.08),
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: background,
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: iconSize, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
