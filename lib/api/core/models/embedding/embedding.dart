import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'sub-models/data.dart';
import 'sub-models/usage.dart';

export 'sub-models/data.dart';
export 'sub-models/usage.dart';

@immutable
class OpenAIEmbeddingsModel {
  /// The data returned by the embeddings request.
  final List<OpenAIEmbeddingsDataModel> data;

  /// The model used to generate the embeddings.
  final String model;

  /// The usage of the embeddings, if any.
  final OpenAIEmbeddingsUsageModel? usage;

  @override
  int get hashCode => data.hashCode ^ model.hashCode ^ usage.hashCode;

  /// This class is used to represent an OpenAI embeddings request.
  const OpenAIEmbeddingsModel({
    required this.data,
    required this.model,
    required this.usage,
  });

  /// This method is used to convert a [Map<String, dynamic>] object to a [OpenAIEmbeddingsModel] object.
  factory OpenAIEmbeddingsModel.fromMap(Map<String, dynamic> map) {
    return OpenAIEmbeddingsModel(
      data: List<OpenAIEmbeddingsDataModel>.from(
        map['data'].map<OpenAIEmbeddingsDataModel>(
          (x) => OpenAIEmbeddingsDataModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      model: map['model'] as String,
      usage: OpenAIEmbeddingsUsageModel.fromMap(
        map['usage'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  bool operator ==(covariant OpenAIEmbeddingsModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.data, data) &&
        other.model == model &&
        other.usage == usage;
  }

  @override
  String toString() =>
      'OpenAIEmbeddingsModel(data: $data, model: $model, usage: $usage)';
}
