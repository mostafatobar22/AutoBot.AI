abstract class ObdTransport {
  bool get isConnected;

  Future<void> connect({required String host, required int port});
  Future<void> disconnect();

  /// Send raw text to device, return the full raw response.
  /// For ELM: usually command ends with \r and response ends with '>' prompt.
  Future<String> sendRaw(String command);
}