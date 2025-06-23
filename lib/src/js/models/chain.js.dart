part of '../wagmi.js.dart';

@JS()
extension type JSChainNativeCurrency(JSObject _) implements JSObject {
  external JSString get name;
  external JSString get symbol;
  external JSNumber get decimals;
}

@JS()
extension type JSChain(JSObject _) implements JSObject {
  external JSNumber get id;
  external JSString get name;
  external JSChainNativeCurrency? get nativeCurrency;
  external JSObject? get rpcUrls;
  external JSObject? get blockExplorers;
  external JSNumber? get sourceId;
  external JSBoolean? get testnet;
  external JSObject? get custom;
  external JSObject? get fees;
  external JSObject? get formatters;
  external JSObject? get serializers;
  external JSObject? get contracts;

  Chain get toDart {
    final map = <String, dynamic>{};

    // Required fields
    try {
      map['id'] = id.toDartInt;
    } catch (e) {
      throw Exception('Invalid chain object: cannot access id');
    }

    try {
      map['name'] = name.toDart;
    } catch (e) {
      map['name'] = 'Unknown Chain';
    }

    // Native currency with explicit conversion
    try {
      final nc = nativeCurrency;
      if (nc != null) {
        map['nativeCurrency'] = {
          'name': nc.name.toDart,
          'symbol': nc.symbol.toDart,
          'decimals': nc.decimals.toDartInt,
        };
      }
    } catch (_) {}

    // Optional fields using safe conversion helper
    _tryConvert(rpcUrls, 'rpcUrls', map);
    _tryConvert(blockExplorers, 'blockExplorers', map);
    _tryConvertNumber(sourceId, 'sourceId', map);
    _tryConvertBool(testnet, 'testnet', map);
    _tryConvert(custom, 'custom', map);
    _tryConvert(fees, 'fees', map);
    _tryConvert(formatters, 'formatters', map);
    _tryConvert(serializers, 'serializers', map);
    _tryConvert(contracts, 'contracts', map);

    return Chain.fromMap(map);
  }

  void _tryConvert(JSObject? value, String key, Map<String, dynamic> map) {
    if (value == null) return;
    try {
      final converted = UtilsJS.dartify(value);
      if (converted != null) {
        map[key] = converted;
      }
    } catch (_) {
      // Skip on error
    }
  }

  void _tryConvertNumber(JSNumber? value, String key, Map<String, dynamic> map) {
    if (value == null) return;
    try {
      map[key] = value.toDartInt;
    } catch (_) {
      // Skip on error
    }
  }

  void _tryConvertBool(JSBoolean? value, String key, Map<String, dynamic> map) {
    if (value == null) return;
    try {
      map[key] = value.toDart;
    } catch (_) {
      // Skip on error
    }
  }
}
