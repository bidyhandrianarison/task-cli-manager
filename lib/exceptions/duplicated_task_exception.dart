class DuplicatedTaskException implements Exception {
  final String message;

  DuplicatedTaskException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return 'DuplicatedTaskException: $message';
  }
}
