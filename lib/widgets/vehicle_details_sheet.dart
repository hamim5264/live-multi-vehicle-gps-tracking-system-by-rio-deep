import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/vehicle.dart';
import 'status_badge.dart';
 
class VehicleDetailsSheet extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleDetailsSheet({super.key,required this.vehicle});
  static void show(BuildContext context,Vehicle v)=>showModalBottomSheet(context:context,isScrollControlled:true,backgroundColor:Colors.transparent,builder:(_)=>VehicleDetailsSheet(vehicle:v));
  @override
  Widget build(BuildContext context)=>Container(
    decoration:const BoxDecoration(color:AppColors.darkCard,borderRadius:BorderRadius.vertical(top:Radius.circular(28))),
    padding:EdgeInsets.only(left:20,right:20,top:16,bottom:MediaQuery.of(context).viewInsets.bottom+24),
    child:Column(mainAxisSize:MainAxisSize.min,children:[
      Container(width:40,height:4,decoration:BoxDecoration(color:AppColors.white20,borderRadius:BorderRadius.circular(100))),
      const SizedBox(height:20),
      Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.white10,borderRadius:BorderRadius.circular(16)),
        child:Row(children:[
          Container(width:56,height:56,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,AppColors.primaryLight],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(16)),alignment:Alignment.center,
            child:Text(vehicle.avatar,style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w800,fontSize:18,color:Colors.white))),
          const SizedBox(width:12),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(vehicle.driver,style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:15,color:Colors.white)),
            Text('Driver',style:GoogleFonts.plusJakartaSans(fontSize:12,color:AppColors.white50)),
          ])),
          Container(width:44,height:44,decoration:BoxDecoration(color:AppColors.success.withValues(alpha:0.15),borderRadius:BorderRadius.circular(14),border:Border.all(color:AppColors.success.withValues(alpha:0.3))),child:const Icon(Icons.phone_outlined,color:AppColors.success,size:20)),
        ]),
      ),
      const SizedBox(height:12),
      Row(children:[
        Container(width:48,height:48,decoration:BoxDecoration(color:const Color(0xFF1E3A5F),borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.local_shipping_outlined,color:AppColors.primaryLight,size:24)),
        const SizedBox(width:12),
        Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(vehicle.name,style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:15,color:Colors.white)),
          Text('${vehicle.number} · ${vehicle.type}',style:GoogleFonts.plusJakartaSans(fontSize:12,color:AppColors.white50)),
        ]),
      ]),
      const SizedBox(height:14),
      Row(children:[
        _Stat(label:'Speed',value:'${vehicle.speed.toInt()} km/h',color:AppColors.primaryLight),
        const SizedBox(width:8),
        _Stat(label:'Status',value:vehicle.status.label,color:vehicle.status.color),
        const SizedBox(width:8),
        _Stat(label:'Updated',value:vehicle.lastUpdated,color:AppColors.warning),
      ]),
      const SizedBox(height:16),
      Row(children:[
        Expanded(child:ElevatedButton.icon(onPressed:(){},icon:const Icon(Icons.route_outlined,size:18),label:const Text('View Route'),style:ElevatedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:14)))),
        const SizedBox(width:10),
        Expanded(child:OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.phone_outlined,size:18,color:AppColors.success),label:Text('Contact',style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,color:AppColors.success)),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:14),side:const BorderSide(color:AppColors.success),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))))),
      ]),
    ]),
  );
}
class _Stat extends StatelessWidget {
  final String label,value; final Color color;
  const _Stat({required this.label,required this.value,required this.color});
  @override Widget build(BuildContext c)=>Expanded(child:Container(padding:const EdgeInsets.symmetric(vertical:10),decoration:BoxDecoration(color:AppColors.white10,borderRadius:BorderRadius.circular(12)),child:Column(children:[Text(value,style:GoogleFonts.plusJakartaSans(fontWeight:FontWeight.w700,fontSize:12,color:color),textAlign:TextAlign.center),const SizedBox(height:2),Text(label,style:GoogleFonts.plusJakartaSans(fontSize:10,color:AppColors.white50),textAlign:TextAlign.center)])));
}
