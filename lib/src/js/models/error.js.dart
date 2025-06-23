part of '../wagmi.js.dart';

/// Generic JSError
@JS()
extension type JSError._(JSObject _) implements JSObject {
  /// Get the error message
  external String? get message;

  /// Get the error message
  external String? get name;

  external JSArray<JSString>? get metaMessages;
  external JSString? get shortMessage;
  external JSString? get version;
  external JSError? get cause;
  external JSString? get docsPath;

  WagmiError get toDart => WagmiError(
        message: message,
        name:
            WagmiErrors.values.firstWhereOrNull((value) => value.name == name),
        metaMessages: metaMessages?.toDart
            .map(
              (message) => message.toDart,
            )
            .toList(),
        shortMessage: shortMessage?.toDart,
        version: version?.toDart,
        cause: cause?.toDart,
        docsPath: docsPath?.toDart,
        details: _safeToMap(),
      );
  
  Map<String, dynamic> _safeToMap() {
    try {
      return toMap();
    } catch (_) {
      // If toMap fails (e.g., hasOwnProperty not available), 
      // return a map with basic error info
      return {
        'message': message,
        'name': name,
        'shortMessage': shortMessage,
      };
    }
  }
}
