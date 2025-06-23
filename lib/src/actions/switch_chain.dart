import 'dart:js_interop';

import 'package:wagmi_web/src/js/wagmi.js.dart';
import 'package:wagmi_web/src/utils/utils_js.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/switchChain)
class SwitchChainParameters {
  SwitchChainParameters({
    this.connector,
    required this.chainId,
    this.addEthereumChainParameter,
  });
  dynamic addEthereumChainParameter;
  int chainId;
  dynamic connector;

  JSSwitchChainParameters get toJS {
    // According to wagmi docs, connector is optional for switchChain
    // If not provided, it will use the current connector
    return JSSwitchChainParameters(
      chainId: chainId.toJS,
      addEthereumChainParameter: addEthereumChainParameter != null 
          ? UtilsJS.jsify(addEthereumChainParameter) 
          : null,
      // Omit connector - let wagmi use the current connector
    );
  }
}

class SwitchChainReturnType {
  SwitchChainReturnType({
    required this.value,
  });

  final dynamic value;
}
