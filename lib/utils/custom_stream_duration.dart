/// this is a rewrite of StreamDuration from package:slide_countdown, to allow
/// counting up from `duration` to infinity, which is not supported yet.

import 'dart:async';

import 'package:slide_countdown/slide_countdown.dart';

class CustomStreamDuration extends StreamDuration {
  // The reason we use `2` in the variable name is that we don't want to
  // override the old variables, but we want to replace them entirely

  final StreamController<Duration> _streamController2 =
      StreamController<Duration>();
  late Duration _durationLeft2;
  bool isPlaying2 = false;

  @override
  Stream<Duration> get durationLeft => _streamController2.stream;
  StreamSubscription<Duration>? _streamSubscription2;

  final Duration duration2;
  final Function? onDone2;
  final bool countUp2;
  final bool autoPlay2;

  CustomStreamDuration(
    this.duration2, {
    countUp,
    onDone,
    autoPlay,
  })  : countUp2 = countUp ?? false,
        onDone2 = onDone,
        autoPlay2 = autoPlay ?? true,
        super(Duration.zero) {
    _durationLeft2 = duration2;
    if (duration2.inSeconds <= 0 && !countUp2) return;
    if (autoPlay2) {
      play();
      isPlaying2 = true;
    }
  }

  @override
  void play() {
    if (_streamController2.hasListener) return;
    if (countUp2) {
      _durationLeft2 += const Duration(seconds: 1);
    } else {
      _durationLeft2 -= const Duration(seconds: 1);
    }
    if (!_streamController2.isClosed) {
      _streamController2.add(_durationLeft2);
    }

    _streamSubscription2 =
        Stream<Duration>.periodic(const Duration(seconds: 1), (_) {
      if (!(_streamSubscription2?.isPaused ?? true)) {
        if (countUp2) {
          return _durationLeft2 += const Duration(seconds: 1);
        } else {
          return _durationLeft2 -= const Duration(seconds: 1);
        }
      }
      return Duration.zero;
    }).listen(
      (event) {
        if (_streamController2.isClosed) return;
        _streamController2.add(_durationLeft2);

        if (countUp2) {
          // count up never ends, like infinity
          // if (!infinity2) {
          //   if (_durationLeft2.isSameDuration(duration)) {
          //     dispose();
          //     Future.delayed(const Duration(seconds: 1), () {
          //       if (onDone2 != null) {
          //         onDone2!();
          //       }
          //     });
          //   }
          // }
        } else {
          if (_durationLeft2.inSeconds == 0) {
            dispose();
            Future.delayed(const Duration(seconds: 1), () {
              if (onDone2 != null) {
                onDone2!();
              }
            });
          }
        }
      },
    );
  }

  @override
  void change(Duration duration) {
    if (countUp2) {
      if (_durationLeft2 > duration) {
        dispose();
        Future.delayed(const Duration(seconds: 1), () {
          if (onDone2 != null) {
            onDone2!();
          }
        });
      } else {
        _durationLeft2 = duration;
      }
    } else {
      _durationLeft2 = duration;
    }
  }

  /// If you need override current duration
  /// add or subtract [_durationLeft2] with other duration
  /// & [countUp2] is true will automate add [_durationLeft2]
  /// & [countUp2] is false will automate subtract [_durationLeft2]
  @override
  void correct(Duration duration) {
    if (countUp2) {
      add(duration);
    } else {
      subtract(duration);
    }
  }

  @override
  void add(Duration duration) {
    _durationLeft2 += duration;
  }

  @override
  void subtract(Duration duration) {
    if (!countUp2 && _durationLeft2 <= duration) {
      _durationLeft2 = Duration.zero;
      dispose();
      Future.delayed(const Duration(seconds: 1), () {
        if (onDone2 != null) {
          onDone2!();
        }
      });
    } else {
      if (_durationLeft2 <= duration) {
        _durationLeft2 = Duration.zero;
        dispose();
        Future.delayed(const Duration(seconds: 1), () {
          if (onDone2 != null) {
            onDone2!();
          }
        });
      } else {
        _durationLeft2 -= duration;
      }
    }
  }

  @override
  Duration get remainingDuration => _durationLeft2;

  @override
  void pause() {
    _streamSubscription2?.pause();
  }

  @override
  void resume() {
    _streamSubscription2?.resume();
  }

  @override
  void dispose() {
    _streamSubscription2?.cancel();
    _streamController2.close();
  }
}
