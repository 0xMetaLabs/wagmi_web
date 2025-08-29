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

  /// Opens the [AppKit] directly to the Activity/Transactions view
  /// 
  /// Throws an [Exception] if no wallet is connected.
  static Future<void> openActivity() async {
    // Check if wallet is connected first
    final account = Core.getAccount();
    if (!account.isConnected) {
      throw Exception('Wallet not connected. Please connect a wallet first.');
    }
    
    await window.appkit.openActivity().toDart;
  }

  /// Opens the [AppKit] directly to the Buy Crypto/OnRamp providers view
  /// 
  /// Throws an [Exception] if no wallet is connected.
  static Future<void> openBuyCrypto() async {
    // Check if wallet is connected first
    final account = Core.getAccount();
    if (!account.isConnected) {
      throw Exception('Wallet not connected. Please connect a wallet first.');
    }
    
    await window.appkit.openBuyCrypto().toDart;
  }

  /// Opens Meld.io directly in a popup with customizable parameters
  /// 
  /// If no options are provided or if specific fields are null, reverts to default behavior:
  /// - Requires wallet connection
  /// - Uses India (IN) as default region
  /// - Uses INR as default currency
  /// - Uses connected wallet address
  /// - Uses card as default payment method
  /// 
  /// Throws an [Exception] if no wallet is connected and no custom walletAddress is provided.
  static Future<void> openMeld([MeldOptions? options]) async {
    // Always check wallet connection unless custom walletAddress is explicitly provided
    if (options?.walletAddress == null) {
      final account = Core.getAccount();
      if (!account.isConnected) {
        throw Exception('Wallet not connected. Please connect a wallet first.');
      }
    }
    
    await window.appkit.openMeld(options?._toJS()).toDart;
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

/// Configuration options for opening Meld.io
/// 
/// All parameters are optional. Meld.io automatically detects user location, language, 
/// and preferred currency based on IP geolocation and browser settings for better UX.
/// Only specify options when you need to override the automatic detection:
/// - Requires wallet connection (unless walletAddress is provided)
/// - Auto-detects location, currency, language, and payment methods
/// - Uses connected wallet address unless overridden
class MeldOptions {
  MeldOptions({
    this.countryCode,
    this.country,
    this.sourceCurrencyCode,
    this.destinationCurrencyCode,
    this.walletAddress,
    this.amount,
    this.paymentMethod,
    this.language,
    this.locale,
  });

  /// Country code (e.g., 'US', 'IN', 'GB'). 
  /// When null: Meld auto-detects from user's IP location
  final String? countryCode;
  
  /// Country name (e.g., 'USA', 'India', 'United Kingdom'). 
  /// When null: Meld auto-detects from user's IP location
  final String? country;
  
  /// Source currency code (e.g., 'USD', 'INR', 'EUR'). 
  /// When null: Meld auto-detects based on user's location
  final String? sourceCurrencyCode;
  
  /// Destination cryptocurrency (e.g., 'USDC', 'SOL', 'ETH'). 
  /// When null: defaults based on active chain (SOL for Solana, USDC for Ethereum)
  final String? destinationCurrencyCode;
  
  /// Custom wallet address. 
  /// When null: uses connected wallet address (requires wallet connection)
  final String? walletAddress;
  
  /// Pre-filled amount for purchase.
  /// When null: no amount pre-filled, user enters manually
  final String? amount;
  
  /// Payment method (e.g., 'card', 'bank'). 
  /// When null: Meld shows all available payment methods for user's region
  final String? paymentMethod;
  
  /// Language code (e.g., 'en', 'hi', 'es'). 
  /// When null: Meld auto-detects from browser settings
  final String? language;
  
  /// Locale (e.g., 'en-US', 'en-IN', 'es-ES'). 
  /// When null: Meld auto-detects from browser/location
  final String? locale;

  JSObject? _toJS() {
    final options = <String, dynamic>{};
    
    if (countryCode != null) options['countryCode'] = countryCode;
    if (country != null) options['country'] = country;
    if (sourceCurrencyCode != null) options['sourceCurrencyCode'] = sourceCurrencyCode;
    if (destinationCurrencyCode != null) options['destinationCurrencyCode'] = destinationCurrencyCode;
    if (walletAddress != null) options['walletAddress'] = walletAddress;
    if (amount != null) options['amount'] = amount;
    if (paymentMethod != null) options['paymentMethod'] = paymentMethod;
    if (language != null) options['language'] = language;
    if (locale != null) options['locale'] = locale;
    
    return options.isEmpty ? null : options.jsify() as JSObject?;
  }
}
