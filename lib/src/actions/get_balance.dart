import 'dart:js_interop';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wagmi_flutter_web/src/js/wagmi.js.dart';
import 'package:wagmi_flutter_web/src/models/block_tag.dart';
part 'get_balance.freezed.dart';

/// [Documentation API](https://wagmi.sh/core/api/actions/getBalance)
class GetBalanceParameters {
  GetBalanceParameters({
    required this.address,
    this.blockNumber,
    this.blockTag,
    this.chainId,
    this.token,
    this.unit,
  });

  final String address;
  final BigInt? blockNumber;
  final BlockTag? blockTag;
  final int? chainId;
  final String? token;
  final Unit? unit;

  JSGetBalanceParameters get toJS => JSGetBalanceParameters(
        address: address.toJS,
        blockNumber: blockNumber?.toJS,
        blockTag: blockTag?.toJS,
        chainId: chainId?.toJS,
        token: token?.toJS,
        unit: unit?.toJS,
      );
}

class GetBalanceReturnType {
  GetBalanceReturnType({
    required this.decimals,
    required this.formatted,
    required this.symbol,
    required this.value,
  });

  final int decimals;
  final String formatted;
  final String symbol;
  final BigInt value;
}

@freezed
class Unit with _$Unit {
  const Unit._();
  const factory Unit.ether() = _UnitEther;
  const factory Unit.gwei() = _UnitGwei;
  const factory Unit.wei() = _UnitWei;
  const factory Unit.id(int id) = _UnitId;
}
