import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../widgets/map_widget.dart';
class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key});
  @override State<DriverTrackingScreen> createState()=>_S();
}
class _S extends State<DriverTrackingScreen> {
  bool _t=true;
  @override Widget build(BuildContext c)=>Scaffold(body:Stack(children:[
    const Positioned.fill(child:TrackingMap()),
    SafeArea(child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:8),child:Row(children:[
      _GB(Icons.arrow_back_ios_new_rounded,(){}),const Spacer(),
      Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:8),decoration:BoxDecoration(color:_t?AppColors.success.withValues(alpha:0.2):Colors.black.withValues(alpha:0.5),border:Border.all(color:_t?AppColors.success.withValues(alpha:0.4):AppColors.white20),borderRadius:BorderRadius.circular(100)),child:Row(mainAxisSize:MainAxisSize.min,children:[Container(width:8,height:8,decoration:BoxDecoration(color:_t?AppColors.success:AppColors.white35,shape:BoxShape.circle)),const SizedBox(width:6),Text(_t?'Live Tracking':'Tracking Off',style:GoogleFonts.plusJakartaSans(fontSize:12,fontWeight:FontWeight.w700,color:_t?AppColors.success:AppColors.white50))])),
      const Spacer(),_GB(Icons.more_vert_rounded,(){}),
    ]))),
    Positioned(top:MediaQuery.of(c).padding.top+72,right:16,child:Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),decoration:BoxDecoration(color:Colors.black.withValues(alpha:0.6),borderRadius:BorderRadius.circular(16),border:Border.all(color:AppColors.white20)),child:Column(mainAxisSize:MainAxisSize.min,children:[Text('65',style:GoogleFonts.plusJakartaSans(fontSize:26,fontWeight:FontWeight.w800,color:Colors.white,height:1)),Text('KM/H',style:GoogleFonts.plusJakartaSans(fontSize:9,fontWeight:FontWeight.w700,color:AppColors.white50,letterSpacing:2))]))),
    Positioned(left:16,right:16,bottom:24,child:Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:Colors.black.withValues(alpha:0.65),borderRadius:BorderRadius.circular(24),border:Border.all(color:AppColors.white20)),child:Column(mainAxisSize:MainAxisSize.min,children:[
      Row(children:[Container(width:44,height:44,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,AppColors.primaryLight],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(14)),alignment:Alignment.center,child:Text('RA',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w800,fontSize:15,color:Colors.white))),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Rahul Ahmed',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:14,color:Colors.white)),Text('Toyota Hilux · ABC-1234',style:GoogleFonts.plusJakartaSans(fontSize:11,color:AppColors.white50))])),Row(children:[const Icon(Icons.signal_cellular_alt_rounded,color:AppColors.success,size:14),const SizedBox(width:4),Text('Strong',style:GoogleFonts.plusJakartaSans(fontSize:11,fontWeight:FontWeight.w600,color:AppColors.success))])]),
      const SizedBox(height:16),
      Row(children:[_DT('Speed','65 km/h',AppColors.primaryLight),const SizedBox(width:8),_DT('Latitude','23.8103°',AppColors.success),const SizedBox(width:8),_DT('Longitude','90.4125°',AppColors.warning)]),
      const SizedBox(height:12),
      Row(children:[const Icon(Icons.access_time_rounded,color:AppColors.white35,size:13),const SizedBox(width:5),Text('Last updated 2 seconds ago',style:GoogleFonts.plusJakartaSans(fontSize:11,color:AppColors.white35))]),
      const SizedBox(height:14),
      Row(children:[
        Expanded(child:GestureDetector(onTap:()=>setState(()=>_t=true),child:Container(padding:const EdgeInsets.symmetric(vertical:13),decoration:BoxDecoration(color:_t?AppColors.primary:AppColors.white10,borderRadius:BorderRadius.circular(14)),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.play_arrow_rounded,color:Colors.white,size:18),const SizedBox(width:5),Text('Start',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:13,color:_t?Colors.white:AppColors.white50))])))),
        const SizedBox(width:10),
        Expanded(child:GestureDetector(onTap:()=>setState(()=>_t=false),child:Container(padding:const EdgeInsets.symmetric(vertical:13),decoration:BoxDecoration(color:!_t?AppColors.error:AppColors.white10,borderRadius:BorderRadius.circular(14)),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.stop_rounded,color:Colors.white,size:18),const SizedBox(width:5),Text('Stop',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:13,color:!_t?Colors.white:AppColors.white50))])))),
        const SizedBox(width:10),
        GestureDetector(onTap:(){},child:Container(width:48,height:48,decoration:BoxDecoration(color:AppColors.white10,borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.my_location_rounded,color:Colors.white,size:20))),
      ]),
    ]))),
  ]));
}
class _GB extends StatelessWidget {
  final IconData i; final VoidCallback t;
  const _GB(this.i,this.t);
  @override Widget build(BuildContext _)=>GestureDetector(onTap:t,child:Container(width:44,height:44,decoration:BoxDecoration(color:Colors.black.withValues(alpha:0.5),borderRadius:BorderRadius.circular(14),border:Border.all(color:AppColors.white20)),child:Icon(i,color:Colors.white,size:20)));
}
class _DT extends StatelessWidget {
  final String l,v; final Color c;
  const _DT(this.l,this.v,this.c);
  @override Widget build(BuildContext _)=>Expanded(child:Container(padding:const EdgeInsets.symmetric(vertical:10),decoration:BoxDecoration(color:AppColors.white10,borderRadius:BorderRadius.circular(12)),child:Column(children:[Text(v,style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:12,color:c),textAlign:TextAlign.center),const SizedBox(height:2),Text(l,style:GoogleFonts.plusJakartaSans(fontSize:10,color:AppColors.white35),textAlign:TextAlign.center)])));
}
