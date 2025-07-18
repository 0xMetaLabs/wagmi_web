import 'dart:js_interop';

import 'package:wagmi_web/src/js/wagmi.js.dart';
import 'package:wagmi_web/wagmi_web.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/readContract)
class ReadContractParameters {
  ReadContractParameters({
    required this.abi,
    required this.address,
    required this.functionName,
    this.account,
    this.args,
    this.blockNumber,
    this.blockTag,
    this.chainId,
  });
  Abi abi;
  String address;
  String functionName;
  String? account;
  List<dynamic>? args;
  BigInt? blockNumber;
  BlockTag? blockTag;
  int? chainId;

  JSReadContractParameters get toJS => JSReadContractParameters(
        abi: abi.jsify()!,
        address: address.toJS,
        functionName: functionName.toJS,
        account: account?.toJS,
        args: args?.toNonNullableJSArray,
        blockNumber: blockNumber?.toJS,
        blockTag: blockTag?.toJS,
        chainId: chainId?.toJS,
      );
}
