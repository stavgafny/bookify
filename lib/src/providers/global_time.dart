class GlobalTime {
  static Duration get _syncDeviceMiliseconds {
    return Duration(
      milliseconds:
          (Duration.millisecondsPerSecond - DateTime.now().millisecond) %
              Duration.millisecondsPerSecond,
    );
  }

  static Stream<void> get onEverySecond async* {
    // Sync to device time
    await Future.delayed(_syncDeviceMiliseconds);

    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield null;
    }
  }
}
