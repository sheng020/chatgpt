import 'dart:io';

import '../../../models/image/enum.dart';
import '../../../models/image/variation/variation.dart';


abstract class VariationInterface {
  Future<OpenAIImageVariationModel> variation({
    required File image,
    int? n,
    OpenAIImageSize? size,
    OpenAIResponseFormat? responseFormat,
    String? user,
  });
}
