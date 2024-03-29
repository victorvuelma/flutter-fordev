import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  final _navigateTo = RxnString();

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  GetxSplashPresenter({
    required this.loadCurrentAccount,
  });

  @override
  Future<void> loadAccount({
    int durationInSeconds = 1,
  }) async {
    try {
      final account = await loadCurrentAccount.load();

      await Future.delayed(Duration(seconds: durationInSeconds));

      _navigateTo.value = account == null ? '/login' : '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }
}
