part of 'wagmi.js.dart';

@JS()
extension type JSWagmiAppKit(JSObject _) implements JSObject {
  external void init(
    JSString projectId,
    JSArray<JSNumber> chains,
    JSWagmiCoreStorage storage,
    JSBoolean enableAnalytics,
    JSBoolean enableOnRamp,
    JSWagmiAppKitMetadata metadata,
    JSBoolean email,
    JSArray<JSString>? socials,
    JSBoolean showWallets,
    JSBoolean walletFeatures,
    JSFunction? transportBuilder,
    JSArray<JSString>? includedWalletIds,
    JSArray<JSString>? featuredWalletIds,
    JSArray<JSString>? excludedWalletIds,
  );
  // for create createConfig
  external JSConfig createConfig(
    JSString projectId,
    JSString configKey,
    JSArray<JSNumber> chains,
    JSWagmiCoreStorage storage,
    JSWagmiAppKitMetadata metadata,
    JSBoolean email,
    JSArray<JSString>? socials,
    JSBoolean showWallets,
    JSBoolean walletFeatures,
    JSFunction? transportBuilder,
    JSArray<JSString>? includedWalletIds,
    JSArray<JSString>? featuredWalletIds,
    JSArray<JSString>? excludedWalletIds,
  );

  external JSAppKit createAppKit(
    JSConfig wagmiConfig,
    JSString projectId,
    // Optional - defaults to your Cloud configuration
    JSBoolean? enableAnalytics,
    // Optional - false as default
    JSBoolean? enableOnRamp,
  );

  external JSPromise<Null> open();
  external JSPromise<Null> close();
  external JSPromise<Null> openActivity();
  external JSPromise<Null> openBuyCrypto();
  external JSPromise<Null> openMeld(JSObject? options);

  external JSFunction subscribeState(JSFunction callback);
}

@JS()
extension type PublicStateControllerState._(JSObject _) implements JSObject {
  external JSBoolean loading;
  external JSBoolean open;
  external JSString? selectedNetworkId;
  external JSString? activeChain;
}

extension AppKitStateFromJS on PublicStateControllerState {
  AppKitState get toDart => AppKitState(
        loading: loading.toDart,
        open: open.toDart,
        selectedNetworkId: selectedNetworkId?.toDart,
        activeChain: activeChain?.toDart,
      );
}

@JS()
extension type JSWagmiAppKitMetadata._(JSObject _) implements JSObject {
  external JSWagmiAppKitMetadata({
    required JSString name,
    required JSString description,
    required JSString url,
    required JSArray<JSString> icons,
  });
  external JSString name;
  external JSString description;
  external JSString url;
  external JSArray<JSString> icons;
}
