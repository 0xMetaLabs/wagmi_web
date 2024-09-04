part of '../wagmi.js.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/getToken)
@JS()
extension type JSGetTokenParameters._(JSObject _) implements JSObject {
  external JSGetTokenParameters({
    required JSString address,
    JSNumber? chainId,
    JSString? formatUnits,
  });
  external JSString address;
  external JSNumber? chainId;
  external JSString? formatUnits;
}

@JS()
extension type JSGetTokenReturnType(JSObject _) implements JSObject {
  external JSString address;
  external JSNumber? decimals;
  external JSString? name;
  external JSString? symbol;
  external JSAny? totalSupply;

  GetTokenReturnType get toDart {
    var supply = <String, dynamic>{};
    if (totalSupply != null) {
      supply = UtilsJS.jsObjectToMap(totalSupply! as JSObject);
    }

    return GetTokenReturnType(
      address: address.toDart,
      decimals: decimals?.toDartInt,
      name: name?.toDart,
      symbol: symbol?.toDart,
      totalSupply: supply,
    );
  }
}

@JS()
extension type JSGetTokenErrorType(JSObject _) implements JSObject {}
