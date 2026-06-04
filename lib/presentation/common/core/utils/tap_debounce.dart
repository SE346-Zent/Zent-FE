import 'package:flutter/material.dart';

/// A lightweight, global tap-throttle singleton.
///
/// Any `VoidCallback?` can be wrapped with [TapDebounce.call] to ensure it
/// fires **at most once** within the [_kMinInterval] window.
///
/// Usage:
/// ```dart
/// onPressed: TapDebounce.call(() => doSomething()),
/// onTap: TapDebounce.call(() => context.push('/next')),
/// ```
class TapDebounce {
  TapDebounce._();

  static const Duration _kMinInterval = Duration(milliseconds: 500);
  static DateTime _lastTap = DateTime(2000);

  /// Wraps [callback] so it only executes if more than [_kMinInterval] has
  /// elapsed since the last accepted tap.
  /// Returns `null` when [callback] is `null` (keeping disabled-button
  /// semantics intact).
  static void Function()? call(void Function()? callback) {
    if (callback == null) return null;
    return () {
      final now = DateTime.now();
      final diff = now.difference(_lastTap);
      if (diff < _kMinInterval) {
        debugPrint(
          "[TapDebounce] Throttled tap callback. Elapsed since last accepted tap: ${diff.inMilliseconds}ms (min required: ${_kMinInterval.inMilliseconds}ms)",
        );
        return;
      }
      debugPrint(
        "[TapDebounce] Allowing tap callback execution. Elapsed since last accepted tap: ${diff.inMilliseconds}ms",
      );
      _lastTap = now;
      try {
        callback();
      } catch (e, stack) {
        debugPrint("[TapDebounce] Error executing callback: $e\n$stack");
        rethrow;
      }
    };
  }
}

/// Drop-in replacement for [InkWell] that throttles [onTap] through
/// [TapDebounce] to prevent rapid multi-tap issues.
///
/// All other InkWell parameters are forwarded unchanged.
class ThrottledInkWell extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final ShapeBorder? customBorder;

  const ThrottledInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.customBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: TapDebounce.call(onTap),
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
      customBorder: customBorder,
      child: child,
    );
  }
}

/// Drop-in replacement for [GestureDetector] that throttles [onTap] through
/// [TapDebounce] to prevent rapid multi-tap issues on round buttons,
/// icon buttons, bell notifications, avatar taps, etc.
///
/// All other GestureDetector parameters are forwarded unchanged so
/// animation-driven press states (onTapDown/Up/Cancel) continue to work.
class ThrottledGestureDetector extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;
  final HitTestBehavior? behavior;

  // ---- Pass-through gesture callbacks (not throttled) ----
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final void Function(TapDownDetails)? onDoubleTapDown;
  final void Function()? onDoubleTapCancel;
  final void Function(LongPressStartDetails)? onLongPressStart;
  final void Function(LongPressEndDetails)? onLongPressEnd;
  final void Function()? onLongPressUp;
  final void Function(DragStartDetails)? onVerticalDragStart;
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;
  final void Function(DragEndDetails)? onVerticalDragEnd;
  final void Function(DragStartDetails)? onHorizontalDragStart;
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final void Function(DragEndDetails)? onHorizontalDragEnd;
  final void Function(DragStartDetails)? onPanStart;
  final void Function(DragUpdateDetails)? onPanUpdate;
  final void Function(DragEndDetails)? onPanEnd;
  final void Function(ScaleStartDetails)? onScaleStart;
  final void Function(ScaleUpdateDetails)? onScaleUpdate;
  final void Function(ScaleEndDetails)? onScaleEnd;

  const ThrottledGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.behavior,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressUp,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: TapDebounce.call(onTap),
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      behavior: behavior,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onDoubleTapDown: onDoubleTapDown,
      onDoubleTapCancel: onDoubleTapCancel,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      onLongPressUp: onLongPressUp,
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      child: child,
    );
  }
}
