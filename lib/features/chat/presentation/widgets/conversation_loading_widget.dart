import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class ConversationLoadingWidget extends StatelessWidget {
  const ConversationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      colors: _kDefaultRainbowColors,
      indicatorType: Indicator.ballPulseSync,
      strokeWidth: 1,
      pause: false,
      // pathBackgroundColor: Colors.black45,
    );
  }
}
