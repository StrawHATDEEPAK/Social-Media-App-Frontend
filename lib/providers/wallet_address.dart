import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

const _storage = FlutterSecureStorage();

class WalletAddressProvider extends ChangeNotifier {
  String? _privateKey;
  String? _walletAddress;
  // Future<String?>? get privateAddress async {
  //   return await _storage.read(key: "PRIVATE_KEY");
  // }

  String? get walletAddress => _walletAddress;
  void setAddress(String address) {
    _walletAddress = address;
    notifyListeners();
  }

  Future<String?>? readPrivateKey() {
    return _storage.read(key: "PRIVATE_KEY").then((value) => value);
  }

  void setPrivateKey({
    required String privateKey,
  }) async {
    await _storage.write(key: 'PRIVATE_KEY', value: privateKey);
  }
}
