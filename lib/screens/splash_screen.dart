import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'role_selection_screen.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState()=>_SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _logo,_fade,_wave,_dots;
  late final Animation<double> _scale,_logoFade,_textFade;
  late final Animation<Offset> _slide;
  @override void initState(){
    super.initState();
    _logo=AnimationController(vsync:this,duration:const Duration(milliseconds:900))..forward();
    _fade=AnimationController(vsync:this,duration:const Duration(milliseconds:600));
    _wave=AnimationController(vsync:this,duration:const Duration(milliseconds:2000))..repeat();
    _dots=AnimationController(vsync:this,duration:const Duration(milliseconds:1200))..repeat();
    _scale=Tween<double>(begin:0.4,end:1.0).animate(CurvedAnimation(parent:_logo,curve:Curves.elasticOut));
    _logoFade=Tween<double>(begin:0.0,end:1.0).animate(CurvedAnimation(parent:_logo,curve:const Interval(0,0.5)));
    _textFade=Tween<double>(begin:0.0,end:1.0).animate(CurvedAnimation(parent:_fade,curve:Curves.easeOut));
    _slide=Tween<Offset>(begin:const Offset(0,0.4),end:Offset.zero).animate(CurvedAnimation(parent:_fade,curve:Curves.easeOut));
    Future.delayed(const Duration(milliseconds:500),()=>mounted?_fade.forward():null);
    Future.delayed(const Duration(seconds:3),(){if(!mounted)return;Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>const RoleSelectionScreen()));});
  }
  @override void dispose(){_logo.dispose();_fade.dispose();_wave.dispose();_dots.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(body:GestureDetector(
    onTap:()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>const RoleSelectionScreen())),
    child:Container(
      decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFF0F172A),Color(0xFF1E3A6E),Color(0xFF0F172A)],stops:[0.0,0.5,1.0])),
      child:Stack(children:[
        Positioned(top:-100,right:-80,child:Container(width:320,height:320,decoration:BoxDecoration(shape:BoxShape.circle,gradient:RadialGradient(colors:[AppColors.primary.withValues(alpha:0.12),Colors.transparent])))),
        Positioned(bottom:-80,left:-60,child:Container(width:280,height:280,decoration:BoxDecoration(shape:BoxShape.circle,gradient:RadialGradient(colors:[AppColors.primary.withValues(alpha:0.08),Colors.transparent])))),
        Positioned.fill(child:AnimatedBuilder(animation:_wave,builder:(_,__)=>CustomPaint(painter:_RoutePainter(progress:_wave.value)))),
        Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
          ScaleTransition(scale:_scale,child:FadeTransition(opacity:_logoFade,child:Container(
            width:110,height:110,
            decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,Color(0xFF1D4ED8)],begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(28),boxShadow:[BoxShadow(color:AppColors.primary.withValues(alpha:0.5),blurRadius:30,spreadRadius:5)]),
            child:CustomPaint(painter:_LogoPainter()),
          ))),
          const SizedBox(height:28),
          FadeTransition(opacity:_textFade,child:SlideTransition(position:_slide,child:Column(children:[
            RichText(text:TextSpan(children:[
              TextSpan(text:'Fleet',style:GoogleFonts.plusJakartaSans(fontSize:46,fontWeight:FontWeight.w800,color:Colors.white,letterSpacing:-1.5)),
              TextSpan(text:'Live',style:GoogleFonts.plusJakartaSans(fontSize:46,fontWeight:FontWeight.w800,color:AppColors.primaryLight,letterSpacing:-1.5)),
            ])),
            const SizedBox(height:10),
            Text('Track Every Vehicle. Anywhere. Anytime.',style:GoogleFonts.plusJakartaSans(fontSize:13,fontWeight:FontWeight.w500,color:AppColors.white50),textAlign:TextAlign.center),
            const SizedBox(height:36),
            Row(mainAxisAlignment:MainAxisAlignment.center,children:[
              for(final item in[('GPS Live',Icons.location_on_outlined),('Real-time',Icons.bolt_outlined),('Secure',Icons.shield_outlined)]as List<(String,IconData)>)...[
                Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6),decoration:BoxDecoration(border:Border.all(color:AppColors.white20),borderRadius:BorderRadius.circular(100),color:AppColors.white10),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(item.$2,size:12,color:AppColors.primaryLight),const SizedBox(width:5),Text(item.$1,style:GoogleFonts.plusJakartaSans(fontSize:11,fontWeight:FontWeight.w600,color:AppColors.white70))])),
                if(item.$1!='Secure')const SizedBox(width:8),
              ]
            ]),
          ]))),
          const SizedBox(height:60),
          FadeTransition(opacity:_textFade,child:AnimatedBuilder(animation:_dots,builder:(_,__)=>Row(mainAxisAlignment:MainAxisAlignment.center,children:List.generate(3,(i){final v=math.sin((_dots.value*math.pi*2)-(i*0.6)).abs();return Container(margin:const EdgeInsets.symmetric(horizontal:3),width:6,height:6,decoration:BoxDecoration(shape:BoxShape.circle,color:AppColors.primary.withValues(alpha:0.4+v*0.6)));}))),),
          const SizedBox(height:10),
          FadeTransition(opacity:_textFade,child:Text('Tap to continue',style:GoogleFonts.plusJakartaSans(fontSize:10,fontWeight:FontWeight.w600,color:AppColors.white20,letterSpacing:2),textAlign:TextAlign.center)),
        ])),
      ]),
    ),
  ));
}
class _LogoPainter extends CustomPainter {
  @override void paint(Canvas c,Size s){
    final cx=s.width/2,cy=s.height*0.42;
    final w=Paint()..color=Colors.white..style=PaintingStyle.fill;
    final ws=Paint()..color=Colors.white.withValues(alpha:0.45)..style=PaintingStyle.stroke..strokeWidth=2.5..strokeCap=StrokeCap.round;
    final wf=Paint()..color=Colors.white.withValues(alpha:0.22)..style=PaintingStyle.stroke..strokeWidth=2..strokeCap=StrokeCap.round;
    c.drawCircle(Offset(cx,cy),18,Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=2.8);
    c.drawCircle(Offset(cx,cy),7,w);
    c.drawLine(Offset(cx,cy+18),Offset(cx,s.height*0.82),Paint()..color=Colors.white..strokeWidth=3..strokeCap=StrokeCap.round);
    c.drawLine(Offset(cx-14,s.height*0.82),Offset(cx+14,s.height*0.82),Paint()..color=Colors.white..strokeWidth=3..strokeCap=StrokeCap.round);
    c.drawArc(Rect.fromCenter(center:Offset(cx,cy),width:52,height:52),math.pi*0.7,math.pi*0.6,false,ws);
    c.drawArc(Rect.fromCenter(center:Offset(cx,cy),width:72,height:72),math.pi*0.7,math.pi*0.6,false,wf);
    c.drawArc(Rect.fromCenter(center:Offset(cx,cy),width:52,height:52),-math.pi*0.3,-math.pi*0.6,false,ws);
    c.drawArc(Rect.fromCenter(center:Offset(cx,cy),width:72,height:72),-math.pi*0.3,-math.pi*0.6,false,wf);
  }
  @override bool shouldRepaint(_)=>false;
}
class _RoutePainter extends CustomPainter {
  final double progress; _RoutePainter({required this.progress});
  @override void paint(Canvas c,Size s){
    final p=Paint()..color=AppColors.primaryLight.withValues(alpha:0.08)..strokeWidth=2..style=PaintingStyle.stroke;
    final path=Path()..moveTo(s.width*0.15,s.height*0.9)..lineTo(s.width*0.15,s.height*0.55)..lineTo(s.width*0.5,s.height*0.55)..lineTo(s.width*0.5,s.height*0.35)..lineTo(s.width*0.85,s.height*0.35)..lineTo(s.width*0.85,s.height*0.1);
    final dashWidth = 8.0;
    final dashSpace = 6.0;
    double distance = progress * (dashWidth + dashSpace);
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        c.drawPath(metric.extractPath(distance, distance + dashWidth), p);
        distance += dashWidth + dashSpace;
      }
      distance = distance - metric.length;
    }
    c.drawCircle(Offset(s.width*0.15,s.height*0.9),5,Paint()..color=AppColors.success.withValues(alpha:0.4));
    c.drawCircle(Offset(s.width*0.85,s.height*0.1),5,Paint()..color=AppColors.warning.withValues(alpha:0.4));
  }
  @override bool shouldRepaint(_RoutePainter o)=>o.progress!=progress;
}
