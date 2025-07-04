import 'dart:async';
import 'dart:js_interop';

import 'package:logging/logging.dart';
import 'package:wagmi_web/src/actions/call.dart';
import 'package:wagmi_web/src/actions/deploy_contract.dart';
import 'package:wagmi_web/src/actions/disconnect.dart';
import 'package:wagmi_web/src/actions/estimate_fees_per_gas.dart';
import 'package:wagmi_web/src/actions/estimate_gas.dart';
import 'package:wagmi_web/src/actions/estimate_max_priority_fee_per_gas.dart';
import 'package:wagmi_web/src/actions/get_balance.dart';
import 'package:wagmi_web/src/actions/get_block.dart';
import 'package:wagmi_web/src/actions/get_block_number.dart';
import 'package:wagmi_web/src/actions/get_block_transaction_count.dart';
import 'package:wagmi_web/src/actions/get_byte_code.dart';
import 'package:wagmi_web/src/actions/get_fee_history.dart';
import 'package:wagmi_web/src/actions/get_gas_price.dart';
import 'package:wagmi_web/src/actions/get_token.dart';
import 'package:wagmi_web/src/actions/get_transaction.dart';
import 'package:wagmi_web/src/actions/get_transaction_confirmations.dart';
import 'package:wagmi_web/src/actions/get_transaction_count.dart';
import 'package:wagmi_web/src/actions/get_transaction_receipt.dart';
import 'package:wagmi_web/src/actions/get_wallet_client.dart';
import 'package:wagmi_web/src/actions/read_contract.dart';
import 'package:wagmi_web/src/actions/read_contracts.dart';
import 'package:wagmi_web/src/actions/reconnect.dart';
import 'package:wagmi_web/src/actions/send_transaction.dart';
import 'package:wagmi_web/src/actions/sign_message.dart';
import 'package:wagmi_web/src/actions/switch_account.dart';
import 'package:wagmi_web/src/actions/switch_chain.dart';
import 'package:wagmi_web/src/actions/verify_message.dart';
import 'package:wagmi_web/src/actions/wait_for_transaction_receipt.dart';
import 'package:wagmi_web/src/actions/watch_account.dart';
import 'package:wagmi_web/src/actions/watch_asset.dart';
import 'package:wagmi_web/src/actions/watch_chain_id.dart';
import 'package:wagmi_web/src/actions/watch_connections.dart';
import 'package:wagmi_web/src/actions/watch_contract_event.dart';
import 'package:wagmi_web/src/actions/write_contract.dart';
import 'package:wagmi_web/src/js/wagmi.js.dart';
import 'package:wagmi_web/src/models/account.dart';
import 'package:wagmi_web/src/models/chain.dart';
import 'package:wagmi_web/src/models/connection.dart';
import 'package:wagmi_web/src/utils/utils_js.dart';

enum CoreStorage {
  /// Config's state will not be persisted between sessions.
  noStorage,

  /// If available, browser localStorage will be used to persist Config's state.
  localStorage,
}

class Core {
  static final _logger = Logger('WagmiFlutterWeb');

  static void _logAction(String action) {
    _logger.fine(action);
  }

  static Account getAccount() => _guard(() {
    _logAction('getAccount');
    return window.wagmiCore.getAccount().toDart;
  });

  static int getChainId() => _guard(() {
    _logAction('getChainId');
    return window.wagmiCore.getChainId().toDartInt;
  });

  static List<Connection> getConnections() => _guard(() {
    _logAction('getConnections');
    final result = window.wagmiCore.getConnections();
    return result.toDart
        .map((jsConnection) => jsConnection.toDart)
        .toList();
  });

  static List<Chain> getChains() => _guard(() {
    _logAction('getChains');
    final result = window.wagmiCore.getChains();

    try {
      final chains = <Chain>[];

      // Try standard toDart conversion first (works in JS)
      try {
        final dartList = result.toDart;
        for (final jsChain in dartList) {
          chains.add(jsChain.toDart);
        }

        if (chains.isNotEmpty) {
          return chains;
        }
      } catch (e) {
        // Fall through to WASM approach
      }

      // WASM fallback: use direct array indexing
      try {
        final length = result.length;
        for (var i = 0; i < length; i++) {
          final jsChain = result[i];
          chains.add(jsChain.toDart);
        }
      } catch (e) {
        // Complete failure
      }

      return chains;
    } catch (e) {
      return <Chain>[];
    }
  });

  static Future<BigInt> getBlockNumber(
      GetBlockNumberParameters getBlockNumberParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getBlockNumbers');
        final result = await window.wagmiCore
            .getBlockNumber(
          configKey.toJS,
          getBlockNumberParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<BigInt> getGasPrice(
      GetGasPriceParameters getGasPriceParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getGasPrice');
        final result = await window.wagmiCore
            .getGasPrice(
          configKey.toJS,
          getGasPriceParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<GetBalanceReturnType> getBalance(
      GetBalanceParameters getBalanceParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getBalance');
        final result = await window.wagmiCore
            .getBalance(
          configKey.toJS,
          getBalanceParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<int> getTransactionCount(
      GetTransactionCountParameters getTransactionCountParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getTransactionCount');
        final result = await window.wagmiCore
            .getTransactionCount(
          configKey.toJS,
          getTransactionCountParameters.toJS,
        )
            .toDart;
        return result.toDartInt;
      });

  static Future<GetTokenReturnType> getToken(
      GetTokenParameters getTokenParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getToken');
        final result = await window.wagmiCore
            .getToken(
          configKey.toJS,
          getTokenParameters.toJS,
        )
            .toDart;

        return result.toDart;
      });

  static Future<String> signMessage(
      SignMessageParameters signMessageParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('signMessage');
        final result = await window.wagmiCore
            .signMessage(
          configKey.toJS,
          signMessageParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // read contract
  static Future<dynamic> readContract(
      ReadContractParameters readContractParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('readContract');
        final result = await window.wagmiCore
            .readContract(
          configKey.toJS,
          readContractParameters.toJS,
        )
            .toDart;
        return UtilsJS.dartify(result);
      });

  static Future<List<Map<String, dynamic>>> readContracts(
      ReadContractsParameters readContractsParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('readContracts');
        final result = await window.wagmiCore
            .readContracts(
          configKey.toJS,
          readContractsParameters.toJS,
        )
            .toDart;
        
        // Handle the conversion more carefully for WASM compatibility
        final resultList = <Map<String, dynamic>>[];
        
        // Directly access each JSObject in the array
        for (var i = 0; i < result.length; i++) {
          try {
            final jsItem = result[i];
            
            // Create a map to store the converted result
            final convertedMap = <String, dynamic>{};
            
            // Try to access common properties directly
            try {
              // Access the 'result' property
              final resultValue = jsItem['result'];
              if (resultValue != null) {
                // Handle BigInt conversion specifically
                if (resultValue is JSBigInt) {
                  convertedMap['result'] = resultValue.toDart;
                } else {
                  convertedMap['result'] = UtilsJS.dartify(resultValue);
                }
              }
              
              // Access the 'status' property
              final statusValue = jsItem['status'];
              if (statusValue != null) {
                convertedMap['status'] = statusValue is JSString 
                    ? statusValue.toDart 
                    : UtilsJS.dartify(statusValue);
              }
              
              // Access the 'error' property if it exists
              final errorValue = jsItem['error'];
              if (errorValue != null) {
                convertedMap['error'] = UtilsJS.dartify(errorValue);
              }
              
              resultList.add(convertedMap);
            } catch (e) {
              // If direct property access fails, try the general conversion
              final converted = UtilsJS.dartify(jsItem);
              if (converted is Map<String, dynamic>) {
                resultList.add(converted);
              } else {
                resultList.add({});
              }
            }
          } catch (e) {
            // If all else fails, add an empty map
            resultList.add({});
          }
        }
        
        return resultList;
      });

  // get transaction receipt
  static Future<GetTransactionReceiptReturnType> getTransactionReceipt(
      GetTransactionReceiptParameters getTransactionReceiptParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getTransactionReceipt');
        final result = await window.wagmiCore
            .getTransactionReceipt(
          configKey.toJS,
          getTransactionReceiptParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<void Function()> watchChainId(
      WatchChainIdParameters watchChainIdParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('watchChainId');
        final result = await window.wagmiCore
            .watchChainId(
          configKey.toJS,
          watchChainIdParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<String> sendTransaction(
      SendTransactionParameters sendTransactionParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('sendTransaction');
        final result = await window.wagmiCore
            .sendTransaction(
          configKey.toJS,
          sendTransactionParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<String> writeContract(
      WriteContractParameters writeContractParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('writeContract');
        final result = await window.wagmiCore
            .writeContract(
          configKey.toJS,
          writeContractParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<BigInt> estimateGas(
      EstimateGasParameters estimateGasParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('estimateGas');
        final result = await window.wagmiCore
            .estimateGas(
          configKey.toJS,
          estimateGasParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<GetTransactionReturnType> getTransaction(
      GetTransactionParameters getTransactionParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getTransaction');
        final result = await window.wagmiCore
            .getTransaction(
          configKey.toJS,
          getTransactionParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<WatchContractEventReturnType> watchContractEvent(
      WatchContractEventParameters watchContractEventParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('watchContractEvent');
        final result = await window.wagmiCore
            .watchContractEvent(
          configKey.toJS,
          watchContractEventParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<BigInt> getTransactionConfirmations(
      GetTransactionConfirmationsParameters
      getTransactionConfirmationsParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction(
          'getTransactionConfirmations',
        );
        final result = await window.wagmiCore
            .getTransactionConfirmations(
          configKey.toJS,
          getTransactionConfirmationsParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<GetBlockReturnType> getBlock(
      GetBlockParameters getBlockParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getBlock');
        final result = await window.wagmiCore
            .getBlock(
          configKey.toJS,
          getBlockParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<int> getBlockTransactionCount(
      GetBlockTransactionCountParameters getBlockTransactionCountParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction(
          'getBlockTransactionCount',
        );
        final result = await window.wagmiCore
            .getBlockTransactionCount(
          configKey.toJS,
          getBlockTransactionCountParameters.toJS,
        )
            .toDart;
        return result.toDartInt;
      });

  // call function
  static Future<CallReturnType> call(
      CallParameters callParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('call');
        final result = await window.wagmiCore
            .call(
          configKey.toJS,
          callParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // estimate fees per gas
  static Future<EstimateFeesPerGasReturnType> estimateFeesPerGas(
      EstimateFeesPerGasParameters estimateFeesPerGasParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('estimateFeesPerGas');
        final result = await window.wagmiCore
            .estimateFeesPerGas(
          configKey.toJS,
          estimateFeesPerGasParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // estimate max priority fee per gas
  static Future<BigInt> estimateMaxPriorityFeePerGas(
      EstimateMaxPriorityFeePerGasParameters
      estimateMaxPriorityFeePerGasParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction(
          'estimateMaxPriorityFeePerGas',
        );
        final result = await window.wagmiCore
            .estimateMaxPriorityFeePerGas(
          configKey.toJS,
          estimateMaxPriorityFeePerGasParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // get byte code
  static Future<String> getBytecode(
      GetByteCodeParameters getByteCodeParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getBytecode');
        final result = await window.wagmiCore
            .getBytecode(
          configKey.toJS,
          getByteCodeParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // disconnect
  static Future<void> disconnect(
      DisconnectParameters disconnectParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('disconnect');
        await window.wagmiCore
            .disconnect(
          configKey.toJS,
          disconnectParameters.toJS,
        )
            .toDart;
      });

  static Future<WaitForTransactionReceiptReturnType> waitForTransactionReceipt(
      WaitForTransactionReceiptParameters waitForTransactionReceiptParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction(
          'waitForTransactionReceipt',
        );
        final result = await window.wagmiCore
            .waitForTransactionReceipt(
          configKey.toJS,
          waitForTransactionReceiptParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // get fee history
  static Future<GetFeeHistoryReturnType> getFeeHistory(
      GetFeeHistoryParameters getFeeHistoryParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getFeeHistory');
        final result = await window.wagmiCore
            .getFeeHistory(
          configKey.toJS,
          getFeeHistoryParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  static Future<Map<String, dynamic>> switchChain(
      SwitchChainParameters switchChainParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('switchChain');
        final result = await window.wagmiCore
            .switchChain(
          configKey.toJS,
          switchChainParameters.toJS,
        )
            .toDart;
        
        // Try different conversion strategies for WASM compatibility
        try {
          // First try: Use UtilsJS.dartify for the entire object
          final converted = UtilsJS.dartify(result);
          if (converted is Map<String, dynamic> && converted.isNotEmpty) {
            return converted;
          }
        } catch (_) {}
        
        // Second try: Use the JSChain's toDart method
        try {
          return result.toDart.toMap();
        } catch (_) {}
        
        // Fallback: Return basic info
        return {'id': 'Chain switched', 'result': 'Success'};
      });

  // switch account
  static Future<Map<String, dynamic>> switchAccount(
      SwitchAccountParameters switchAccountParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('switchAccount');
        final result = await window.wagmiCore
            .switchAccount(
          configKey.toJS,
          switchAccountParameters.toJS,
        )
            .toDart;
        return result.toMap();
      });

  // verify message
  static Future<bool> verifyMessage(
      VerifyMessageParameters verifyMessageParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('verifyMessage');
        final result = await window.wagmiCore
            .verifyMessage(
          configKey.toJS,
          verifyMessageParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // watch account
  static Future<void Function()> watchAccount(
      WatchAccountParameters watchAccountParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('watchAccount');
        final result = await window.wagmiCore
            .watchAccount(
          configKey.toJS,
          watchAccountParameters.toJSWatchAccount,
        )
            .toDart;
        return result.toDart;
      });

  // watch connections
  static Future<void Function()> watchConnections(
      WatchConnectionsParameters watchConnectionsParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('watchConnections');
        final result = await window.wagmiCore
            .watchConnections(
          configKey.toJS,
          watchConnectionsParameters.toJS2,
        )
            .toDart;
        return result.toDart;
      });

  // getWalletClient
  static Future<GetWalletClientReturnType> getWalletClient(
      GetWalletClientParameters getWalletClientParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('getWalletClient');
        final result = await window.wagmiCore
            .getWalletClient(
          configKey.toJS,
          getWalletClientParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  //deployContract
  static Future<String> deployContract(
      DeployContractParameters deployContractParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('deployContract');
        final result = await window.wagmiCore
            .deployContract(
          configKey.toJS,
          deployContractParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // watchAsset
  static Future<bool> watchAsset(
      WatchAssetParameters watchAssetParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('watchAsset');
        final result = await window.wagmiCore
            .watchAsset(
          configKey.toJS,
          watchAssetParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  // reconnect
  static Future<ReconnectReturnType> reconnect(
      ReconnectParameters reconnectParameters, {
        String configKey = 'default',
      }) =>
      _guardFuture(() async {
        _logAction('reconnect');
        final result = await window.wagmiCore
            .reconnect(
          configKey.toJS,
          reconnectParameters.toJS,
        )
            .toDart;
        return result.toDart;
      });

  /// Catches and transforms errors properly - WASM safe version
  static Future<T> _guardFuture<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      // WASM-safe error handling - check if it's actually a JSError before casting
      if (e is JSError) {
        throw e.toDart;
      } else {
        // For WASM compatibility, re-throw the original error
        // since it might be a Dart type error that can't be cast to JSError
        rethrow;
      }
    }
  }

  static T _guard<T>(T Function() action) {
    try {
      return action();
    } catch (e) {
      // WASM-safe error handling - check if it's actually a JSError before casting
      if (e is JSError) {
        throw e.toDart;
      } else {
        // For WASM compatibility, re-throw the original error
        // since it might be a Dart type error that can't be cast to JSError
        rethrow;
      }
    }
  }
}
