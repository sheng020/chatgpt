import 'package:meta/meta.dart';

import '../core/base/openai_client/base.dart';
import '../core/builder/headers.dart';
import '../core/exceptions/api_key_not_set.dart';
import '../core/utils/logger.dart';
import 'audio/audio.dart';
import 'chat/chat.dart';
import 'completion/completion.dart';
import 'edits/edits.dart';
import 'embedding/embedding.dart';
import 'files/files.dart';
import 'fine_tunes/fine_tunes.dart';
import 'images/images.dart';
import 'model/model.dart';
import 'moderations/moderations.dart';

/// The main class of the package. It is a singleton class, so you can only have one instance of it.
/// You can also access the instance by calling the [OpenAI.instance] getter.
/// ```dart
/// final openai = OpenAI.instance;
/// ```
@immutable
class OpenAI extends OpenAIClientBase {
  /// The singleton instance of [OpenAI].
  static final OpenAI _instance = OpenAI._();

  /// The API key used to authenticate the requests.
  static String? _internalApiKey;

  /// The singleton instance of [OpenAI], make sure to call the [OpenAI.initialize] method before accessing [instance], otherwise it will throw an [Exception].
  /// A [MissingApiKeyException] will be thrown, if the API key is not set.
  static OpenAI get instance {
    if (_internalApiKey == null) {
      throw MissingApiKeyException("""
      You must set the api key before accessing the instance of this class.
      Example:
      OpenAI.apiKey = "Your API Key";
      """);
    }

    return _instance;
  }

  static String baseUrl = "https://api.openai.com";

  /// This is used to initialize the [OpenAI] instance, by providing the API key.
  /// All the requests will be authenticated using this API key.
  /// ```dart
  /// OpenAI.apiKey = "YOUR_API_KEY";
  /// ```
  static set apiKey(String apiKey) {
    HeadersBuilder.apiKey = apiKey;
    _internalApiKey = apiKey;
  }

  /// If you have multiple organizations, you can set it's id with this.
  /// once this is set, it will be used in all the requests to the OpenAI API.
  /// Example:
  /// ```dart
  /// OpenAI.organization = "YOUR_ORGANIZATION_ID";
  /// ```
  static set organization(String? organizationId) {
    HeadersBuilder.organization = organizationId;
  }

  static String? get organization => HeadersBuilder.organization;

  /// This controls whether to log steps inside the process of making a request, this helps debugging and pointing where something went wrong.
  /// This uses  [dart:developer] internally, so it will show anyway only while debugging code.
  ///
  /// By default it is set to [true].
  ///
  /// Example:
  /// ```dart
  /// OpenAI.instance.showLogs = false;
  /// ```
  static set showLogs(bool newValue) {
    OpenAILogger.isActive = newValue;
  }

  /// The [OpenAIModel] instance, used to access the model endpoints.
  /// Please, refer to the Models page from the official OpenAI documentation website in order to know what models are available and what's the use case of every model.
  OpenAIModel get model => OpenAIModel();

  /// The [OpenAICompletion] instance, used to access the completion endpoints.
  OpenAICompletion get completion => OpenAICompletion();

  /// The [OpenAIEdits] instance, used to access the edits endpoints.
  OpenAIEdits get edit => OpenAIEdits();

  /// The [OpenAIImages] instance, used to access the images endpoints.
  OpenAIImages get image => OpenAIImages();

  /// The [OpenAIEmbedding] instance, used to access the embeddings endpoints.
  OpenAIEmbedding get embedding => OpenAIEmbedding();

  /// The [OpenAIFiles] instance, used to access the files endpoints.
  OpenAIFiles get file => OpenAIFiles();

  /// The [OpenAIFineTunes] instance, used to access the fine-tunes endpoints.
  OpenAIFineTunes get fineTune => OpenAIFineTunes();

  /// The [OpenAIModeration] instance, used to access the moderation endpoints.
  OpenAIModeration get moderation => OpenAIModeration();

  /// The [OpenAIChat] instance, used to access the chat endpoints.
  OpenAIChat get chat => OpenAIChat();

  /// The [OpenAIAudio] instance, used to access the audio endpoints.
  OpenAIAudio get audio => OpenAIAudio();

  /// The constructor of [OpenAI]. It is private, so you can only access the instance by calling the [OpenAI.instance] getter.
  OpenAI._();
}
