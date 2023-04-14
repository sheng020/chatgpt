// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DEFAULT_SERVER')
  static const DEFAULT_SERVER = _Env.DEFAULT_SERVER;
  @EnviedField(varName: 'DEFAULT_KEY')
  static const DEFAULT_KEY = _Env.DEFAULT_KEY;
}
