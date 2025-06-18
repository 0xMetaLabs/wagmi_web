// define js functions
part of '../wagmi.js.dart';

@JS()
extension type JSConnector(JSObject _) implements JSObject {
  // it holds functions that are used to interact with the connector
  external JSDataImage? icon;
  external JSString? id;
  external JSString? name;
  external JSString? type;
  external JSString? uid;
  external JSBoolean? supportsSimulation;
  external JSFunction? connect;
  external JSFunction? disconnect;
  external JSAny? emitter;
  external JSFunction? getAccounts;
  external JSFunction? getChainId;
  external JSFunction? getProvider;
  external JSFunction? isAuthorized;
  external JSFunction? onAccountsChanged;
  external JSFunction? onChainChanged;
  external JSFunction? onConnect;
  external JSFunction? onDisconnect;
  external JSFunction? setup;
  external JSFunction? switchChain;

  Connector get toDart => Connector(
    icon: icon?.toDart,
    id: id?.toDart,
    name: name?.toDart,
    type: type?.toDart,
    uid: uid?.toDart,
    supportsSimulation: supportsSimulation?.toDart,
    connect: connect != null ? _convertConnectFunction(connect!) : null,
    disconnect:
    disconnect != null ? _convertDisconnectFunction(disconnect!) : null,
    emitter: emitter?.jsify(),
    getAccounts: getAccounts != null
        ? _convertGetAccountsFunction(getAccounts!)
        : null,
    getChainId:
    getChainId != null ? _convertGetChainIdFunction(getChainId!) : null,
    getProvider: getProvider != null
        ? _convertGetProviderFunction(getProvider!)
        : null,
    isAuthorized: isAuthorized != null
        ? _convertIsAuthorizedFunction(isAuthorized!)
        : null,
    onAccountsChanged: onAccountsChanged != null
        ? _convertOnAccountsChangedFunction(onAccountsChanged!)
        : null,
    onChainChanged: onChainChanged != null
        ? _convertOnChainChangedFunction(onChainChanged!)
        : null,
    onConnect:
    onConnect != null ? _convertOnConnectFunction(onConnect!) : null,
    onDisconnect: onDisconnect != null
        ? _convertOnDisconnectFunction(onDisconnect!)
        : null,
    setup: setup != null ? _convertSetupFunction(setup!) : null,
    switchChain: switchChain != null
        ? _convertSwitchChainFunction(switchChain!)
        : null,
  );
}

// WASM-safe function converters
dynamic Function({int? chainId, bool? isReconnecting}) _convertConnectFunction(
    JSFunction jsFunc) {
  return ({int? chainId, bool? isReconnecting}) {
    final args = <JSAny?>[];
    if (chainId != null || isReconnecting != null) {
      final params = <String, dynamic>{};
      if (chainId != null) params['chainId'] = chainId;
      if (isReconnecting != null) params['isReconnecting'] = isReconnecting;
      args.add(params.toJSObject);
    }

    return switch (args.length) {
      0 => jsFunc.callAsFunction(),
      1 => jsFunc.callAsFunction(null, args[0]),
      _ => jsFunc.callAsFunction(),
    };
  };
}

void Function() _convertDisconnectFunction(JSFunction jsFunc) {
  return () => jsFunc.callAsFunction();
}

dynamic Function() _convertGetAccountsFunction(JSFunction jsFunc) {
  return () => jsFunc.callAsFunction();
}

int Function() _convertGetChainIdFunction(JSFunction jsFunc) {
  return () {
    final result = jsFunc.callAsFunction();
    if (result is JSNumber) return result.toDartInt;
    return 0;
  };
}

Function() _convertGetProviderFunction(JSFunction jsFunc) {
  return () => jsFunc.callAsFunction();
}

bool Function() _convertIsAuthorizedFunction(JSFunction jsFunc) {
  return () {
    final result = jsFunc.callAsFunction();
    if (result is JSBoolean) return result.toDart;
    return false;
  };
}

Function({List<dynamic> accounts}) _convertOnAccountsChangedFunction(
    JSFunction jsFunc) {
  return ({List<dynamic>? accounts}) {
    final jsAccounts = (accounts ?? []).toJSArray;
    return jsFunc.callAsFunction(null, jsAccounts);
  };
}

Function({int? chain}) _convertOnChainChangedFunction(JSFunction jsFunc) {
  return ({int? chain}) {
    final args = <JSAny?>[];
    if (chain != null) {
      final params = <String, dynamic>{'chain': chain};
      args.add(params.toJSObject);
    }

    return switch (args.length) {
      0 => jsFunc.callAsFunction(),
      1 => jsFunc.callAsFunction(null, args[0]),
      _ => jsFunc.callAsFunction(),
    };
  };
}

Function({dynamic connectionInfo}) _convertOnConnectFunction(
    JSFunction jsFunc) {
  return ({dynamic connectionInfo}) {
    final args = <JSAny?>[];
    if (connectionInfo != null) {
      final params = <String, dynamic>{'connectionInfo': connectionInfo};
      args.add(params.toJSObject);
    }

    return switch (args.length) {
      0 => jsFunc.callAsFunction(),
      1 => jsFunc.callAsFunction(null, args[0]),
      _ => jsFunc.callAsFunction(),
    };
  };
}

Function({dynamic error}) _convertOnDisconnectFunction(JSFunction jsFunc) {
  return ({dynamic error}) {
    final args = <JSAny?>[];
    if (error != null) {
      final params = <String, dynamic>{'error': error};
      args.add(params.toJSObject);
    }

    return switch (args.length) {
      0 => jsFunc.callAsFunction(),
      1 => jsFunc.callAsFunction(null, args[0]),
      _ => jsFunc.callAsFunction(),
    };
  };
}

Function() _convertSetupFunction(JSFunction jsFunc) {
  return () => jsFunc.callAsFunction();
}

dynamic Function({dynamic addEthereumChainParameter, int? chainId})
_convertSwitchChainFunction(JSFunction jsFunc) {
  return ({dynamic addEthereumChainParameter, int? chainId}) {
    final args = <JSAny?>[];
    if (addEthereumChainParameter != null || chainId != null) {
      final params = <String, dynamic>{};
      if (addEthereumChainParameter != null)
        params['addEthereumChainParameter'] = addEthereumChainParameter;
      if (chainId != null) params['chainId'] = chainId;
      args.add(params.toJSObject);
    }

    return switch (args.length) {
      0 => jsFunc.callAsFunction(),
      1 => jsFunc.callAsFunction(null, args[0]),
      _ => jsFunc.callAsFunction(),
    };
  };
}
