import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/sample_data.dart';
class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});
  @override Widget build(BuildContext context){
    final dk=Theme.of(context).brightness==Brightness.dark;
    final bg=dk?AppColors.darkBg:AppColors.lightBg,card=dk?AppColors.darkCard:AppColors.lightCard,bdr=dk?AppColors.darkBorder:const Color(0xFFE2E8F0),tx=dk?Colors.white:const Color(0xFF0F172A),mt=dk?AppColors.white50:const Color(0xFF64748B);
    return Scaffold(backgroundColor:bg,body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.symmetric(horizontal:20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const SizedBox(height:12),
      Row(children:[
        Container(width:48,height:48,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,AppColors.primaryLight],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(14)),alignment:Alignment.center,child:Text('RA',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w800,fontSize:16,color:Colors.white))),
        const SizedBox(width:12),
        Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Good morning 👋',style:GoogleFonts.plusJakartaSans(fontSize:12,color:mt)),Text('Rahul Ahmed',style:GoogleFonts.plusJakartaSans(fontSize:16,fontWeight:FontWeight.w700,color:tx))]),
        const Spacer(),
        Stack(children:[Container(width:44,height:44,decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(14),border:Border.all(color:bdr)),child:Icon(Icons.notifications_outlined,color:mt,size:20)),Positioned(top:8,right:8,child:Container(width:8,height:8,decoration:const BoxDecoration(color:AppColors.error,shape:BoxShape.circle)))]),
      ]),
      const SizedBox(height:20),
      Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF1E3A6E),Color(0xFF162D52)],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(24),border:Border.all(color:AppColors.primary.withValues(alpha:0.2))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Current Vehicle',style:GoogleFonts.plusJakartaSans(fontSize:11,color:AppColors.white50)),Text('Toyota Hilux',style:GoogleFonts.plusJakartaSans(fontSize:22,fontWeight:FontWeight.w800,color:Colors.white)),Text('ABC-1234 · Truck',style:GoogleFonts.plusJakartaSans(fontSize:12,color:AppColors.white50))]),const Spacer(),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),decoration:BoxDecoration(color:AppColors.success.withValues(alpha:0.2),border:Border.all(color:AppColors.success.withValues(alpha:0.4)),borderRadius:BorderRadius.circular(100)),child:Row(mainAxisSize:MainAxisSize.min,children:[Container(width:6,height:6,decoration:const BoxDecoration(color:AppColors.success,shape:BoxShape.circle)),const SizedBox(width:5),Text('Online',style:GoogleFonts.plusJakartaSans(fontSize:11,fontWeight:FontWeight.w700,color:AppColors.success))]))],),
        const SizedBox(height:16),
        Row(children:[const Icon(Icons.local_shipping_outlined,color:AppColors.white20,size:40),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[ClipRRect(borderRadius:BorderRadius.circular(100),child:LinearProgressIndicator(value:0.75,backgroundColor:AppColors.white20,valueColor:const AlwaysStoppedAnimation(AppColors.primaryLight),minHeight:6)),const SizedBox(height:5),Text('Route progress: 75%',style:GoogleFonts.plusJakartaSans(fontSize:10,color:AppColors.white35))]))]),
        const SizedBox(height:10),
        Row(children:[const Icon(Icons.location_on_outlined,color:AppColors.white50,size:13),const SizedBox(width:4),Text('Dhaka, Bangladesh · 23.8103°N',style:GoogleFonts.plusJakartaSans(fontSize:11,color:AppColors.white50))]),
      ])),
      const SizedBox(height:16),
      Row(children:[_SC('124 km','Distance',Icons.route_outlined,AppColors.primaryLight,card,bdr,tx,mt),const SizedBox(width:10),_SC('6h 20m','Online',Icons.access_time_outlined,AppColors.success,card,bdr,tx,mt),const SizedBox(width:10),_SC('8','Trips',Icons.directions_outlined,AppColors.warning,card,bdr,tx,mt)]),
      const SizedBox(height:20),
      Text('Quick Actions',style:GoogleFonts.plusJakartaSans(fontSize:16,fontWeight:FontWeight.w700,color:tx)),
      const SizedBox(height:12),
      Row(children:[
        Expanded(child:_AB('Start Tracking',Icons.play_arrow_rounded,gradient:const LinearGradient(colors:[AppColors.primary,AppColors.primaryLight]))),
        const SizedBox(width:10),
        Expanded(child:_AB('Stop',Icons.stop_rounded,color:AppColors.error,card:card,bdr:bdr)),
        const SizedBox(width:10),
        Expanded(child:_AB('Edit',Icons.edit_outlined,color:mt,card:card,bdr:bdr)),
      ]),
      const SizedBox(height:24),
      Text("Today's Activity",style:GoogleFonts.plusJakartaSans(fontSize:16,fontWeight:FontWeight.w700,color:tx)),
      const SizedBox(height:12),
      Container(decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(20),border:Border.all(color:bdr)),child:Column(children:List.generate(activityFeed.length,(i){
        final item=activityFeed[i];
        final dc=item['type']=='start'?AppColors.success:item['type']=='done'?AppColors.primaryLight:AppColors.warning;
        return Container(decoration:BoxDecoration(border:i<activityFeed.length-1?Border(bottom:BorderSide(color:bdr)):null),padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[Container(width:8,height:8,decoration:BoxDecoration(color:dc,shape:BoxShape.circle)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(item['action']!,style:GoogleFonts.plusJakartaSans(fontSize:13,fontWeight:FontWeight.w600,color:tx)),Text(item['location']!,style:GoogleFonts.plusJakartaSans(fontSize:11,color:mt))])),Text(item['time']!,style:GoogleFonts.plusJakartaSans(fontSize:11,color:mt))]));
      }))),
      const SizedBox(height:24),
    ]))));
  }
}
class _SC extends StatelessWidget {
  final String v,l; final IconData i; final Color c,card,bdr,tx,mt;
  const _SC(this.v,this.l,this.i,this.c,this.card,this.bdr,this.tx,this.mt);
  @override Widget build(BuildContext _)=>Expanded(child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(16),border:Border.all(color:bdr)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(i,color:c,size:16),const SizedBox(height:8),Text(v,style:GoogleFonts.plusJakartaSans(fontSize:17,fontWeight:FontWeight.w800,color:tx)),Text(l,style:GoogleFonts.plusJakartaSans(fontSize:10,color:mt))])));
}
class _AB extends StatelessWidget {
  final String l; final IconData i; final LinearGradient? gradient; final Color? color,card,bdr;
  const _AB(this.l,this.i,{this.gradient,this.color,this.card,this.bdr});
  @override Widget build(BuildContext _)=>Container(padding:const EdgeInsets.symmetric(vertical:16),decoration:BoxDecoration(gradient:gradient,color:gradient==null?card:null,borderRadius:BorderRadius.circular(16),border:gradient==null?Border.all(color:bdr??AppColors.darkBorder):null),child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(i,color:gradient!=null?Colors.white:color,size:22),const SizedBox(height:5),Text(l,style:GoogleFonts.plusJakartaSans(fontSize:10,fontWeight:FontWeight.w700,color:gradient!=null?Colors.white:color),textAlign:TextAlign.center)]));
}
