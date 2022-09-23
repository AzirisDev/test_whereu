import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gmaps/directions_model.dart';
import 'package:flutter_gmaps/directions_repository.dart';
import 'package:flutter_gmaps/sphere_ball.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    setupMarker();
    super.initState();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    tilt: 50,
    zoom: 11.5,
  );

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _sphere;
  Uint8List sphereBytes;
  Directions _info;
  List<Marker> _markers = [];
  bool isVisible = true;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  setupMarker() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _capturePng();
      setState(() {
        isVisible = false;
      });
      _sphere = Marker(
        anchor: Offset(0.5, 0.8),
        markerId: const MarkerId('ID123'),
        infoWindow: const InfoWindow(title: 'Marker2'),
        icon: BitmapDescriptor.fromBytes(sphereBytes),
        position: LatLng(
          40.7435228393862,
          -74.006950753951,
        ),
      );

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _markers.add(_sphere);
      });
    });
    _origin = Marker(
        markerId: const MarkerId('ID'),
        infoWindow: const InfoWindow(title: 'Marker1'),
        icon: BitmapDescriptor.fromBytes(await getBytesFromAsset('assets/boy.png', 150)),
        position: LatLng(
          40.7435228393862,
          -74.006950753951,
        ),
        anchor: Offset(0.5, 1));

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _markers.add(_origin);
    });

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            40.7435228393862,
            -74.006950753951,
          ),
          tilt: 50,
          zoom: 30,
        ),
      ),
    );
  }

  final containerKey = GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = containerKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      sphereBytes = pngBytes;
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers.isNotEmpty ? Set.of(_markers) : {},
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                ),
            },
          ),
          if (isVisible)
            SizedBox(height: 100, child: RepaintBoundary(key: containerKey, child: SphereBall())),
        ],
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
}
