import 'dart:async';

typedef Lazy<T> = T Function();

/// Represents a value of one of two possible types.
/// Instances of [Result] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
sealed class Result<L, R> {
  const Result();

  /// Represents the left side of [Result] class which by convention is a "Failure".
  bool get isLeft => this is Left<L, R>;

  /// Represents the right side of [Result] class which by convention is a "Success"
  bool get isRight => this is Right<L, R>;

  /// Get [Left] value, may throw an exception when the value is [Right]
  L get left => this.fold<L>(
          (value) => value,
          (right) => throw Exception(
          'Illegal use. You should check isLeft before calling'));

  /// Get [Right] value, may throw an exception when the value is [Left]
  R get right => this.fold<R>(
          (left) => throw Exception(
          'Illegal use. You should check isRight before calling'),
          (value) => value);

  /// Transform values of [Left] and [Right]
  Result<TL, TR> either<TL, TR>(
      TL Function(L left) fnL, TR Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Result<L, TR> then<TR>(Result<L, TR> Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Future<Result<L, TR>> thenAsync<TR>(
      FutureOr<Result<L, TR>> Function(R right) fnR);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Result<TL, R> thenLeft<TL>(Result<TL, R> Function(L left) fnL);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Future<Result<TL, R>> thenLeftAsync<TL>(
      FutureOr<Result<TL, R>> Function(L left) fnL);

  /// Transform value of [Right]
  Result<L, TR> map<TR>(TR Function(R right) fnR);

  /// Transform value of [Left]
  Result<TL, R> mapLeft<TL>(TL Function(L left) fnL);

  /// Transform value of [Right]
  Future<Result<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR);

  /// Transform value of [Left]
  Future<Result<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL);

  /// Fold [Left] and [Right] into the value of one type
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  /// Swap [Left] and [Right]
  Result<R, L> swap() => fold((left) => Right(left), (right) => Left(right));

  /// Constructs a new [Result] from a function that might throw
  static Result<L, R> tryCatch<L, R, Err extends Object>(
      L Function(Err err) onError, R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(onError(e));
    }
  }

  /// Constructs a new [Result] from a function that might throw
  /// 
  /// simplified version of [Result.tryCatch]
  ///
  /// ```dart
  /// final fileOrError = Result.tryExcept<FileError>(() => /* maybe throw */);
  /// ```
  static Result<Err, R> tryExcept<Err extends Object, R>(R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(e);
    }
  }

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Result<L, R> cond<L, R>(bool test, L leftValue, R rightValue) =>
      test ? Right(rightValue) : Left(leftValue);

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Result<L, R> condLazy<L, R>(
      bool test, Lazy<L> leftValue, Lazy<R> rightValue) =>
      test ? Right(rightValue()) : Left(leftValue());

  @override
  bool operator ==(Object obj) {
    return this.fold(
          (left) => obj is Left && left == obj.value,
          (right) => obj is Right && right == obj.value,
    );
  }

  @override
  int get hashCode => fold((left) => left.hashCode, (right) => right.hashCode);
}

/// Used for "failure"
class Left<L, R> extends Result<L, R> {
  final L value;

  const Left(this.value);

  @override
  Result<TL, TR> either<TL, TR>(
      TL Function(L left) fnL, TR Function(R right) fnR) {
    return Left<TL, TR>(fnL(value));
  }

  @override
  Result<L, TR> then<TR>(Result<L, TR> Function(R right) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Future<Result<L, TR>> thenAsync<TR>(
      FutureOr<Result<L, TR>> Function(R right) fnR) {
    return Future.value(Left<L, TR>(value));
  }

  @override
  Result<TL, R> thenLeft<TL>(Result<TL, R> Function(L left) fnL) {
    return fnL(value);
  }

  @override
  Future<Result<TL, R>> thenLeftAsync<TL>(
      FutureOr<Result<TL, R>> Function(L left) fnL) {
    return Future.value(fnL(value));
  }

  @override
  Result<L, TR> map<TR>(TR Function(R right) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Result<TL, R> mapLeft<TL>(TL Function(L left) fnL) {
    return Left<TL, R>(fnL(value));
  }

  @override
  Future<Result<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) {
    return Future.value(Left<L, TR>(value));
  }

  @override
  Future<Result<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) {
    return Future.value(fnL(value)).then((value) => Left<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnL(value);
  }
}

/// Used for "success"
class Right<L, R> extends Result<L, R> {
  final R value;

  const Right(this.value);

  @override
  Result<TL, TR> either<TL, TR>(
      TL Function(L left) fnL, TR Function(R right) fnR) {
    return Right<TL, TR>(fnR(value));
  }

  @override
  Result<L, TR> then<TR>(Result<L, TR> Function(R right) fnR) {
    return fnR(value);
  }

  @override
  Future<Result<L, TR>> thenAsync<TR>(
      FutureOr<Result<L, TR>> Function(R right) fnR) {
    return Future.value(fnR(value));
  }

  @override
  Result<TL, R> thenLeft<TL>(Result<TL, R> Function(L left) fnL) {
    return Right<TL, R>(value);
  }

  @override
  Future<Result<TL, R>> thenLeftAsync<TL>(
      FutureOr<Result<TL, R>> Function(L left) fnL) {
    return Future.value(Right<TL, R>(value));
  }

  @override
  Result<L, TR> map<TR>(TR Function(R right) fnR) {
    return Right<L, TR>(fnR(value));
  }

  @override
  Result<TL, R> mapLeft<TL>(TL Function(L left) fnL) {
    return Right<TL, R>(value);
  }

  @override
  Future<Result<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) {
    return Future.value(fnR(value)).then((value) => Right<L, TR>(value));
  }

  @override
  Future<Result<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) {
    return Future.value(Right<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnR(value);
  }
}
