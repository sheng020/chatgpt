import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void WidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final WidgetSizeChange? onChange;

  MeasureSizeRenderObject({this.onChange});

  @override
  void performLayout() {
    super.performLayout();
    Size? newSize = child?.size;

    if (oldSize == newSize) return;
    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (newSize != null) {
        onChange?.call(newSize);
      }
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final WidgetSizeChange? onChange;

  MeasureSize({
    this.onChange,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange: onChange);
  }
}
