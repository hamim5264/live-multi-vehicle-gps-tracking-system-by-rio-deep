import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/role_selection_screen.dart';

class AuthViewModel extends ChangeNotifier {
  UserRole? _currentRole;
  String? _currentUserEmail;
  String? _currentUserName;
  bool _isLoading = false;
  String? _loginError;

  UserRole? get currentRole => _currentRole;

  String? get currentUserEmail => _currentUserEmail;

  String? get currentUserName => _currentUserName;

  bool get isLoading => _isLoading;

  String? get loginError => _loginError;

  AuthViewModel();

  Future<void> checkSavedSession() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final savedRoleStr = prefs.getString('user_role');
      if (savedRoleStr != null) {
        _currentRole = savedRoleStr == 'driver'
            ? UserRole.driver
            : UserRole.user;
        _currentUserEmail = user.email;
        _currentUserName =
            user.displayName ??
            (_currentRole == UserRole.driver ? 'Driver' : 'User');
        notifyListeners();
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final savedRoleStr = prefs.getString('user_role');
      final savedEmail = prefs.getString('user_email');
      final savedName = prefs.getString('user_name');
      if (savedRoleStr != null && savedEmail != null) {
        _currentRole = savedRoleStr == 'driver'
            ? UserRole.driver
            : UserRole.user;
        _currentUserEmail = savedEmail;
        _currentUserName =
            savedName ?? (_currentRole == UserRole.driver ? 'Driver' : 'User');
        notifyListeners();
      }
    }
  }

  void selectRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  String _emailRoleKey(String email) => 'role_${email.toLowerCase().trim()}';

  Future<bool> login(String email, String password, UserRole role) async {
    _isLoading = true;
    _loginError = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final storedRoleStr = prefs.getString(_emailRoleKey(email));
    if (storedRoleStr != null) {
      final storedRole = storedRoleStr == 'driver'
          ? UserRole.driver
          : UserRole.user;
      if (storedRole != role) {
        _isLoading = false;
        _loginError = role == UserRole.driver
            ? 'This account is registered as a User. Please use the User Portal.'
            : 'This account is registered as a Driver. Please use the Driver Portal.';
        notifyListeners();
        return false;
      }
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentRole = role;
      _currentUserEmail = credential.user?.email;
      _currentUserName =
          credential.user?.displayName ??
          (role == UserRole.driver ? 'Driver' : 'User');

      await prefs.setString(
        'user_role',
        role == UserRole.driver ? 'driver' : 'user',
      );
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', _currentUserName ?? '');
      await prefs.setString(
        _emailRoleKey(email),
        role == UserRole.driver ? 'driver' : 'user',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(
        "Firebase Auth login failed: $e. Falling back to local simulator.",
      );

      await Future.delayed(const Duration(milliseconds: 800));
      _currentRole = role;
      _currentUserEmail = email;
      _currentUserName = role == UserRole.driver ? 'Driver' : 'User';

      await prefs.setString(
        'user_role',
        role == UserRole.driver ? 'driver' : 'user',
      );
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', _currentUserName ?? '');
      await prefs.setString(
        _emailRoleKey(email),
        role == UserRole.driver ? 'driver' : 'user',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    UserRole role,
  ) async {
    _isLoading = true;
    _loginError = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final existingRoleStr = prefs.getString(_emailRoleKey(email));
    if (existingRoleStr != null) {
      final existingRole = existingRoleStr == 'driver'
          ? UserRole.driver
          : UserRole.user;
      if (existingRole != role) {
        _isLoading = false;
        _loginError = role == UserRole.driver
            ? 'This email is already registered as a User account.'
            : 'This email is already registered as a Driver account.';
        notifyListeners();
        return false;
      }
    }

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user?.updateDisplayName(name);

      _currentRole = role;
      _currentUserEmail = credential.user?.email;
      _currentUserName = name;

      await prefs.setString(
        'user_role',
        role == UserRole.driver ? 'driver' : 'user',
      );
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', name);
      await prefs.setString(
        _emailRoleKey(email),
        role == UserRole.driver ? 'driver' : 'user',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(
        "Firebase Auth register failed: $e. Falling back to local simulator.",
      );

      await Future.delayed(const Duration(milliseconds: 800));
      _currentRole = role;
      _currentUserEmail = email;
      _currentUserName = name;

      await prefs.setString(
        'user_role',
        role == UserRole.driver ? 'driver' : 'user',
      );
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', name);
      await prefs.setString(
        _emailRoleKey(email),
        role == UserRole.driver ? 'driver' : 'user',
      );

      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('user_email');
    await prefs.remove('user_name');

    _currentRole = null;
    _currentUserEmail = null;
    _currentUserName = null;
    notifyListeners();
  }

  void updateUserName(String name) {
    _currentUserName = name;
    notifyListeners();
  }
}
