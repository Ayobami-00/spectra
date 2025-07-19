import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String baseWsUrl;

  WebSocketService(this.baseWsUrl);

  Stream<dynamic>? get stream => _channel?.stream;

  void connect(String sessionId) {
    final wsUrl = Uri.parse('$baseWsUrl/public/session/$sessionId');
    _channel = WebSocketChannel.connect(wsUrl);
  }

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  bool get isConnected => _channel != null;
}
