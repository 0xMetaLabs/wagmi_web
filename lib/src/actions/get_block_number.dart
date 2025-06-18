import 'dart:js_interop';

import 'package:wagmi_web/src/js/wagmi.js.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/getBlockNumber)
class GetBlockNumberParameters {
  GetBlockNumberParameters({
    this.cacheTime,
    this.chainId,
  });
  int? cacheTime;
  int? chainId;

  JSGetBlockNumberParameters get toJS => JSGetBlockNumberParameters(
        cacheTime: cacheTime?.toJS,
        chainId: chainId?.toJS,
      );
}

class GetBlockNumberReturnType {
  GetBlockNumberReturnType({
    required this.blockNumber,
  });

  BigInt blockNumber;
}
