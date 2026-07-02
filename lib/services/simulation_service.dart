import 'dart:async';
import 'package:latlong2/latlong.dart';

class SimulationService {
  static final List<LatLng> _routePoints = [
    const LatLng(23.8103, 90.4125),
    const LatLng(23.8120, 90.4135),
    const LatLng(23.8145, 90.4140),
    const LatLng(23.8160, 90.4162),
    const LatLng(23.8185, 90.4178),
    const LatLng(23.8190, 90.4150),
    const LatLng(23.8170, 90.4110),
    const LatLng(23.8140, 90.4095),
    const LatLng(23.8120, 90.4080),
    const LatLng(23.8100, 90.4100),
  ];

  Timer? _timer;
  int _currentIndex = 0;
  final _controller = StreamController<LatLng>.broadcast();

  Stream<LatLng> get locationStream => _controller.stream;

  LatLng get currentPosition => _routePoints[_currentIndex];

  void startSimulation({Duration interval = const Duration(seconds: 2)}) {
    stopSimulation();
    _timer = Timer.periodic(interval, (timer) {
      _currentIndex = (_currentIndex + 1) % _routePoints.length;
      _controller.add(_routePoints[_currentIndex]);
    });
  }

  void stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  List<LatLng> getRoute() {
    return _routePoints;
  }

  void dispose() {
    stopSimulation();
    _controller.close();
  }
}
