abstract class SplashPresenter {
  Stream<String?> get navigateToStream;

  Future<void> loadAccount({int durationInSeconds});
}
