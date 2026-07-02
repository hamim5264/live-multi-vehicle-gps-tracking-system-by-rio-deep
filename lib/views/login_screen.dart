import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../core/app_router.dart';
import 'role_selection_screen.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fk = GlobalKey<FormState>();
  bool _sp = false;
  bool _rm = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_fk.currentState!.validate()) return;

    final authVm = context.read<AuthViewModel>();
    final success = await authVm.login(
      _emailController.text.trim(),
      _passwordController.text,
      widget.role,
    );

    if (!mounted) return;

    if (success) {
      final targetRoute = widget.role == UserRole.driver
          ? AppRouter.driverMain
          : AppRouter.userMain;
      Navigator.of(context).pushNamedAndRemoveUntil(targetRoute, (_) => false);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext c) {
    final dr = widget.role == UserRole.driver;
    final ac = dr ? AppColors.primaryLight : AppColors.success;
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 210,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A6E), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(c),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: ac.withValues(alpha: 0.1),
                          border: Border.all(color: ac.withValues(alpha: 0.4)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${dr ? "Driver" : "User"} Portal',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: ac,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome back to',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.white50,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Fleet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Live',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Form(
                key: _fk,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Enter your credentials to continue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.white50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _lbl('Email Address'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: _dec('email', Icons.person_outline_rounded),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Required'
                          : !RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w]{2,}$',
                            ).hasMatch(v)
                          ? 'Invalid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _lbl('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_sp,
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      decoration: _dec(
                        'password',
                        Icons.shield_outlined,
                        suffix: IconButton(
                          icon: Icon(
                            _sp
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.white35,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _sp = !_sp),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Required'
                          : v.length < 6
                          ? 'Min 6 chars'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _rm = !_rm),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _rm
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _rm
                                        ? AppColors.primary
                                        : AppColors.white35,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: _rm
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.white50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Feature coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authVm.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                        child: authVm.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    if (authVm.loginError != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.12),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.4),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.error,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authVm.loginError!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.darkBorder),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.white35,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.darkBorder),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feature coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          color: Color(0xFF4285F4),
                          size: 22,
                        ),
                        label: Text(
                          'Continue with Google',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white70,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.darkBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.white50,
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.signup,
                                  arguments: widget.role,
                                ),
                                child: Text(
                                  'Sign up',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.white70,
        letterSpacing: 0.8,
      ),
    ),
  );

  InputDecoration _dec(String h, IconData i, {Widget? suffix}) =>
      InputDecoration(
        hintText: h,
        prefixIcon: Icon(i, color: AppColors.white35, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.white10,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.white35,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      );
}
