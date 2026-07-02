import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';

class FilterSelector extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final Color cbg;
  final Color bdr;
  final Color mt;

  const FilterSelector({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.cbg,
    required this.bdr,
    required this.mt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: filters
                  .map(
                    (f) => GestureDetector(
                      onTap: () => onFilterSelected(f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: selectedFilter == f ? AppColors.primary : cbg,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFilter == f
                              ? null
                              : Border.all(color: bdr),
                        ),
                        child: Text(
                          f,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: selectedFilter == f ? Colors.white : mt,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
