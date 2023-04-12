
import '../../models/image/enum.dart';
import '../entity/interfaces/enpoint.dart';
import 'interfaces/create.dart';
import 'interfaces/edit.dart';
import 'interfaces/variations.dart';

abstract class OpenAIImagesBase
    implements
        EndpointInterface,
        CreateInterface,
        EditInterface,
        VariationInterface {}

extension SizeToStingExtension on OpenAIImageSize {
  String get value {
    switch (this) {
      case OpenAIImageSize.size256:
        return "256x256";
      case OpenAIImageSize.size512:
        return "512x512";
      case OpenAIImageSize.size1024:
        return "1024x1024";
    }
  }
}

extension ResponseFormatToStingExtension on OpenAIResponseFormat {
  String get value {
    switch (this) {
      case OpenAIResponseFormat.url:
        return "url";
      case OpenAIResponseFormat.b64Json:
        return "b64_json";
    }
  }
}
