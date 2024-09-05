import 'dart:js_interop';

import 'package:wagmi_flutter_web/src/js/wagmi.js.dart';
import 'package:wagmi_flutter_web/src/models/block_tag.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/getFeeHistory)

class GetFeeHistoryParameters {
  GetFeeHistoryParameters({
    required this.blockCount,
    required this.rewardPercentiles,
    this.chainId,
    this.blockNumber,
    this.blockTag,
  });

  final int? chainId;
  final int blockCount;
  final List<int> rewardPercentiles;
  final BigInt? blockNumber;
  final BlockTag? blockTag;

  JSGetFeeHistoryParameters get toJS => JSGetFeeHistoryParameters(
        chainId: chainId?.toJS,
        blockCount: blockCount.toJS,
        rewardPercentiles: rewardPercentiles.jsify() as JSArray<JSNumber>?,
        blockNumber: blockNumber?.toJS,
        blockTag: blockTag?.toJS,
      );
}

class GetFeeHistoryReturnType {
  GetFeeHistoryReturnType({
    this.baseFeePerGas,
    this.gasUsedRatio,
    this.oldestBlock,
    this.reward,
  });

  final List<dynamic>? baseFeePerGas;
  final List<dynamic>? gasUsedRatio;
  final BigInt? oldestBlock;
  final List<dynamic>? reward;
}
