import 'dart:async';
import 'dart:js_interop';

import 'package:wagmi_web/src/js/wagmi.js.dart';
import 'package:wagmi_web/wagmi_web.dart';

class AppKit {
  static void init({
    required String projectId,
    required List<int> chains,
    CoreStorage storage = CoreStorage.localStorage,
    required bool enableAnalytics,
    required bool enableOnRamp,
    required AppKitMetadata metadata,
    required bool email,
    List<String>? socials,
    required bool showWallets,
    required bool walletFeatures,
    TransportBuilder? transportBuilder,
    List<String>? includeWalletIds,
    List<String>? featuredWalletIds,
    List<String>? excludeWalletIds,
  }) {
    window.appkit.init(
      projectId.toJS,
      chains
          .map(
            (e) => e.toJS,
          )
          .toList()
          .toJS,
      storage.toJS,
      enableAnalytics.toJS,
      enableOnRamp.toJS,
      metadata._toJS(),
      email.toJS,
      socials.jsify() as JSArray<JSString>?,
      showWallets.toJS,
      walletFeatures.toJS,
      transportBuilder?.toJS,
      includeWalletIds?.jsify() as JSArray<JSString>?,
      featuredWalletIds?.jsify() as JSArray<JSString>?,
      excludeWalletIds?.jsify() as JSArray<JSString>?,
    );
  }

  // for create createConfig
  static Config createConfig({
    required String projectId,
    required String configKey,
    required List<int> chains,
    CoreStorage storage = CoreStorage.localStorage,
    required AppKitMetadata metadata,
    required bool email,
    List<String>? socials,
    required bool showWallets,
    required bool walletFeatures,
    TransportBuilder? transportBuilder,
    List<String>? includeWalletIds,
    List<String>? featuredWalletIds,
    List<String>? excludeWalletIds,
  }) =>
      window.appkit.createConfig(
        projectId.toJS,
        configKey.toJS,
        chains
            .map(
              (e) => e.toJS,
            )
            .toList()
            .toJS,
        storage.toJS,
        metadata._toJS(),
        email.toJS,
        socials.jsify() as JSArray<JSString>?,
        showWallets.toJS,
        walletFeatures.toJS,
        transportBuilder?.toJS,
        includeWalletIds?.jsify() as JSArray<JSString>?,
        featuredWalletIds?.jsify() as JSArray<JSString>?,
        excludeWalletIds?.jsify() as JSArray<JSString>?,
      );

  /// Opens the [AppKit]
  static Future<void> open() async {
    await window.appkit.open().toDart;
  }

  /// Closes the [AppKit]
  static Future<void> close() async {
    await window.appkit.close().toDart;
  }

  /// Listens to the [AppKit] state.
  static Stream<AppKitState> get state {
    late StreamController<AppKitState> controller;
    late Function? stopListeningFunction;

    void startListening() {
      stopListeningFunction = window.appkit
          .subscribeState(
            ((PublicStateControllerState state) {
              controller.add(state.toDart);
            }).toJS,
          )
          .toDart;
    }

    void stopListening() {
      stopListeningFunction?.call();
      stopListeningFunction = null;
    }

    controller = StreamController<AppKitState>(
      onListen: startListening,
      onPause: stopListening,
      onResume: startListening,
      onCancel: stopListening,
    );

    return controller.stream;
  }
}

/// [AppKit documentation](https://docs.walletconnect.com/appkit/javascript/core/installation#implementation)
class AppKitMetadata {
  AppKitMetadata({
    required this.name,
    required this.description,
    required this.url,
    required this.icons,
  });

  final String name;
  final String description;
  final String url;
  final List<String> icons;

  JSWagmiAppKitMetadata _toJS() => JSWagmiAppKitMetadata(
        name: name.toJS,
        description: description.toJS,
        url: url.toJS,
        icons: icons.map((icon) => icon.toJS).toList().toJS,
      );
}

class AppKitState {
  AppKitState({
    required this.loading,
    required this.open,
    required this.selectedNetworkId,
    required this.activeChain,
  });

  final bool loading;
  final bool open;
  final String? selectedNetworkId;
  final String? activeChain;
}
