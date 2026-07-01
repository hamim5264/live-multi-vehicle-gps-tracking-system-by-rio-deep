import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_theme.dart';
import 'screens/splash_screen.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const FleetLiveApp());
}
class FleetLiveApp extends StatelessWidget {
  const FleetLiveApp({super.key});
  @override Widget build(BuildContext context)=>ValueListenableBuilder<ThemeMode>(
    valueListenable:themeModeNotifier,
    builder:(ctx,mode,_)=>MaterialApp(title:'FleetLive',debugShowCheckedModeBanner:false,themeMode:mode,theme:AppTheme.lightTheme,darkTheme:AppTheme.darkTheme,home:const SplashScreen()),
  );
}
