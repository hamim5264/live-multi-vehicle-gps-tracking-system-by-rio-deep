import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/vehicle.dart';
import '../widgets/vehicle_details_sheet.dart';
import '../../viewmodels/user_viewmodel.dart';
import 'widgets/vehicle_search_bar.dart';
import 'widgets/filter_selector.dart';
import 'widgets/vehicle_list_card.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Vehicle> _filterVehicles(List<Vehicle> vehicles) {
    return vehicles.where((v) {
      if (_selectedFilter == 'Online' && v.status != VehicleStatus.online) {
        return false;
      }
      if (_selectedFilter == 'Idle' && v.status != VehicleStatus.idle) {
        return false;
      }
      if (_selectedFilter == 'Offline' && v.status != VehicleStatus.offline) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dk = Theme.of(context).brightness == Brightness.dark;
    final bg = dk ? AppColors.darkBg : AppColors.lightBg;
    final card = dk ? AppColors.darkCard : AppColors.lightCard;
    final bdr = dk ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final tx = dk ? Colors.white : const Color(0xFF0F172A);
    final mt = dk ? AppColors.white50 : const Color(0xFF64748B);
    final cbg = dk ? AppColors.white10 : AppColors.lightCard;

    final userVm = context.watch<UserViewModel>();
    final baseList = userVm.vehicles;
    final displayList = _filterVehicles(baseList);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: tx, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Vehicles',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: tx,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Vehicles',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: tx,
                    ),
                  ),
                  const SizedBox(height: 14),
                  VehicleSearchBar(
                    controller: _searchController,
                    onChanged: (val) => userVm.updateSearchQuery(val),
                    card: card,
                    bdr: bdr,
                    tx: tx,
                    mt: mt,
                  ),
                  const SizedBox(height: 12),
                  FilterSelector(
                    filters: const ['All', 'Online', 'Idle', 'Offline'],
                    selectedFilter: _selectedFilter,
                    onFilterSelected: (f) =>
                        setState(() => _selectedFilter = f),
                    cbg: cbg,
                    bdr: bdr,
                    mt: mt,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  userVm.refresh();
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: displayList.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Text(
                              'No vehicles found',
                              style: GoogleFonts.plusJakartaSans(color: mt),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: displayList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          final v = displayList[i];
                          return VehicleListCard(
                            vehicle: v,
                            card: card,
                            bdr: bdr,
                            tx: tx,
                            mt: mt,
                            onTap: () => VehicleDetailsSheet.show(context, v),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
