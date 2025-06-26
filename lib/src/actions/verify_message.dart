import 'dart:js_interop';

import 'package:wagmi_web/src/js/wagmi.js.dart';
import 'package:wagmi_web/src/models/block_tag.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/verifyMessage)
class VerifyMessageParameters {
  VerifyMessageParameters({
    required this.address,
    required this.message,
    required this.signature,
    this.chainId,
    this.blockNumber,
    this.blockTag,
  });
  final String address;
  final dynamic message;
  final String signature;
  final int? chainId;
  final BigInt? blockNumber;
  final BlockTag? blockTag;

  JSVerifyMessageParameters get toJS => JSVerifyMessageParameters(
        address: address.toJS,
        message: _convertMessage(message),
        signature: signature.toJS,
        chainId: chainId?.toJS,
        blockNumber: blockNumber?.toJS,
        blockTag: blockTag?.toJS,
      );
  
  JSAny _convertMessage(dynamic message) {
    if (message is String) {
      return message.toJS;
    } else if (message is JSAny) {
      return message;
    } else {
      throw ArgumentError('Message must be a String or JSAny');
    }
  }
}
