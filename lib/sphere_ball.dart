import 'package:flutter/cupertino.dart';
import 'package:flutter_gmaps/sphere_density.dart';


class SphereBall extends StatefulWidget {
  const SphereBall({Key key}) : super(key: key);

  @override
  _SphereBallState createState() => _SphereBallState();
}

class _SphereBallState extends State<SphereBall> {
  static const lightSource = Offset(0, -0.75);

  @override
  Widget build(BuildContext context) {
    final size = Size.square(MediaQuery.of(context).size.shortestSide / 5);

    return SphereDensity(
        lightSource: lightSource,
        diameter: size.shortestSide
    );
  }
}