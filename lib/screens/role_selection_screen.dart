import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'login_screen.dart';
enum UserRole { driver, user }
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(backgroundColor:const Color(0xFF0F172A),body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.symmetric(horizontal:24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    const SizedBox(height:20),
    RichText(text:TextSpan(children:[TextSpan(text:'Fleet',style:GoogleFonts.plusJakartaSans(fontSize:32,fontWeight:FontWeight.w800,color:Colors.white)),TextSpan(text:'Live',style:GoogleFonts.plusJakartaSans(fontSize:32,fontWeight:FontWeight.w800,color:AppColors.primaryLight))])),
    Text('Premium GPS Fleet Tracking',style:GoogleFonts.plusJakartaSans(fontSize:13,color:AppColors.white35)),
    const SizedBox(height:32),
    Text('Choose your role',style:GoogleFonts.plusJakartaSans(fontSize:26,fontWeight:FontWeight.w800,color:Colors.white)),
    Text("Select how you'll use FleetLive today",style:GoogleFonts.plusJakartaSans(fontSize:13,color:AppColors.white50)),
    const SizedBox(height:28),
    _Card(role:UserRole.driver,title:'Driver Portal',desc:'Manage your vehicle and share live location',icon:Icons.local_shipping_outlined,accent:AppColors.primary,features:const['Live GPS','Trip Logs','Stats'],onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const LoginScreen(role:UserRole.driver)))),
    const SizedBox(height:16),
    _Card(role:UserRole.user,title:'User Portal',desc:'Track all vehicles in real-time on a live map',icon:Icons.navigation_outlined,accent:AppColors.success,features:const['Fleet View','Alerts','Reports'],onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const LoginScreen(role:UserRole.user)))),
    const SizedBox(height:28),
    Row(children:[
      for(final i in[('Real-time',Icons.bolt,AppColors.primaryLight),('Encrypted',Icons.shield_outlined,AppColors.primaryLight),('99.9%',Icons.check_circle_outline,AppColors.primaryLight)]as List<(String,IconData,Color)>)
        Expanded(child:Container(margin:const EdgeInsets.symmetric(horizontal:4),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:AppColors.white10,borderRadius:BorderRadius.circular(16),border:Border.all(color:AppColors.darkBorder)),child:Column(children:[Icon(i.$2,color:i.$3,size:18),const SizedBox(height:4),Text(i.$1,style:GoogleFonts.plusJakartaSans(fontSize:11,fontWeight:FontWeight.w700,color:AppColors.white70),textAlign:TextAlign.center)]))),
    ]),
    const SizedBox(height:24),
  ]))));
}
class _Card extends StatelessWidget {
  final UserRole role; final String title,desc; final IconData icon; final Color accent; final List<String> features; final VoidCallback onTap;
  const _Card({required this.role,required this.title,required this.desc,required this.icon,required this.accent,required this.features,required this.onTap});
  @override Widget build(BuildContext c)=>GestureDetector(onTap:onTap,child:Container(
    padding:const EdgeInsets.all(22),
    decoration:BoxDecoration(gradient:LinearGradient(colors:role==UserRole.driver?[const Color(0xFF1E3A5F),const Color(0xFF162D48)]:[const Color(0xFF12352B),const Color(0xFF0D2720)],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(24),border:Border.all(color:accent.withValues(alpha:0.25))),
    child:Stack(children:[
      Positioned(top:-20,right:-20,child:Container(width:120,height:120,decoration:BoxDecoration(shape:BoxShape.circle,gradient:RadialGradient(colors:[accent.withValues(alpha:0.12),Colors.transparent])))),
      Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Container(width:60,height:60,decoration:BoxDecoration(color:accent.withValues(alpha:0.2),borderRadius:BorderRadius.circular(16),border:Border.all(color:accent.withValues(alpha:0.3))),child:Icon(icon,color:accent,size:28)),const Spacer(),Container(width:38,height:38,decoration:BoxDecoration(color:accent.withValues(alpha:0.15),borderRadius:BorderRadius.circular(12),border:Border.all(color:accent.withValues(alpha:0.25))),child:Icon(Icons.arrow_forward_ios_rounded,color:accent,size:16))]),
        const SizedBox(height:18),
        Text(title,style:GoogleFonts.plusJakartaSans(fontSize:20,fontWeight:FontWeight.w800,color:Colors.white)),
        const SizedBox(height:6),
        Text(desc,style:GoogleFonts.plusJakartaSans(fontSize:12,color:AppColors.white50,height:1.5)),
        const SizedBox(height:16),
        Row(children:features.map((f)=>Container(margin:const EdgeInsets.only(right:6),padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),decoration:BoxDecoration(color:accent.withValues(alpha:0.15),borderRadius:BorderRadius.circular(100)),child:Text(f,style:GoogleFonts.plusJakartaSans(fontSize:10,fontWeight:FontWeight.w700,color:accent)))).toList()),
      ]),
    ]),
  ));
}
