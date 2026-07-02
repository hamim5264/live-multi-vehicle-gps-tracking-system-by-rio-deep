import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../models/vehicle.dart';
import '../../viewmodels/driver_viewmodel.dart';
import 'widgets/vehicle_form_header.dart';
import 'widgets/vehicle_form_label.dart';
import 'widgets/vehicle_image_picker.dart';
import 'widgets/vehicle_number_field.dart';
import 'widgets/vehicle_save_button.dart';
import 'widgets/vehicle_type_dropdown.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final VoidCallback? goToDashboard;

  const AddEditVehicleScreen({super.key, this.goToDashboard});

  @override
  State<AddEditVehicleScreen> createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _fk = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  String _type = 'Car';
  bool _dropdownOpen = false;
  String? _photoBase64;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    final v = context.read<DriverViewModel>().currentVehicle;
    if (v != null) {
      _nameController.text = v.name;
      _numberController.text = v.number;
      _type = v.type.displayName;
      _photoBase64 = v.photoBase64;
      _isPopulated = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        final tx = Theme.of(ctx).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF0F172A);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Image Source',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tx,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.plusJakartaSans(color: tx),
                  ),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.plusJakartaSans(color: tx),
                  ),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      try {
        final file = await picker.pickImage(
          source: source,
          maxWidth: 320,
          maxHeight: 240,
          imageQuality: 70,
        );
        if (file != null) {
          final bytes = await file.readAsBytes();
          final img = await decodeImageFromList(bytes);
          if (img.width < img.height) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Please add or pick a landscape image.',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return;
          }
          setState(() => _photoBase64 = base64Encode(bytes));
        }
      } catch (e) {
        debugPrint('Image picking error: $e');
      }
    }
  }

  Future<void> _saveVehicle() async {
    if (!_fk.currentState!.validate()) return;
    final driverVm = context.read<DriverViewModel>();
    final hasVehicle = driverVm.currentVehicle != null;
    await driverVm.registerOrUpdateVehicle(
      name: _nameController.text.trim(),
      number: _numberController.text.trim(),
      type: VehicleType.fromString(_type),
      photoBase64: _photoBase64,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasVehicle
                ? 'Vehicle updated successfully!'
                : 'Vehicle saved successfully!',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      widget.goToDashboard?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dk = Theme.of(context).brightness == Brightness.dark;
    final bg = dk ? AppColors.darkBg : AppColors.lightBg;
    final card = dk ? AppColors.darkCard : AppColors.lightCard;
    final bdr = dk ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final tx = dk ? Colors.white : const Color(0xFF0F172A);
    final mt = dk ? AppColors.white50 : const Color(0xFF64748B);
    final ibg = dk ? AppColors.white10 : const Color(0xFFF1F5F9);

    final vehicle = context.watch<DriverViewModel>().currentVehicle;

    if (vehicle != null && !_isPopulated) {
      _nameController.text = vehicle.name;
      _numberController.text = vehicle.number;
      _type = vehicle.type.displayName;
      _photoBase64 = vehicle.photoBase64;
      _isPopulated = true;
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            VehicleFormHeader(
              onBack: widget.goToDashboard,
              card: card,
              bdr: bdr,
              tx: tx,
              mt: mt,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _fk,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VehicleImagePicker(
                        photoBase64: _photoBase64,
                        onTap: _pickImage,
                        tx: tx,
                        mt: mt,
                        ibg: ibg,
                      ),
                      const SizedBox(height: 20),
                      VehicleFormLabel(text: 'Vehicle Name', color: tx),
                      TextFormField(
                        controller: _nameController,
                        style: GoogleFonts.plusJakartaSans(color: tx),
                        decoration: vehicleFieldDecoration(
                          hint: 'e.g. Toyota Hilux',
                          icon: Icons.local_shipping_outlined,
                          fillColor: ibg,
                          borderColor: bdr,
                          hintColor: mt,
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      VehicleFormLabel(text: 'Registration Number', color: tx),
                      VehicleNumberField(
                        controller: _numberController,
                        ibg: ibg,
                        bdr: bdr,
                        mt: mt,
                        tx: tx,
                      ),
                      const SizedBox(height: 16),
                      VehicleFormLabel(text: 'Vehicle Type', color: tx),
                      VehicleTypeDropdown(
                        selectedType: _type,
                        isOpen: _dropdownOpen,
                        onTap: () =>
                            setState(() => _dropdownOpen = !_dropdownOpen),
                        onSelected: (val) => setState(() {
                          _type = val;
                          _dropdownOpen = false;
                        }),
                        tx: tx,
                        mt: mt,
                        ibg: ibg,
                        card: card,
                        bdr: bdr,
                      ),
                      const SizedBox(height: 28),
                      VehicleSaveButton(
                        hasVehicle: vehicle != null,
                        onPressed: _saveVehicle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
