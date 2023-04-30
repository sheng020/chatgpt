import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'data.g.dart';

@immutable
@JsonSerializable()
class OpenAIImageData {
  /// The URL of the image.
  final String url;

  @override
  int get hashCode => url.hashCode;

  /// This class is used to represent an OpenAI image data.
  const OpenAIImageData({
    required this.url,
  });

  /// This method is used to convert a [Map<String, dynamic>] object to a [OpenAIImageData] object.
  factory OpenAIImageData.fromMap(Map<String, dynamic> json) {
    return OpenAIImageData(url: json['url']);
  }

  factory OpenAIImageData.fromJson(Map<String, dynamic> json) =>
      _$OpenAIImageDataFromJson(json);
  Map<String, dynamic> toJson() => _$OpenAIImageDataToJson(this);

  @override
  bool operator ==(covariant OpenAIImageData other) {
    if (identical(this, other)) return true;

    return other.url == url;
  }

  @override
  String toString() => 'OpenAIImageData(url: $url)';
}
