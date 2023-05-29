import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';
import 'package:flutter_chatgpt_clone/injection_container.dart';

const LEFT_COUNT = "left_count";

const DEFAULT_LEFT_COUNT = 3;

int getLeftCount() {
  return box.read(LEFT_COUNT) ?? DEFAULT_LEFT_COUNT;
}

Future<int> consumeOneTime() async {
  var leftCount = getLeftCount();
  var isPurchased = await NativeChannel.isPurchased();
  if (!isPurchased) {
    leftCount--;
  }
  writeLeftCount(leftCount);
  return leftCount;
}

void writeLeftCount(int count) {
  box.write(LEFT_COUNT, count);
}
