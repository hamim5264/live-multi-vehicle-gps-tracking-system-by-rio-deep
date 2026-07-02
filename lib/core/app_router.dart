import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/role_selection_screen.dart';
import '../views/login_screen.dart';
import '../views/signup_screen.dart';
import '../views/driver/driver_main_screen.dart';
import '../views/user/user_main_screen.dart';
import '../views/driver/add_edit_vehicle_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String driverMain = '/driver-main';
  static const String userMain = '/user-main';
  static const String addVehicle = '/add-vehicle';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case login:
        final role = settings.arguments as UserRole;
        return MaterialPageRoute(builder: (_) => LoginScreen(role: role));
      case signup:
        final role = settings.arguments as UserRole;
        return MaterialPageRoute(builder: (_) => SignupScreen(role: role));
      case driverMain:
        return MaterialPageRoute(builder: (_) => const DriverMainScreen());
      case userMain:
        return MaterialPageRoute(builder: (_) => const UserMainScreen());
      case addVehicle:
        return MaterialPageRoute(builder: (_) => const AddEditVehicleScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
