import 'dart:async';
import 'package:p_core/utils/log_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:rxdart/rxdart.dart';

class WebSocketClient {
  final String url;
  WebSocketChannel? _channel;
  final BehaviorSubject<String> _messages = BehaviorSubject<String>();
  Stream<String> get messages => _messages.stream;

  Timer? _reconnectTimer;
  int _retrySeconds = 1;
  bool _manuallyDisconnected = false;
  bool _connected = false;

  WebSocketClient(this.url);

  void connect() {
    _manuallyDisconnected = false;
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _connected = true;
    _channel!.stream.listen(
      (data) {
        _messages.add(data);
      },
      onDone: _handleDisconnect,
      onError: (error) => _handleDisconnect(),
    );
  }

  void _handleDisconnect() {
    if (_manuallyDisconnected) return;
    _connected = false;
    _channel = null;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: _retrySeconds), () {
      connect();
      _retrySeconds = (_retrySeconds * 2).clamp(1, 64); // exponential backoff
    });
    LogUtils.pLog('WEBSOCKET::$url::Reconnecting in $_retrySeconds seconds...');
  }

  void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void disconnect() {
    _connected = false;
    _manuallyDisconnected = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
    _messages.close();
  }

  bool get isConnected => _connected;
}
