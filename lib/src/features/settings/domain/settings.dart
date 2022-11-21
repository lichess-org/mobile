enum BackgroundMode {
  dark,
  light,
  system;

  static BackgroundMode fromString(String str) {
    switch (str.toLowerCase()) {
      case 'dark':
        return BackgroundMode.dark;
      case 'light':
        return BackgroundMode.light;
      case 'system':
        return BackgroundMode.system;
      default:
        return BackgroundMode.system;
    }
  }
}
