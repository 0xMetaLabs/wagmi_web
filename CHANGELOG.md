## 2.0.10
Updated dependencies to latest versions
wagmi/core - 2.21.2

## 2.0.9
Updated Deps to wagmi/core - 2.21.0

## 2.0.8
Direct Modal Access & Direct Meld.io Integration

## 2.0.7
Updated Deps to Wagmi - 2.16.8

## 2.0.6
Updated Deps

## 2.0.5
Updated Deps

## 2.0.4

### WASM Compatibility Fixes for Contract Reading and Wallet Reconnection

This release fixes critical WASM compatibility issues for contract reading and wallet reconnection functionality.

#### Bug Fixes

**Contract Reading:**
- Fixed `readContracts` returning 0 values in WASM mode while working correctly in JS mode
- Improved BigInt handling by directly accessing object properties instead of relying on generic conversion
- Added specific JSBigInt detection and conversion using `toDart` method
- Implemented fallback strategies for robust error handling

**Wallet Reconnection:**
- Fixed "Type 'Null' is not a subtype of type 'JSValue'" error when reconnecting wallets after page refresh in WASM
- Added comprehensive error handling in JSReconnectReturnType conversion
- Implemented safe connector property access with null checks
- Added graceful degradation to prevent crashes during reconnection failures

## 2.0.3

### WASM Compatibility Fixes

This release fixes additional WASM compatibility issues for message verification and transaction receipt handling.

#### Bug Fixes

**Message Verification:**
- Fixed `verifyMessage` throwing "Type 'String' is not a subtype of type 'JSValue'" error in WASM
- Added proper String to JSAny conversion for message parameters
- Implemented helper method to handle both String and JSAny message types

**Transaction Receipt Handling:**
- Fixed `waitForTransactionReceipt` throwing "Type 'JSValue' is not a subtype of type 'List<dynamic>'" error in WASM
- Fixed similar issue in `getTransactionReceipt`
- Properly convert JSArray of logs using JSLog.toDart getter instead of jsify()

## 2.0.2

### WASM Compatibility Improvements

This release focuses on improving WASM (WebAssembly) compatibility for Flutter Web applications compiled to WASM.

#### Bug Fixes

**Chain Data Handling:**
- Fixed `getChains()` returning "Unknown Chain" and missing native currency information in WASM builds
- Improved JSChain type definition with explicit property declarations for WASM compatibility
- Added proper conversion for native currency properties (name, symbol, decimals)
- Enhanced chain object conversion with multiple fallback strategies

**Array Handling:**
- Fixed `getBlock()` throwing "Type 'JSValue' is not a subtype of type 'List<dynamic>?'" error in WASM
- Added proper JSArray to Dart List conversion with WASM-specific fallbacks
- Fixed array indexing issues in WASM environments

**Contract Calls:**
- Fixed `readContracts()` throwing "Type 'Null' is not a subtype of type 'Map<String, dynamic>'" error in WASM
- Improved null handling for failed contract calls
- Enhanced conversion logic to handle various result types

**Chain Switching:**
- Fixed `switchChain()` functionality in WASM builds
- Removed connector parameter requirement (now uses current connector automatically)
- Fixed JSError conversion issues causing "obj.hasOwnProperty is not a function" errors
- Improved chain property extraction in switchChain results

#### Technical Improvements

**Type Safety:**
- Added explicit external getter declarations for all JS interop types
- Enhanced JSArray extension with length property and index operator
- Improved error handling with try-catch blocks for each property access

**Conversion Strategies:**
- Implemented dual-approach conversion: standard toDart for JS, manual extraction for WASM
- Added UtilsJS.dartify as primary conversion method with fallbacks
- Created helper methods for consistent type conversion

**Code Quality:**
- Reduced code duplication with reusable conversion helpers
- Added comprehensive error handling for edge cases
- Improved maintainability with cleaner separation of concerns

### Developer Notes
- When building for WASM, use `flutter build web --wasm`
- All chain properties should now display correctly in both JS and WASM builds
- Failed operations now return empty objects/arrays instead of throwing errors

## 2.0.1

### Bug Fixes
- Fixed `readContracts` returning empty array due to Map conversion issue in WASM compatibility layer
- Updated `UtilsJS.jsify()` to properly handle `LinkedMap<dynamic, dynamic>` and other Map types, not just `Map<String, dynamic>`

## 2.0.0 - BREAKING CHANGES

### Migration from Web3Modal to Reown AppKit

This version migrates from the deprecated Web3Modal to the new Reown AppKit. While the functionality remains the same, there are breaking changes in the API naming.

#### Breaking Changes

##### Package Dependencies
- **Removed**: `@web3modal/wagmi` (5.1.11)
- **Added**: `@reown/appkit` (^1.7.10) and `@reown/appkit-adapter-wagmi` (^1.7.10)

##### Dart API Changes

All Web3Modal references have been renamed to AppKit:

**Class Renames:**
- `Web3Modal` → `AppKit`
- `Web3ModalMetadata` → `AppKitMetadata`
- `Web3ModalState` → `AppKitState`

**Code Migration Examples:**
```dart
// Before (1.x)
wagmi.Web3Modal.init(
  projectId: 'YOUR_PROJECT_ID',
  metadata: wagmi.Web3ModalMetadata(
    name: 'My App',
    description: 'My App Description',
    url: 'https://myapp.com',
    icons: ['https://myapp.com/icon.png'],
  ),
  // ... other parameters
);

wagmi.Web3Modal.open();
wagmi.Web3Modal.close();
Stream<Web3ModalState> state = wagmi.Web3Modal.state;

// After (2.0.0)
wagmi.AppKit.init(
  projectId: 'YOUR_PROJECT_ID',
  metadata: wagmi.AppKitMetadata(
    name: 'My App',
    description: 'My App Description',
    url: 'https://myapp.com',
    icons: ['https://myapp.com/icon.png'],
  ),
  // ... other parameters
);

wagmi.AppKit.open();
wagmi.AppKit.close();
Stream<AppKitState> state = wagmi.AppKit.state;
```

##### JavaScript/TypeScript API Changes

**Window Object:**
- Before: `window.web3modal`
- After: `window.appkit`

**TypeScript Classes:**
- `JSWeb3Modal` → `JSAppKit`

##### File Renames
- `web3_modal.ts` → `appkit.ts`
- `wagmi_web3modal.dart` → `wagmi_appkit.dart`
- `wagmi_web3modal.js.dart` → `wagmi_appkit.js.dart`

#### Migration Guide

1. Update all imports - the package import remains the same:
   ```dart
   import 'package:wagmi_web/wagmi_web.dart' as wagmi;
   ```

2. Replace all class references:
   - Find: `Web3Modal` → Replace: `AppKit`
   - Find: `Web3ModalMetadata` → Replace: `AppKitMetadata`
   - Find: `Web3ModalState` → Replace: `AppKitState`

3. If using direct JavaScript access, update window references:
   - Find: `window.web3modal` → Replace: `window.appkit`

#### Notes
- This is a branding/naming change only - all functionality remains identical
- Method signatures and parameters have not changed
- The underlying WalletConnect/Reown infrastructure may still use `w3m-` prefixes in UI components

## 1.1.2
* Updated Js Deps
* resolved wallet connect issue on metamask in JS
* Addes example app - Web Links 

## 1.1.1
* Added Screenshots

## 1.1.0
* Forking from wagmi_flutter_web - Initial Release
