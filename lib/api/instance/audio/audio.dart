
import 'dart:io';

import '../../core/base/audio/audio.dart';
import '../../core/builder/base_api_url.dart';
import '../../core/models/audio/audio.dart';
import '../../core/networking/client.dart';

class OpenAIAudio implements OpenAIAudioBase {
  @override
  String get endpoint => "/audio";

  @override
  Future<OpenAIAudioModel> createTranscription({
    required File file,
    required String model,
    String? prompt,
    String? responseFormat,
    double? temperature,
    String? laungage,
  }) async {
    return await OpenAINetworkingClient.fileUpload(
      file: file,
      to: BaseApiUrlBuilder.build(endpoint + "/transcriptions"),
      body: {
        "model": model,
        if (prompt != null) "prompt": prompt,
        if (responseFormat != null) "response_format": responseFormat,
        if (temperature != null) "temperature": temperature.toString(),
        if (laungage != null) "language": laungage,
      },
      onSuccess: (Map<String, dynamic> response) {
        return OpenAIAudioModel.fromMap(response);
      },
    );
  }

  @override
  Future<OpenAIAudioModel> createTranslation({
    required File file,
    required String model,
    String? prompt,
    String? responseFormat,
    double? temperature,
  }) async {
    return await OpenAINetworkingClient.fileUpload(
      file: file,
      to: BaseApiUrlBuilder.build(endpoint + "/translations"),
      body: {
        "model": model,
        if (prompt != null) "prompt": prompt,
        if (responseFormat != null) "response_format": responseFormat,
        if (temperature != null) "temperature": temperature.toString(),
      },
      onSuccess: (Map<String, dynamic> response) {
        return OpenAIAudioModel.fromMap(response);
      },
    );
  }
}
