sealed class FeedbackState<T> {
  const FeedbackState();
}

class FeedbackNone<T> extends FeedbackState<T> {
  const FeedbackNone();
}

class FeedbackLoading<T> extends FeedbackState<T> {
  const FeedbackLoading();
}

class FeedbackError<T> extends FeedbackState<T> {
  final Object error;
  const FeedbackError(this.error);
}

class FeedbackReady<T> extends FeedbackState<T> {
  final T data;
  const FeedbackReady(this.data);
}
