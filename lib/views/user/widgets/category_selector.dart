import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isDark;
  final Color bdr;
  final Color mt;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.isDark,
    required this.bdr,
    required this.mt,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (ctx, sep) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = categories[i];
          final a = selectedCategory == c;
          return GestureDetector(
            onTap: () => onCategorySelected(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: a
                    ? AppColors.primary
                    : isDark
                    ? AppColors.white10
                    : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: a ? null : Border.all(color: bdr),
                boxShadow: a
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                c,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: a ? Colors.white : mt,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
