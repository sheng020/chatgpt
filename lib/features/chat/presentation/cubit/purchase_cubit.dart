import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';
import 'package:flutter_chatgpt_clone/features/global/const/constants.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit()
      : super(PurchaseState(isPurchased: false, leftCount: getLeftCount()));

  Future<void> checkIsPurchase() async {
    var isPurchased = await NativeChannel.isPurchased();
    emit(PurchaseState(isPurchased: isPurchased, leftCount: getLeftCount()));
  }

  Future<void> loadRewardAdIfAvaliable() async {
    bool isPurchase = await NativeChannel.isPurchased();
    if (!isPurchase) {
      NativeChannel.loadRewardAd();
    }
  }

  Future<void> openSubscriptionPage() async {
    bool isPurchase = await NativeChannel.openSubscriptionPage();
    emit(PurchaseState(isPurchased: isPurchase, leftCount: getLeftCount()));
  }
}

class PurchaseState extends Equatable {
  final bool isPurchased;
  final int leftCount;

  PurchaseState({required this.isPurchased, required this.leftCount});

  @override
  List<Object?> get props => [isPurchased, leftCount];
}
