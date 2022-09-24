import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gmaps/directions_model.dart';
import 'package:flutter_gmaps/models/object_model.dart';
import 'package:flutter_gmaps/sphere_ball.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/lists_model.dart';

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
    initLists();
    super.initState();
  }

  void initLists() async {
    await setUpList();
    setupMarker();
  }

  CameraPosition _initialCameraPosition;

  GoogleMapController _googleMapController;
  List<Marker> locations;
  Uint8List sphereBytes;
  Directions _info;
  List<Marker> _markers = [];
  List<Marker> _newMarkers = [];
  bool isVisible = true;
  bool showInfo = false;
  ListsModel listsModel = ListsModel();
  double zoom = 11.5;

  double ratio = 1;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<void> fetchMarker(
    ObjectModel element,
    String i,
  ) async {
    Marker marker2 = Marker(
        anchor: Offset(0.5, 0.8),
        markerId: MarkerId(i.toString() + "sphere" + element.identifier),
        infoWindow: const InfoWindow(
          title: '',
        ),
        icon: BitmapDescriptor.fromBytes(sphereBytes),
        position: LatLng(
          double.parse(element.latitude),
          double.parse(element.longitude),
        ),
        onTap: () {
          setState(() {
            showInfo = !showInfo;
          });
        });

    Marker marker1 = Marker(
      markerId: MarkerId(i.toString() + 'boy' + element.identifier),
      infoWindow: const InfoWindow(title: ''),
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/${element.activity}.png', 150)),
      position: LatLng(
        double.parse(element.latitude),
        double.parse(element.longitude),
      ),
      anchor: Offset(0.5, 1),
    );

    _newMarkers.add(marker1);
    _newMarkers.add(marker2);
  }

  setupMarker() async {
    _newMarkers.clear();
    await Future.delayed(Duration(milliseconds: 500));
    await _capturePng();
    setState(() {
      isVisible = false;
    });

    for (int i = 0; i < listsModel.cases.length; i++) {
      for (int j = 0; j < listsModel.cases[i].length; j++) {
        await fetchMarker(listsModel.cases[i][j], i.toString() + j.toString());
      }
    }

    setState(() {
      _markers.addAll(_newMarkers);
    });
  }

  final containerKey = GlobalKey();

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = containerKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();

      sphereBytes = pngBytes;
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
            onCameraMove: (cameraMove) {
              if ((cameraMove.zoom - zoom).abs() > 0.001) {
                setupMarker();
              }
              //zoom out
              if (cameraMove.zoom - zoom > 0.001) {
                setState(() {
                  ratio += 0.01;
                  if (ratio >= 1) {
                    ratio = 1;
                  }
                  zoom = cameraMove.zoom;
                });
                //zoom in
              } else if (cameraMove.zoom - zoom < 0) {
                setState(() {
                  ratio -= 0.01;
                  if (ratio <= 0.1) {
                    ratio = 0.1;
                  }
                  zoom = cameraMove.zoom;
                });
              }
            },
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
          SizedBox(
              height: 80 * ratio,
              width: 80 * ratio,
              child: RepaintBoundary(key: containerKey, child: SphereBall())),
          if (showInfo)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(child: Text("Name: Meiirbek")),
                    Expanded(child: Text("Floor: 7")),
                  ],
                ),
              ),
            )
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

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/localization.json');
  }

  Future<void> setUpList() async {
    String s = await loadAsset();
    Map<String, dynamic> map = await readJsonFile(s);

    int i = 1;
    listsModel.cases.forEach((element) {
      List<ObjectModel> list =
          (map['dev$i'] as List<dynamic>).map((e) => ObjectModel.fromJson(e)).toList();
      element.addAll(list);
      i++;
    });

    _initialCameraPosition = CameraPosition(
      target: LatLng(
        double.parse(listsModel.cases[0][0].latitude),
        double.parse(listsModel.cases[0][0].longitude),
      ),
      tilt: 50,
      zoom: 11.5,
    );

    print("done with fetching");
  }

  Future<Map<String, dynamic>> readJsonFile(String input) async {
    var map = jsonDecode(input);
    return map;
  }
}
