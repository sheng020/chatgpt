import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'data.g.dart';

@immutable
@JsonSerializable()
class OpenAIVariationData {
  /// The url of the image.
  final String url;

  @override
  int get hashCode => url.hashCode;

  /// This class is used to represent an OpenAI image variation data.
  const OpenAIVariationData({
    required this.url,
  });

  /// This method is used to convert a [Map<String, dynamic>] object to a [OpenAIVariationData] object.
  factory OpenAIVariationData.fromMap(Map<String, dynamic> json) {
    return OpenAIVariationData(url: json['url']);
  }

  factory OpenAIVariationData.fromJson(Map<String, dynamic> json) =>
      _$OpenAIVariationDataFromJson(json);
  Map<String, dynamic> toJson() => _$OpenAIVariationDataToJson(this);

  @override
  String toString() => 'OpenAIVariationData(url: $url)';

  @override
  bool operator ==(covariant OpenAIVariationData other) {
    if (identical(this, other)) return true;

    return other.url == url;
  }
}
