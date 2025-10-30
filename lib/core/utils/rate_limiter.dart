class TokenBucketRateLimiter {
  TokenBucketRateLimiter({
    required this.maxTokens,
    required this.refillRate,
  })  : _tokens = maxTokens.toDouble(),
        _lastRefill = DateTime.now();

  final int maxTokens;
  final Duration refillRate;
  double _tokens;
  DateTime _lastRefill;

  Future<void> acquire() async {
    _refill();

    if (_tokens >= 1) {
      _tokens -= 1;
      return;
    }

    // Wait until we have a token
    final waitTime = refillRate - DateTime.now().difference(_lastRefill);
    if (waitTime.isNegative) {
      _refill();
      _tokens -= 1;
      return;
    }

    await Future.delayed(waitTime);
    _refill();
    _tokens -= 1;
  }

  void _refill() {
    final now = DateTime.now();
    final timeSinceLastRefill = now.difference(_lastRefill);

    if (timeSinceLastRefill >= refillRate) {
      final tokensToAdd =
          (timeSinceLastRefill.inMilliseconds / refillRate.inMilliseconds)
              .floor();
      _tokens = (_tokens + tokensToAdd).clamp(0, maxTokens.toDouble());
      _lastRefill = now;
    }
  }
}
