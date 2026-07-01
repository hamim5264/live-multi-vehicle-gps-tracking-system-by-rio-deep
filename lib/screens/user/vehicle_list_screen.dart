import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/sample_data.dart';
import '../../models/vehicle.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/vehicle_details_sheet.dart';
class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});
  @override State<VehicleListScreen> createState()=>_S();
}
class _S extends State<VehicleListScreen> {
  final _c=TextEditingController();
  String _f='All',_q='';
  @override void initState(){super.initState();_c.addListener(()=>setState(()=>_q=_c.text));}
  @override void dispose(){_c.dispose();super.dispose();}
  List<Vehicle> get _list=>sampleVehicles.where((v){
    if(_f=='Online'&&v.status!=VehicleStatus.online)return false;
    if(_f=='Idle'&&v.status!=VehicleStatus.idle)return false;
    if(_f=='Offline'&&v.status!=VehicleStatus.offline)return false;
    if(_q.isNotEmpty){final q=_q.toLowerCase();return v.name.toLowerCase().contains(q)||v.driver.toLowerCase().contains(q)||v.number.toLowerCase().contains(q);}
    return true;
  }).toList();
  @override Widget build(BuildContext context){
    final dk=Theme.of(context).brightness==Brightness.dark;
    final bg=dk?AppColors.darkBg:AppColors.lightBg,card=dk?AppColors.darkCard:AppColors.lightCard,bdr=dk?AppColors.darkBorder:const Color(0xFFE2E8F0),tx=dk?Colors.white:const Color(0xFF0F172A),mt=dk?AppColors.white50:const Color(0xFF64748B),cbg=dk?AppColors.white10:AppColors.lightCard;
    return Scaffold(backgroundColor:bg,body:SafeArea(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Padding(padding:const EdgeInsets.fromLTRB(20,12,20,0),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('Live Vehicles',style:GoogleFonts.plusJakartaSans(fontSize:22,fontWeight:FontWeight.w800,color:tx)),const SizedBox(height:14),
        TextField(controller:_c,style:GoogleFonts.plusJakartaSans(color:tx),decoration:InputDecoration(hintText:'Search vehicles or drivers…',hintStyle:GoogleFonts.plusJakartaSans(color:mt,fontSize:13),prefixIcon:Icon(Icons.search_rounded,color:mt,size:20),suffixIcon:_q.isNotEmpty?IconButton(icon:Icon(Icons.clear_rounded,color:mt,size:18),onPressed:()=>_c.clear()):null,filled:true,fillColor:card,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide(color:bdr)),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide(color:bdr)),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:const BorderSide(color:AppColors.primary,width:1.5)),contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:12))),
        const SizedBox(height:12),
        Row(children:[...['All','Online','Idle','Offline'].map((f)=>GestureDetector(onTap:()=>setState(()=>_f=f),child:AnimatedContainer(duration:const Duration(milliseconds:200),margin:const EdgeInsets.only(right:8),padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),decoration:BoxDecoration(color:_f==f?AppColors.primary:cbg,borderRadius:BorderRadius.circular(12),border:_f==f?null:Border.all(color:bdr)),child:Text(f,style:GoogleFonts.plusJakartaSans(fontSize:12,fontWeight:FontWeight.w700,color:_f==f?Colors.white:mt))))),const Spacer(),GestureDetector(onTap:(){},child:Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:7),decoration:BoxDecoration(color:cbg,borderRadius:BorderRadius.circular(12),border:Border.all(color:bdr)),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.sort_rounded,size:14,color:mt),const SizedBox(width:4),Text('Sort',style:GoogleFonts.plusJakartaSans(fontSize:12,fontWeight:FontWeight.w700,color:mt))])))],),
        const SizedBox(height:12),
      ])),
      Expanded(
        child: _list.isEmpty
            ? Center(
                child: Text(
                  'No vehicles found',
                  style: GoogleFonts.plusJakartaSans(color: mt),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _list.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => VehicleDetailsSheet.show(context, _list[i]),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: bdr),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A5F),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.local_shipping_outlined,
                            color: AppColors.primaryLight,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _list[i].name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: tx,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  StatusBadge(status: _list[i].status),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _list[i].avatar,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      '${_list[i].driver} · ${_list[i].number}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: mt,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _IC(
                                    Icons.speed_rounded,
                                    '${_list[i].speed.toInt()} km/h',
                                    AppColors.primaryLight,
                                  ),
                                  const SizedBox(width: 10),
                                  _IC(Icons.route_outlined, _list[i].distance, mt),
                                  const SizedBox(width: 10),
                                  _IC(
                                    Icons.access_time_rounded,
                                    _list[i].lastUpdated,
                                    mt,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    ]),
  ));
}
}
class _IC extends StatelessWidget {
  final IconData i; final String v; final Color c;
  const _IC(this.i,this.v,this.c);
  @override Widget build(BuildContext _)=>Row(mainAxisSize:MainAxisSize.min,children:[Icon(i,size:11,color:c),const SizedBox(width:3),Text(v,style:GoogleFonts.plusJakartaSans(fontSize:10,fontWeight:FontWeight.w600,color:c))]);
}
