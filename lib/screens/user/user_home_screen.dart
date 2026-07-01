import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/vehicle.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/vehicle_details_sheet.dart';
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});
  @override State<UserHomeScreen> createState()=>_S();
}
class _S extends State<UserHomeScreen> {
  String _cat='All';
  @override Widget build(BuildContext context){
    final dk=Theme.of(context).brightness==Brightness.dark;
    final bg=dk?AppColors.darkBg:AppColors.lightBg,card=dk?AppColors.darkCard:AppColors.lightCard,bdr=dk?AppColors.darkBorder:const Color(0xFFE2E8F0),tx=dk?Colors.white:const Color(0xFF0F172A),mt=dk?AppColors.white50:const Color(0xFF64748B);
    final shown=sampleVehicles.where((v)=>_cat=='All'||v.type.toLowerCase().contains(_cat.toLowerCase())).toList();
    return Scaffold(backgroundColor:bg,body:SafeArea(child:CustomScrollView(slivers:[
      SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,12,20,0),child:Column(children:[
        Row(children:[Expanded(child:Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(16),border:Border.all(color:bdr)),child:Row(children:[Icon(Icons.search_rounded,color:mt,size:18),const SizedBox(width:10),Text('Search vehicles or drivers…',style:GoogleFonts.plusJakartaSans(fontSize:13,color:mt))]))),const SizedBox(width:10),Stack(children:[Container(width:48,height:48,decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(14),border:Border.all(color:bdr)),child:Icon(Icons.notifications_outlined,color:mt,size:22)),Positioned(top:10,right:10,child:Container(width:8,height:8,decoration:const BoxDecoration(color:AppColors.error,shape:BoxShape.circle)))])]),
        const SizedBox(height:16),
        SizedBox(height:36,child:ListView.separated(scrollDirection:Axis.horizontal,itemCount:vehicleCategories.length,separatorBuilder:(_,__)=>const SizedBox(width:8),itemBuilder:(_,i){final c=vehicleCategories[i];final a=_cat==c;return GestureDetector(onTap:()=>setState(()=>_cat=c),child:AnimatedContainer(duration:const Duration(milliseconds:200),padding:const EdgeInsets.symmetric(horizontal:16,vertical:8),decoration:BoxDecoration(color:a?AppColors.primary:dk?AppColors.white10:AppColors.lightCard,borderRadius:BorderRadius.circular(12),border:a?null:Border.all(color:bdr),boxShadow:a?[BoxShadow(color:AppColors.primary.withValues(alpha:0.3),blurRadius:8)]:null),child:Text(c,style:GoogleFonts.plusJakartaSans(fontSize:12,fontWeight:FontWeight.w700,color:a?Colors.white:mt))));})),
        const SizedBox(height:16),
        Row(children:[_SC('12','Active Vehicles','+2',AppColors.primaryLight,card,bdr,tx,mt),const SizedBox(width:10),_SC('8','Online Drivers','+1',AppColors.success,card,bdr,tx,mt),const SizedBox(width:10),_SC('24','Deliveries','+6',AppColors.warning,card,bdr,tx,mt)]),
        const SizedBox(height:16),
        ClipRRect(borderRadius:BorderRadius.circular(20),child:Container(height:220,decoration:BoxDecoration(borderRadius:BorderRadius.circular(20),border:Border.all(color:bdr)),child:Stack(children:[CityMap(vehicles:sampleVehicles,onMarkerTap:(v)=>VehicleDetailsSheet.show(context,v)),Positioned(top:10,right:10,child:Column(children:[_MB(Icons.add_rounded),const SizedBox(height:6),_MB(Icons.remove_rounded)])),Positioned(bottom:10,left:10,child:Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),decoration:BoxDecoration(color:AppColors.primary,borderRadius:BorderRadius.circular(100)),child:Text('${sampleVehicles.where((v)=>v.status==VehicleStatus.online).length} vehicles live',style:GoogleFonts.plusJakartaSans(fontSize:10,fontWeight:FontWeight.w700,color:Colors.white))))]))),
        const SizedBox(height:20),
        Row(children:[Text('Nearby Vehicles',style:GoogleFonts.plusJakartaSans(fontSize:16,fontWeight:FontWeight.w700,color:tx)),const Spacer(),Text('View all →',style:GoogleFonts.plusJakartaSans(fontSize:12,fontWeight:FontWeight.w700,color:AppColors.primaryLight))]),
        const SizedBox(height:10),
      ]))),
      SliverPadding(padding:const EdgeInsets.symmetric(horizontal:20),sliver:SliverList(delegate:SliverChildBuilderDelegate((ctx,i){final v=shown[i];return GestureDetector(onTap:()=>VehicleDetailsSheet.show(context,v),child:Container(margin:const EdgeInsets.only(bottom:12),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(16),border:Border.all(color:bdr)),child:Row(children:[Container(width:48,height:48,decoration:BoxDecoration(color:const Color(0xFF1E3A5F),borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.local_shipping_outlined,color:AppColors.primaryLight,size:22)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Text(v.name,style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:14,color:tx)),const SizedBox(width:6),StatusBadge(status:v.status)]),const SizedBox(height:2),Text('${v.driver} · ${v.number}',style:GoogleFonts.plusJakartaSans(fontSize:11,color:mt),overflow:TextOverflow.ellipsis)])),const SizedBox(width:8),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text('${v.speed.toInt()} km/h',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:13,color:tx)),Text(v.lastUpdated,style:GoogleFonts.plusJakartaSans(fontSize:10,color:mt))])])));},childCount:shown.length))),
      const SliverToBoxAdapter(child:SizedBox(height:24)),
    ])));
  }
}
class _SC extends StatelessWidget {
  final String v,l,ch; final Color c,card,bdr,tx,mt;
  const _SC(this.v,this.l,this.ch,this.c,this.card,this.bdr,this.tx,this.mt);
  @override Widget build(BuildContext _)=>Expanded(child:Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:card,borderRadius:BorderRadius.circular(16),border:Border.all(color:bdr)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(v,style:GoogleFonts.plusJakartaSans(fontSize:22,fontWeight:FontWeight.w800,color:c)),Text(l,style:GoogleFonts.plusJakartaSans(fontSize:9,color:mt,height:1.3)),Text(ch,style:GoogleFonts.plusJakartaSans(fontSize:10,fontWeight:FontWeight.w700,color:AppColors.success))])));
}
class _MB extends StatelessWidget {
  final IconData i;
  const _MB(this.i);
  @override Widget build(BuildContext _)=>Container(width:32,height:32,decoration:BoxDecoration(color:Colors.black.withValues(alpha:0.55),borderRadius:BorderRadius.circular(10),border:Border.all(color:AppColors.white20)),child:Icon(i,color:Colors.white,size:18));
}
