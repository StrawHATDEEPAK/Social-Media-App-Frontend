import 'dart:convert';
import 'dart:math';
// import 'package:erc20/erc20.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:developer' as dev;

class DonateController extends ChangeNotifier {
  final String _rpcUrl =
      "https://eth-goerli.g.alchemy.com/v2/T6BVFFZrgZDT11Hpp3pOvYPs5B-TI6ZM";
  final String _wsurl =
      "ws://eth-goerli.g.alchemy.com/v2/T6BVFFZrgZDT11Hpp3pOvYPs5B-TI6ZM";

  // final String _privateKey =
  //     "d8a8fab212e8f342852cd3f8535f142cf112b9672c11b59a2451c6b613e63cb0";

  late Web3Client _client;

  late String _abiCode;

  // late Credentials _credentials;
  final EthereumAddress _contractAddress =
      EthereumAddress.fromHex('0x7663d2e76E6e58C2ACc2f2a8418a802eAaC5ee08');
  late DeployedContract _contract;

  late ContractFunction _donate;

  Future<String> donate(String credentials, String fromAddress,
      String toAddress, double amount) async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsurl).cast<String>();
    });
    await getAbi();
    dev.log(credentials);
    final Credentials _credentials = EthPrivateKey.fromHex(credentials);
    // await getCreadentials();

    await getDeployedContract();
    // const infuraId = 'adfc4b8e46eb43aeac02399b0c8107f2';
    // final client = Web3Client(
    //     'https://eth-goerli.g.alchemy.com/v2/T6BVFFZrgZDT11Hpp3pOvYPs5B-TI6ZM',
    //     Client());
    // final shibaInu = ERC20(
    //   address:
    //       EthereumAddress.fromHex('0x7663d2e76E6e58C2ACc2f2a8418a802eAaC5ee08'),
    //   client: client,
    // );
    // final result = await shibaInu.transfer(
    //     EthereumAddress.fromHex(toAddress), BigInt.from(amount),
    //     credentials: _credentials, transaction: Transaction(maxGas: 500000));
    // print(result);

    // final sender = Address.EthereumWalletConnectProvider(address: fromAddress);

// // Fetch the suggested transaction params
//     final params = await algorand.getSuggestedTransactionParams();

// // Build the transaction
//     final tx = await (PaymentTransactionBuilder()
//           ..sender = sender
//           ..noteText = 'Signed with WalletConnect'
//           ..amount = Algo.toMicroAlgos(0.0001)
//           ..receiver = sender
//           ..suggestedParams = params)
//         .build();

// // Sign the transaction
//     final signedBytes = await provider.signTransaction(
//       tx.toBytes(),
//       params: {
//         'message': 'Optional description message',
//       },
//     );

// // Broadcast the transaction
//     final txId = await algorand.sendRawTransactions(
//       signedBytes,
//       waitForConfirmation: true,
//     );

// // Kill the session
//     connector.killSession();
    // print(_credentials.address.toString());
    final result = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            maxGas: 500000,
            from: _credentials.address,
            contract: _contract,
            function: _donate,
            parameters: [
              EthereumAddress.fromHex(toAddress),
              BigInt.from(amount) * BigInt.from(pow(10, 18))
            ]),
        chainId: 5);
    dev.log(result);
    return 'Transaction Successfull !! \nTransaction Hash $result';

    // await _client.call(
    //     sender: EthereumAddress.fromHex(fromAddress),
    //     contract: _contract,
    //     function: _donate,
    //     params: [
    //       EthereumAddress.fromHex(toAddress),
    //       BigInt.from(amount)
    //     ]);
    // Transaction.callContract(
    //     maxGas: 10000,
    //     from: EthereumAddress.fromHex(fromAddress),
    //     contract: _contract,
    //     function: _donate,
    //     parameters: [
    //       EthereumAddress.fromHex(toAddress),
    //       BigInt.from(amount)
    //     ]);
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle
        .loadString('contracts/build/contracts/FoxxiToken.json');
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
  }

  // Future<void> getCreadentials() async {
  //   _credentials = EthPrivateKey.fromHex(_privateKey);
  // }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "FoxxiToken"), _contractAddress);
    _donate = _contract.function("transfer");
  }
}
