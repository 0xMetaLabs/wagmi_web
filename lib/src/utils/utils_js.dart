import 'dart:js_interop';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:wagmi_web/src/js/wagmi.js.dart';

// External JS functions for object manipulation
@JS('Object.keys')
external JSArray<JSString> _objectKeys(JSObject obj);

// Helper extension for JSObject property access
extension JSObjectProperties on JSObject {
  external JSAny? operator [](String property);
  external void operator []=(String property, JSAny? value);
}

class UtilsJS {
  static Object? dartify(JSAny? jsObject, {bool deep = true}) {
    if (jsObject == null) return null;

    try {
      if (jsObject is JSBigInt) return jsObject.toDart;
      if (jsObject is JSArray) return jsObject.toDartDynamicList;
      if (jsObject is JSObject) return deep ? jsObject.toMap() : jsObject;
      return jsObject.dartify();
    } catch (e) {
      // WASM fallback - if dartify fails, handle different types safely
      try {
        if (jsObject is JSBigInt) return jsObject.toDart;
        if (jsObject is JSString) return jsObject.toDart;
        if (jsObject is JSNumber) return jsObject.toDartDouble;
        if (jsObject is JSBoolean) return jsObject.toDart;
        if (jsObject is JSArray) {
          try {
            return jsObject.toDartDynamicList;
          } catch (_) {
            // If array conversion fails, return as-is
            return jsObject;
          }
        }
        if (jsObject is JSObject) {
          try {
            return deep ? jsObject.toMap() : jsObject;
          } catch (_) {
            // If object conversion fails, return as-is
            return jsObject;
          }
        }
        // For any other type, return as-is to avoid casting errors
        return jsObject;
      } catch (_) {
        // Ultimate fallback - return null to prevent crashes
        return null;
      }
    }
  }

  static JSAny? jsify(dynamic dartObject) {
    // We do exhaustive types check here
    // because `dartObject.jsify()` throws a "NoSuchMethodError: 'jsify'"
    // without explicit cast.
    if (dartObject == null) return null;

    try {
      if (dartObject is BigInt) return dartObject.toJS;
      if (dartObject is Iterable) return dartObject.toJSArray;
      if (dartObject is String) return dartObject.toJS;
      if (dartObject is int) return dartObject.toJS;
      if (dartObject is bool) return dartObject.toJS;
      if (dartObject is double) return dartObject.toJS;
      if (dartObject is num) return dartObject.toJS;
      if (dartObject is Int8List) return dartObject.toJS;
      if (dartObject is Uint8List) return dartObject.toJS;
      if (dartObject is Int16List) return dartObject.toJS;
      if (dartObject is Uint16List) return dartObject.toJS;
      if (dartObject is Int32List) return dartObject.toJS;
      if (dartObject is Uint32List) return dartObject.toJS;
      if (dartObject is Float32List) return dartObject.toJS;
      if (dartObject is Float64List) return dartObject.toJS;
      if (dartObject is List) return dartObject.toJSArray;
      if (dartObject is Map) {
        // Handle any type of Map, not just Map<String, dynamic>
        final jsObject = JSObject();
        dartObject.forEach((key, value) {
          if (key is String) {
            jsObject[key] = UtilsJS.jsify(value);
          }
        });
        return jsObject;
      }
      return dartObject.jsify();
    } catch (e) {
      // WASM fallback - if jsify fails, return null to prevent crashes
      return null;
    }
  }
}

extension DartListToJS on Iterable {
  JSArray<JSAny?> get toJSArray {
    final jsArgs = JSArray<JSAny?>();
    for (final arg in this) {
      final jsValue = UtilsJS.jsify(arg as Object?);
      jsArgs.push(jsValue);
    }
    return jsArgs;
  }

  JSArray<JSAny> get toNonNullableJSArray {
    final jsArgs = JSArray<JSAny>();
    for (final arg in this) {
      final jsValue = UtilsJS.jsify(arg as Object?);
      if (jsValue != null) {
        jsArgs.push(jsValue);
      }
    }
    return jsArgs;
  }
}

extension DartMapToJS on Map<String, dynamic> {
  JSObject get toJSObject {
    try {
      final jsObject = JSObject();
      for (final entry in entries) {
        jsObject[entry.key] = UtilsJS.jsify(entry.value);
      }
      return jsObject;
    } catch (e) {
      // WASM fallback - return empty object if conversion fails
      return JSObject();
    }
  }
}

extension JSBigIntArrayToList on JSArray<JSBigInt> {
  List<BigInt> get toDartBigIntList =>
      toDart.map((item) => item.toDart).toList();
}

extension JSNumberArrayToList on JSArray<JSNumber> {
  List<Decimal> get toDartDecimalList =>
      toDart.map((item) => Decimal.parse(item.toString())).toList();
}

extension JSAnyArrayToList on JSArray {
  List<Object?> get toDartDynamicList {
    try {
      return toDart.map(UtilsJS.dartify).toList();
    } catch (e) {
      // WASM fallback - return empty list if conversion fails
      return [];
    }
  }
}

extension JSObjectToMap on JSObject {
  Map<String, dynamic> toMap({bool deep = true}) {
    final map = <String, dynamic>{};

    try {
      // Get the keys of the JSObject using dart:js_interop
      final jsKeys = _objectKeys(this);
      final keys =
      jsKeys.toDart.map((jsString) => jsString.toDart).toList();

      // Iterate over the keys and assign values to the Dart map
      if (keys.isEmpty) {
        return map;
      }

      for (final key in keys) {
        try {
          final value = this[key];
          map[key] = UtilsJS.dartify(value, deep: deep);
        } catch (e) {
          // Skip problematic keys in WASM to prevent crashes
          continue;
        }
      }
    } catch (e) {
      // WASM fallback - return empty map if conversion fails
      return {};
    }

    return map;
  }
}
