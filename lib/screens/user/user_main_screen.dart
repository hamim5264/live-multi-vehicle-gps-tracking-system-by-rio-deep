import 'package:flutter/material.dart';
import 'user_home_screen.dart';
import 'vehicle_list_screen.dart';
import 'user_profile_screen.dart';
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});
  @override State<UserMainScreen> createState()=>_S();
}
class _S extends State<UserMainScreen> {
  int _i=0;
  final _s=const[UserHomeScreen(),VehicleListScreen(),UserProfileScreen()];
  @override Widget build(BuildContext c)=>Scaffold(body:IndexedStack(index:_i,children:_s),bottomNavigationBar:NavigationBar(selectedIndex:_i,onDestinationSelected:(i)=>setState(()=>_i=i),destinations:const[NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home_rounded),label:'Home'),NavigationDestination(icon:Icon(Icons.directions_car_outlined),selectedIcon:Icon(Icons.directions_car_rounded),label:'Vehicles'),NavigationDestination(icon:Icon(Icons.person_outlined),selectedIcon:Icon(Icons.person_rounded),label:'Profile')]));
}
