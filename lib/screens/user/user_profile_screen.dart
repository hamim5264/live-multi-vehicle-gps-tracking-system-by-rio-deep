import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../role_selection_screen.dart';
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  @override State<UserProfileScreen> createState()=>_S();
}
class _S extends State<UserProfileScreen> {
  bool _n=true;
  @override Widget build(BuildContext context){
    final dk=Theme.of(context).brightness==Brightness.dark;
    final bg=dk?AppColors.darkBg:AppColors.lightBg,card=dk?AppColors.darkCard:AppColors.lightCard,bdr=dk?AppColors.darkBorder:const Color(0xFFE2E8F0),tx=dk?Colors.white:const Color(0xFF0F172A),mt=dk?AppColors.white50:const Color(0xFF64748B);
    final idark=themeModeNotifier.value==ThemeMode.dark;
    return Scaffold(backgroundColor:bg,body:SingleChildScrollView(child:Column(children:[
      Container(width:double.infinity,decoration:BoxDecoration(gradient:LinearGradient(colors:dk?[const Color(0xFF1E3A5F),AppColors.darkBg]:[const Color(0xFFEFF6FF),AppColors.lightBg],begin:Alignment.topCenter,end:Alignment.bottomCenter)),padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+20,bottom:36,left:20,right:20),child:Column(children:[
        Stack(alignment:Alignment.center,children:[Container(width:88,height:88,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,AppColors.primaryLight],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(24),boxShadow:[BoxShadow(color:AppColors.primary.withValues(alpha:0.35),blurRadius:20,spreadRadius:2)]),alignment:Alignment.center,child:Text('SI',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w800,fontSize:28,color:Colors.white))),Positioned(bottom:0,right:0,child:Container(width:28,height:28,decoration:BoxDecoration(color:AppColors.primary,borderRadius:BorderRadius.circular(10)),child:const Icon(Icons.camera_alt_outlined,color:Colors.white,size:14)))]),
        const SizedBox(height:14),
        Text('Sara Islam',style:GoogleFonts.plusJakartaSans(fontSize:22,fontWeight:FontWeight.w800,color:tx)),
        Text('sara@company.com',style:GoogleFonts.plusJakartaSans(fontSize:13,color:mt)),
        const SizedBox(height:10),
        Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:5),decoration:BoxDecoration(color:AppColors.primary.withValues(alpha:0.15),border:Border.all(color:AppColors.primary.withValues(alpha:0.3)),borderRadius:BorderRadius.circular(100)),child:Text('Fleet Manager',style:GoogleFonts.plusJakartaSans(fontSize:12,fontWeight:FontWeight.w700,color:AppColors.primaryLight))),
      ])),
      Transform.translate(offset:const Offset(0,-20),child:Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Container(padding:const EdgeInsets.symmetric(vertical:16,horizontal:8),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(20),border:Border.all(color:bdr),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:0.08),blurRadius:16,offset:const Offset(0,4))]),child:Row(children:[for(final s in [('5','Vehicles'),('8','Drivers'),('98%','Uptime')])Expanded(child:Container(decoration:s.$2!='Uptime'?BoxDecoration(border:Border(right:BorderSide(color:bdr))):null,child:Column(children:[Text(s.$1,style:GoogleFonts.plusJakartaSans(fontSize:20,fontWeight:FontWeight.w800,color:tx)),Text(s.$2,style:GoogleFonts.plusJakartaSans(fontSize:10,color:mt),textAlign:TextAlign.center)])))])))),
      Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('Settings',style:GoogleFonts.plusJakartaSans(fontSize:16,fontWeight:FontWeight.w700,color:tx)),const SizedBox(height:10),
        Container(decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(20),border:Border.all(color:bdr)),child:Column(children:[
          _T(idark?Icons.wb_sunny_outlined:Icons.dark_mode_outlined,'Dark Mode',mt,tx,bdr,trailing:Switch.adaptive(value:idark,onChanged:(_){themeModeNotifier.value=idark?ThemeMode.light:ThemeMode.dark;setState((){});},activeColor:AppColors.primary)),
          Divider(height:1,color:bdr),
          _T(Icons.notifications_outlined,'Notifications',mt,tx,bdr,trailing:Switch.adaptive(value:_n,onChanged:(_)=>setState(()=>_n=!_n),activeColor:AppColors.primary)),
          Divider(height:1,color:bdr),
          _T(Icons.shield_outlined,'Privacy & Security',mt,tx,bdr,onTap:(){}),
          Divider(height:1,color:bdr),
          _T(Icons.help_outline_rounded,'Help & Support',mt,tx,bdr,onTap:(){}),
          Divider(height:1,color:bdr),
          _T(Icons.settings_outlined,'App Settings',mt,tx,bdr,onTap:(){},isLast:true),
        ])),
        const SizedBox(height:20),
        SizedBox(width:double.infinity,child:OutlinedButton.icon(onPressed:()=>Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(_)=>const RoleSelectionScreen()),(_)=>false),icon:const Icon(Icons.logout_rounded,color:AppColors.error,size:18),label:Text('Sign Out',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,color:AppColors.error)),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:14),side:const BorderSide(color:AppColors.error),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16))))),
        const SizedBox(height:32),
      ])),
    ])));
  }
}
class _T extends StatelessWidget {
  final IconData i; final String l; final Color mt,tx,bdr; final Widget? trailing; final VoidCallback? onTap; final bool isLast;
  const _T(this.i,this.l,this.mt,this.tx,this.bdr,{this.trailing,this.onTap,this.isLast=false});
  @override Widget build(BuildContext _)=>ListTile(leading:Icon(i,color:mt,size:20),title:Text(l,style:GoogleFonts.plusJakartaSans(fontSize:14,fontWeight:FontWeight.w500,color:tx)),trailing:trailing??(onTap!=null?Icon(Icons.arrow_forward_ios_rounded,color:mt,size:14):null),onTap:onTap,contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:2));
}
