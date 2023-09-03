import 'dart:typed_data';

import 'package:comm_client/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';

class ClientController extends GetxController {
  ClientModel? clientModel;
  List<String> logs = [];
  int port = 6677;
  Stream<NetworkAddress>? stream;
  NetworkAddress? address;
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    getIpAdd();
    super.onInit();
  }

  void getIpAdd() {
    stream = NetworkAnalyzer.discover2("192.168.1", port);
    stream!.listen((NetworkAddress networkAddress) {
      if (networkAddress.exists) {
        print("Network added");
        address = networkAddress;
        clientModel = ClientModel(networkAddress.ip, port, onData, onError);
      }
    });
    update();
  }

  void onData(Uint8List data) {
    String message = String.fromCharCodes(data);
    logs.add(message);
    update();
  }

  void onError(dynamic error) {
    debugPrint("Error: $error");
  }

  void sendMEssage(String message) {
    clientModel!.write(message);
  }
}
