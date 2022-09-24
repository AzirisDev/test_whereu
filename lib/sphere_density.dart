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
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: this.widget.diameter,
            height: this.widget.diameter,
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.elliptical(200, 20)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.blue.withOpacity(0.8),
                    Colors.blue.withOpacity(0.85),
                    Colors.blue.withOpacity(0.9),
                    Colors.blue.withOpacity(0.95),
                    Colors.blue,
                  ],
                )),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: this.widget.diameter,
            height: this.widget.diameter,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.elliptical(200, 20)),
                border: Border.all(color: Colors.black)),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: this.widget.diameter,
            height: this.widget.diameter/10,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.elliptical(200, 20)),
                border: Border.all(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
