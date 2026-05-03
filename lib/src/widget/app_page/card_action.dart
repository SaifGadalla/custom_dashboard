import 'dart:async';

class CardAction<T> {
  CardAction({
    required this.label,
    required this.onTap,
    this.isEnabled,
  });
  final String Function(T) label;
  final FutureOr<void> Function(T)? onTap;
  final bool Function(T)? isEnabled;
}
