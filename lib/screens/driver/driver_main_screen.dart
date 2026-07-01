import 'package:flutter/material.dart';
import 'driver_dashboard_screen.dart';
import 'driver_tracking_screen.dart';
import 'add_vehicle_screen.dart';
import 'driver_profile_screen.dart';
class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});
  @override State<DriverMainScreen> createState()=>_S();
}
class _S extends State<DriverMainScreen> {
  int _i=0;
  final _s=const[DriverDashboardScreen(),DriverTrackingScreen(),AddVehicleScreen(),DriverProfileScreen()];
  @override Widget build(BuildContext c)=>Scaffold(body:IndexedStack(index:_i,children:_s),bottomNavigationBar:NavigationBar(selectedIndex:_i,onDestinationSelected:(i)=>setState(()=>_i=i),destinations:const[NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home_rounded),label:'Dashboard'),NavigationDestination(icon:Icon(Icons.map_outlined),selectedIcon:Icon(Icons.map_rounded),label:'Map'),NavigationDestination(icon:Icon(Icons.directions_car_outlined),selectedIcon:Icon(Icons.directions_car_rounded),label:'Vehicle'),NavigationDestination(icon:Icon(Icons.person_outlined),selectedIcon:Icon(Icons.person_rounded),label:'Profile')]));
}
