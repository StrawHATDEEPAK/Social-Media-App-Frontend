import 'dart:convert';
import 'dart:math';
import 'dart:io';
// import 'package:erc20/erc20.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:foxxi/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:provider/provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;

  return File('$path/metadata.json').create(recursive: true);
}

Future<File> write(String val) async {
  final file = await _localFile;

  return file.writeAsString(val);
}

class NFTMetaData {
  String? url;
  String? name;
  String? description;
  NFTMetaData({this.url, this.name, this.description});
  Map toJson() => {
        'name': name,
        'url': url,
        'description': description,
      };
}

class MintController extends ChangeNotifier {
  final String _rpcUrl =
      "https://eth-goerli.g.alchemy.com/v2/T6BVFFZrgZDT11Hpp3pOvYPs5B-TI6ZM";
  final String _wsurl =
      "ws://eth-goerli.g.alchemy.com/v2/T6BVFFZrgZDT11Hpp3pOvYPs5B-TI6ZM";

  late Web3Client _client;

  late String _abiCode;

  // late Credentials _credentials;
  final EthereumAddress _contractAddress =
      EthereumAddress.fromHex('0xe5d7ed23ca823B38d0C245202910E3721097d5c9');
  late DeployedContract _contract;

  late ContractFunction _mint;

  Future<String> mint(String credentials, String uri, String name) async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsurl).cast<String>();
    });
    await getAbi();
    final Credentials _credentials = EthPrivateKey.fromHex(credentials);
    // await getCreadentials();

    await getDeployedContract();
    uri = 'ipfs://$uri';
    NFTMetaData metadata =
        NFTMetaData(url: uri, name: name, description: 'Minted NFT');
    String data = jsonEncode(metadata);
    final path = await write(data);

    final cid = await FlutterIpfs().uploadToIpfs(path.uri.toFilePath());

    String uri2 = 'ipfs://$cid';

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
    String? result;
    String? error;
    try {
      result = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              maxGas: 500000,
              from: _credentials.address,
              contract: _contract,
              function: _mint,
              parameters: [uri2]),
          chainId: 5);
    } catch (e) {
      error = e.toString();
    }
    if (error == null) {
      return 'Transaction Successfull !! \nTransaction Hash $result';
    } else {
      return error;
    }

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
    String abiStringFile =
        await rootBundle.loadString('contracts/build/contracts/ipfsNFT.json');
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
  }

  // Future<void> getCreadentials() async {
  //   _credentials = EthPrivateKey.fromHex(_privateKey);
  // }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "ipfsNFT"), _contractAddress);
    _mint = _contract.function("staticMint");
  }
}
