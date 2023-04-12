
import '../../../models/model/model.dart';

abstract class RetrieveInterface {
  Future<OpenAIModelModel> retrieve(String modelId);
}
