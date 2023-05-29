import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/features/global/channel/native_channel.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit() : super(PurchaseState(isPurchased: false));

  Future<void> checkIsPurchase() async {
    var isPurchased = await NativeChannel.isPurchased();
    emit(PurchaseState(isPurchased: isPurchased));
  }

  Future<void> loadRewardAdIfAvaliable() async {
    bool isPurchase = await NativeChannel.isPurchased();
    if (!isPurchase) {
      NativeChannel.loadRewardAd();
    }
  }
}

class PurchaseState extends Equatable {
  final bool isPurchased;

  PurchaseState({required this.isPurchased});

  @override
  List<Object?> get props => [isPurchased];
}
