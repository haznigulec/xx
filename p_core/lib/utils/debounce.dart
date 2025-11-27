// This map will track all your pending function calls
import 'dart:async';

Map<Function, Timer> _timeouts = <Function, Timer>{};

void debounce(Duration timeout, Function target, [List<Object> arguments = const <Object>[]]) {
  if (_timeouts.containsKey(target)) {
    _timeouts[target]!.cancel();
  }

  final Timer timer = Timer(timeout, () {
    Function.apply(target, arguments);
  });

  _timeouts[target] = timer;
}
