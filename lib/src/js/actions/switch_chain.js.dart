part of '../wagmi.js.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/switchChain)
@JS()
extension type JSSwitchChainParameters._(JSObject _) implements JSObject {
  external JSSwitchChainParameters({
    JSAny? connector,
    JSAny? addEthereumChainParameter,
    required JSNumber chainId,
  });
  external JSAny? addEthereumChainParameter;
  external JSNumber chainId;
  external JSAny? connector;
}

@JS()
extension type JSSwitchChainErrorType(JSObject _) implements JSObject {}
