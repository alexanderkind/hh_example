enum Level {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
  nothing,
}

mixin Logs {
  Future<void> d(message, [error, StackTrace? stackTrace]);

  Future<void> e(message, [error, StackTrace? stackTrace]);

  Future<void> i(message, [error, StackTrace? stackTrace]);

  Future<void> t(message, [error, StackTrace? stackTrace]);

  Future<void> w(message, [error, StackTrace? stackTrace]);

  Future<void> f(message, [error, StackTrace? stackTrace]);
}
