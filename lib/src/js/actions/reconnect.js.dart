part of '../wagmi.js.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/reconnect)
@JS()
extension type JSReconnectParameters._(JSObject _) implements JSObject {
  external JSReconnectParameters({
    JSAny? connector,
  });
  external JSAny? connector;
}
// JSReconnectReturnType
@JS()
extension type JSReconnectReturnType(JSObject _) implements JSObject {
  external JSArray<JSObject>? connections;
  ReconnectReturnType get toDart {
    // convert this to dart object
    final connections = this.connections;
    if (connections == null || connections.toDart.isEmpty) {
      return ReconnectReturnType(connections: []);
    }
    
    try {
      final connectionList = connections.toDart.map((log) {
        try {
          final sMap = log.toMap(deep: false);
          // Safely access and convert the connector property
          final connectorObj = sMap['connector'];
          if (connectorObj != null && connectorObj is JSObject) {
            sMap['connector'] = connectorObj.toMap(deep: false);
          }
          return sMap;
        } catch (e) {
          // If conversion fails, return minimal valid structure
          return <String, dynamic>{};
        }
      }).toList();
      
      // Filter out empty maps and convert to Connection objects
      final validConnections = connectionList
          .where((map) => map.isNotEmpty)
          .map((map) {
            try {
              return Connection.fromJson(map);
            } catch (e) {
              return null;
            }
          })
          .whereType<Connection>()
          .toList();
      
      return ReconnectReturnType(connections: validConnections);
    } catch (e) {
      // If all else fails, return empty connections
      return ReconnectReturnType(connections: []);
    }
  }
}
@JS()
extension type JSReconnectErrorType(JSObject _) implements JSObject {}
