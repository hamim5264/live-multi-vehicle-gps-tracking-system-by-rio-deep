import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/vehicle.dart';
 
class CityMap extends StatefulWidget {
  final List<Vehicle> vehicles;
  final bool showRoute;
  final void Function(Vehicle)? onMarkerTap;
  const CityMap({super.key,this.vehicles=const[],this.showRoute=false,this.onMarkerTap});
  @override State<CityMap> createState()=>_CityMapState();
}
class _CityMapState extends State<CityMap> with SingleTickerProviderStateMixin {
  late final AnimationController _p;
  @override void initState(){super.initState();_p=AnimationController(vsync:this,duration:const Duration(milliseconds:1800))..repeat();}
  @override void dispose(){_p.dispose();super.dispose();}
  static const _pos=[Offset(340,75),Offset(168,52),Offset(72,155),Offset(260,180),Offset(120,105)];
  static const _col=[AppColors.primaryLight,AppColors.success,AppColors.warning,AppColors.primaryLight,AppColors.error];
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:_p,builder:(ctx,_)=>GestureDetector(
    onTapUp:(d){
      if(widget.onMarkerTap==null)return;
      final rb=ctx.findRenderObject() as RenderBox?;
      if(rb==null)return;
      final sz=rb.size;
      final pos=d.localPosition;
      for(int i=0;i<math.min(widget.vehicles.length,_pos.length);i++){
        final p=_pos[i];
        final dx=p.dx*(sz.width/390), dy=p.dy*(sz.height/240);
        if((pos-Offset(dx,dy)).distance<24){widget.onMarkerTap!(widget.vehicles[i]);break;}
      }
    },
    child:CustomPaint(painter:_MapPainter(pulse:_p.value,vehicles:widget.vehicles,positions:_pos,colors:_col,showRoute:widget.showRoute),size:Size.infinite),
  ));
}
 
class _MapPainter extends CustomPainter {
  final double pulse; final List<Vehicle> vehicles; final List<Offset> positions; final List<Color> colors; final bool showRoute;
  _MapPainter({required this.pulse,required this.vehicles,required this.positions,required this.colors,required this.showRoute});
  @override void paint(Canvas c,Size s){
    final sx=s.width/390,sy=s.height/240;
    c.drawRect(Rect.fromLTWH(0,0,s.width,s.height),Paint()..color=AppColors.mapBg);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(195*sx,10*sy,62*sx,30*sy),const Radius.circular(3)),Paint()..color=AppColors.mapPark);
    final bp=Paint()..color=AppColors.mapBlock;
    for(final b in _b) c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(b[0]*sx,b[1]*sy,b[2]*sx,b[3]*sy),const Radius.circular(2)),bp);
    final mp=Paint()..color=AppColors.mapMajorRoad..strokeWidth=14*math.min(sx,sy)..style=PaintingStyle.stroke;
    for(final y in[45.0,92.0,140.0,188.0]) c.drawLine(Offset(0,y*sy),Offset(s.width,y*sy),mp);
    for(final x in[35.0,85.0,168.0,260.0,340.0]) c.drawLine(Offset(x*sx,0),Offset(x*sx,s.height),mp);
    final mnp=Paint()..color=AppColors.mapMinorRoad..strokeWidth=5*math.min(sx,sy)..style=PaintingStyle.stroke;
    for(final y in[20.0,68.0,115.0,165.0]) c.drawLine(Offset(0,y*sy),Offset(s.width,y*sy),mnp);
    if(showRoute){
      final path=Path()..moveTo(340*sx,220*sy)..lineTo(340*sx,140*sy)..lineTo(260*sx,140*sy)..lineTo(260*sx,92*sy)..lineTo(168*sx,92*sy)..lineTo(168*sx,45*sy)..lineTo(85*sx,45*sy);
      c.drawPath(path,Paint()..color=AppColors.mapRoute.withValues(alpha:0.18)..strokeWidth=14*sx..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round);
      c.drawPath(path,Paint()..color=AppColors.mapRoute..strokeWidth=4*sx..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round);
    }
    for(int i=0;i<math.min(vehicles.length,positions.length);i++){
      final p=positions[i]; final col=colors[i%colors.length];
      final cx=p.dx*sx,cy=p.dy*sy,r=math.min(sx,sy);
      c.drawCircle(Offset(cx,cy),(12+pulse*8)*r,Paint()..color=col.withValues(alpha:(1-pulse)*0.25));
      c.drawCircle(Offset(cx,cy),10*r,Paint()..color=col.withValues(alpha:0.25));
      c.drawCircle(Offset(cx,cy),6*r,Paint()..color=col);
    }
  }
  @override bool shouldRepaint(_MapPainter o)=>o.pulse!=pulse||o.vehicles!=vehicles;
  static const List<List<double>> _b=[[10,5,55,25],[80,5,85,22],[280,5,45,25],[335,5,44,22],[10,55,36,28],[50,55,65,28],[125,55,37,28],[180,55,75,28],[265,55,55,22],[270,77,50,6],[335,55,44,28],[10,108,46,28],[125,108,52,28],[180,108,55,28],[265,108,105,28],[10,160,58,20],[75,160,50,20],[130,160,105,20],[265,160,46,12],[265,172,46,8],[320,160,60,20]];
}
 
class TrackingMap extends StatefulWidget {
  const TrackingMap({super.key});
  @override State<TrackingMap> createState()=>_TrackingMapState();
}
class _TrackingMapState extends State<TrackingMap> with TickerProviderStateMixin {
  late final AnimationController _p,_m;
  @override void initState(){super.initState();_p=AnimationController(vsync:this,duration:const Duration(milliseconds:1500))..repeat();_m=AnimationController(vsync:this,duration:const Duration(seconds:6))..repeat();}
  @override void dispose(){_p.dispose();_m.dispose();super.dispose();}
  @override Widget build(BuildContext c)=>AnimatedBuilder(animation:Listenable.merge([_p,_m]),builder:(_,__)=>CustomPaint(painter:_TrackPainter(pulse:_p.value,move:_m.value),size:Size.infinite));
}
class _TrackPainter extends CustomPainter {
  final double pulse,move;
  _TrackPainter({required this.pulse,required this.move});
  @override void paint(Canvas c,Size s){
    c.drawRect(Rect.fromLTWH(0,0,s.width,s.height),Paint()..color=AppColors.mapBg);
    final sx=s.width/390,sy=s.height/760;
    for(final b in _bb) c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(b[0]*sx,b[1]*sy,b[2]*sx,b[3]*sy),const Radius.circular(2)),Paint()..color=AppColors.mapBlock);
    final mp=Paint()..color=AppColors.mapMajorRoad..strokeWidth=14*sx..style=PaintingStyle.stroke;
    for(final y in[92.0,188.0,284.0,378.0,480.0,580.0,680.0]) c.drawLine(Offset(0,y*sy),Offset(s.width,y*sy),mp);
    for(final x in[72.0,168.0,260.0,340.0]) c.drawLine(Offset(x*sx,0),Offset(x*sx,s.height),mp);
    final pts=[Offset(340*sx,680*sy),Offset(340*sx,284*sy),Offset(260*sx,284*sy),Offset(260*sx,188*sy),Offset(168*sx,188*sy),Offset(168*sx,92*sy),Offset(72*sx,92*sy)];
    final rp=Path()..moveTo(pts.first.dx,pts.first.dy);
    for(final p in pts.skip(1)) rp.lineTo(p.dx,p.dy);
    c.drawPath(rp,Paint()..color=AppColors.mapRoute.withValues(alpha:0.18)..strokeWidth=14*sx..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round);
    c.drawPath(rp,Paint()..color=AppColors.mapRoute..strokeWidth=4*sx..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round);
    double tl=0; for(int i=0;i<pts.length-1;i++) tl+=(pts[i+1]-pts[i]).distance;
    double td=move*tl; Offset vp=pts.last;
    for(int i=0;i<pts.length-1;i++){final seg=(pts[i+1]-pts[i]).distance;if(td<=seg){vp=pts[i]+(pts[i+1]-pts[i])*(td/seg);break;}td-=seg;}
    c.drawCircle(vp,(14+pulse*10)*sx,Paint()..color=AppColors.primary.withValues(alpha:(1-pulse)*0.3));
    c.drawCircle(vp,9*sx,Paint()..color=AppColors.primary..maskFilter=const MaskFilter.blur(BlurStyle.normal,4));
    c.drawCircle(vp,7*sx,Paint()..color=Colors.white);
  }
  @override bool shouldRepaint(_TrackPainter o)=>o.pulse!=pulse||o.move!=move;
  static const List<List<double>> _bb=[[10,10,58,62],[78,10,88,38],[276,10,48,62],[334,10,46,62],[10,108,38,52],[52,108,68,52],[124,108,38,52],[178,108,78,52],[266,108,108,52],[10,218,48,58],[124,218,55,58],[183,218,58,58],[266,218,108,58],[10,308,60,52],[74,308,52,52],[130,308,108,52],[266,308,108,52],[10,400,55,62],[168,400,80,62],[260,400,108,62],[10,490,108,62],[168,490,80,62],[260,490,108,62]];
}
