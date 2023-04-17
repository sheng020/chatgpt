
import 'package:flutter/material.dart';

class CustomStandardFabLocation extends FloatingActionButtonLocation {

  final FloatingActionButtonLocation location;
  final double offsetX;    // X方向的偏移量
  final double offsetY;

  CustomStandardFabLocation({required this.location, required this.offsetX, required this.offsetY});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}