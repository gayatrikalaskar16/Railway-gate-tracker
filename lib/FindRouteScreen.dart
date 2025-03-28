import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

import 'GateScheduleScreen.dart';
import 'gate_data_service.dart';

class FindRouteScreen extends StatefulWidget {
  @override
  _FindRouteScreenState createState() => _FindRouteScreenState();
}

class _FindRouteScreenState extends State<FindRouteScreen>
    with TickerProviderStateMixin {
  final mapController = MapController();
  final GateDataService _gateDataService = GateDataService();

  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  bool _mapInitialized = false;

  List<LatLng> _routePoints = [];
  List<Marker> _gateMarkers = [];
  List<Marker> _nearbyPlaceMarkers = [];

  List<Map<String, dynamic>> _nearbyPlaces = [];

  List<Map<String, dynamic>> _gates = [];

  @override
  void initState() {
    super.initState();
    _fetchGatesData();
  }

  Future<void> _fetchGatesData() async {
    final gates = await _gateDataService.getAllGates();
    setState(() {
      _gates = gates;
      _mapInitialized = true;
    });
    _initializeMap();
    _generateNearbyPlaces();
  }

  void _initializeMap() {
    if (_gates.isNotEmpty) {
      final center = _gates[0]['location'] as LatLng;
      mapController.move(center, 10);
    }
    _updateGateMarkers();
  }

  void _updateGateMarkers() {
    setState(() {
      _gateMarkers = _gates
          .map((gate) => Marker(
                width: 80.0,
                height: 80.0,
                point: gate['location'] as LatLng,
                child: Column(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    Text(gate['gate_name'] as String,
                        style: TextStyle(fontSize: 10)),
                    Text(
                      'Next: ${_getNextOpenTime(gate['timing'])}',
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ))
          .toList();
    });
  }

  void _generateNearbyPlaces() {
    final random = Random();
    final placeTypes = ['Restaurant', 'Hotel', 'Shop', 'Park', 'Hospital'];

    _nearbyPlaces = _gates.expand((gate) {
      return List.generate(3, (index) {
        final latOffset = (random.nextDouble() - 0.5) * 0.01;
        final lngOffset = (random.nextDouble() - 0.5) * 0.01;
        final placeType = placeTypes[random.nextInt(placeTypes.length)];
        return {
          'name': '$placeType ${gate['gate_name']}',
          'type': placeType,
          'location': LatLng(
            (gate['location'] as LatLng).latitude + latOffset,
            (gate['location'] as LatLng).longitude + lngOffset,
          ),
        };
      });
    }).toList();

    _updateNearbyPlaceMarkers();
  }

  void _updateNearbyPlaceMarkers() {
    setState(() {
      _nearbyPlaceMarkers = _nearbyPlaces
          .map((place) => Marker(
                width: 80.0,
                height: 80.0,
                point: place['location'] as LatLng,
                child: Column(
                  children: [
                    Icon(Icons.place, color: Colors.blue),
                    Text(place['name'] as String,
                        style: TextStyle(fontSize: 8)),
                    Text(place['type'] as String,
                        style: TextStyle(fontSize: 8)),
                  ],
                ),
              ))
          .toList();
    });
  }

  String routeResult = '';

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        tileProvider: CancellableNetworkTileProvider(),
      );

  void _searchRoute() async {
    if (!_mapInitialized) {
      return;
    }

    String start = _startController.text;
    String destination = _destinationController.text;

    LatLng startPoint = LatLng(18.7542, 73.4782);
    LatLng endPoint = LatLng(18.7481, 73.4072);

    setState(() {
      _routePoints = [startPoint, endPoint];
      _gateMarkers = _gates
          .map((gate) => Marker(
                width: 80.0,
                height: 80.0,
                point: gate['location'] as LatLng,
                child: Column(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    Text(gate['gate_name'] as String,
                        style: TextStyle(fontSize: 10)),
                    Text(
                      'Next: ${_getNextOpenTime(gate['timing'])}',
                      style: TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ))
          .toList();
    });

    if (_routePoints.isNotEmpty) {
      double minLat = _routePoints[0].latitude;
      double maxLat = _routePoints[0].latitude;
      double minLng = _routePoints[0].longitude;
      double maxLng = _routePoints[0].longitude;

      for (var point in _routePoints) {
        minLat = min(minLat, point.latitude);
        maxLat = max(maxLat, point.latitude);
        minLng = min(minLng, point.longitude);
        maxLng = max(maxLng, point.longitude);
      }

      final centerLat = (minLat + maxLat) / 2;
      final centerLng = (minLng + maxLng) / 2;
      final center = LatLng(centerLat, centerLng);

      final latZoom = _getZoomLevel(maxLat - minLat);
      final lngZoom = _getZoomLevel(maxLng - minLng);
      final zoom = min(latZoom, lngZoom);

      _animatedMapMove(center, zoom);
    }

    // await _fetchNearbyPlaces();
    _updateMarkers();
  }

  double _getZoomLevel(double delta) {
    if (delta == 0) return 15;
    return (log(360 / delta) / ln2).floor().toDouble();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  String _getNextOpenTime(List<dynamic> timings) {
    final now = DateTime.now();
    for (var timing in timings) {
      final openTime = _parseTime(timing['open_time']);
      if (openTime.isAfter(now)) {
        return timing['open_time'];
      }
    }
    return timings[0]['open_time']; // Return first timing if all passed
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  // Future<void> _fetchNearbyPlaces() async {
  //   await Future.delayed(Duration(seconds: 1));

  //   final random = Random();
  //   final dummyPlaces = [
  //     {'name': 'Central Park', 'type': 'Park'},
  //     {'name': 'Times Square', 'type': 'Plaza'},
  //     {'name': 'Statue of Liberty', 'type': 'Monument'},
  //     {'name': 'Broadway Theater', 'type': 'Entertainment'},
  //     {'name': 'Metropolitan Museum', 'type': 'Museum'},
  //   ];

  //   _nearbyPlaces = List.generate(5, (index) {
  //     final place = dummyPlaces[random.nextInt(dummyPlaces.length)];
  //     return {
  //       'name': place['name'],
  //       'type': place['type'],
  //       'location': LatLng(
  //         40.7128 + (random.nextDouble() - 0.5) * 0.1,
  //         -74.0060 + (random.nextDouble() - 0.5) * 0.1,
  //       ),
  //     };
  //   });
  // }

  void _updateMarkers() {
    setState(() {
      _nearbyPlaceMarkers = _nearbyPlaces
          .map((place) => Marker(
                width: 80.0,
                height: 80.0,
                point: place['location'] as LatLng,
                child: Column(
                  children: [
                    Icon(Icons.place, color: Colors.orange),
                    Text(place['name'] as String,
                        style: TextStyle(fontSize: 10)),
                    Text(place['type'] as String,
                        style: TextStyle(fontSize: 8)),
                  ],
                ),
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text('Find Route'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.schedule),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GateScheduleScreen(gates: _gates),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(40.7128, -74.0060),
              initialZoom: 14,
              onMapReady: () {
                setState(() {
                  _mapInitialized = true;
                });
              },
            ),
            children: [
              openStreetMapTileLayer,
              RichAttributionWidget(
                popupInitialDisplayDuration: const Duration(seconds: 5),
                animationConfig: const ScaleRAWA(),
                showFlutterMapAttribution: false,
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                  const TextSourceAttribution(
                    'This attribution is the same throughout this app, except '
                    'where otherwise specified',
                    prependCopyright: false,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  ..._gateMarkers,
                  ..._nearbyPlaceMarkers,
                ],
              ),
              // PolylineLayer(
              //   polylines: [
              //     Polyline(
              //       points: _routePoints,
              //       color: Colors.blue,
              //       strokeWidth: 4.0,
              //     ),
              //   ],
              // ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _startController,
                      decoration: InputDecoration(labelText: 'Start'),
                    ),
                    TextField(
                      controller: _destinationController,
                      decoration: InputDecoration(labelText: 'End'),
                    ),
                    ElevatedButton(
                      onPressed: _mapInitialized ? _searchRoute : null,
                      child: Text('Search Route'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              height: 200,
              child: Card(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GateScheduleScreen(gates: _gates),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gates:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _gates.length,
                            itemBuilder: (context, index) {
                              final gate = _gates[index];
                              return ListTile(
                                dense: true, // Makes the ListTile more compact
                                title: Text(
                                  gate['gate_name'] as String,
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  'Next: ${_getNextOpenTime(gate['timing'])}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const FloatingMenuButton()
        ],
      ),
    );
  }
}
