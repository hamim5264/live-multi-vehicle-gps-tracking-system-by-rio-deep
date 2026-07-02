import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../models/vehicle.dart';

class VehicleTypeDropdown extends StatelessWidget {
  final String selectedType;
  final bool isOpen;
  final VoidCallback onTap;
  final Function(String) onSelected;
  final Color tx;
  final Color mt;
  final Color ibg;
  final Color card;
  final Color bdr;

  const VehicleTypeDropdown({
    super.key,
    required this.selectedType,
    required this.isOpen,
    required this.onTap,
    required this.onSelected,
    required this.tx,
    required this.mt,
    required this.ibg,
    required this.card,
    required this.bdr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: ibg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isOpen ? AppColors.primary : bdr,
                width: isOpen ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, color: mt, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedType,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14, color: tx),
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded, color: mt),
                ),
              ],
            ),
          ),
        ),
        if (isOpen) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bdr),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: VehicleType.values
                  .map((v) => v.displayName)
                  .toList()
                  .asMap()
                  .entries
                  .map((e) {
                    final sel = e.value == selectedType;
                    return GestureDetector(
                      onTap: () => onSelected(e.value),
                      child: Container(
                        decoration: BoxDecoration(
                          border: e.key < VehicleType.values.length - 1
                              ? Border(bottom: BorderSide(color: bdr))
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.value,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: sel
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: sel ? AppColors.primary : tx,
                                ),
                              ),
                            ),
                            if (sel)
                              const Icon(
                                Icons.check_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}
