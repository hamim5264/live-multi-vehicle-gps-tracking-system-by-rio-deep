import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'core/app_router.dart';
import 'services/firebase_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/driver_viewmodel.dart';
import 'viewmodels/user_viewmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme_mode');
  if (savedTheme != null) {
    themeModeNotifier.value = savedTheme == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();

  final authViewModel = AuthViewModel();
  await authViewModel.checkSavedSession();

  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseService>.value(value: firebaseService),
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider(
          create: (context) => DriverViewModel(context.read<FirebaseService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(context.read<FirebaseService>()),
        ),
      ],
      child: const FleetLiveApp(),
    ),
  );
}

class FleetLiveApp extends StatelessWidget {
  const FleetLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (ctx, mode, _) => MaterialApp(
        title: 'FleetLive',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
