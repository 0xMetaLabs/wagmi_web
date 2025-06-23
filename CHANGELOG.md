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
