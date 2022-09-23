import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SphereDensity extends StatefulWidget {
  final double diameter;
  final Offset lightSource;
  const SphereDensity({Key key, this.diameter, this.lightSource}) : super(key: key);

  @override
  _SphereDensityState createState() => _SphereDensityState();
}

class _SphereDensityState extends State<SphereDensity> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.diameter,
      height: this.widget.diameter,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5),
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment(this.widget.lightSource.dx, this.widget.lightSource.dy),
          colors: [Colors.white, Colors.blue.withOpacity(0.5)],
        ),

      ),
    );

  }
}