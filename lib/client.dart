import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef Uint8ListCallback = Function(Uint8List data);
typedef DynamicCallback = Function(dynamic data);

final deviceInfo = DeviceInfoPlugin();

class ClientModel {
  String hostname;
  int port;
  Uint8ListCallback? onData;
  DynamicCallback? onError;

  ClientModel(this.hostname, this.port, this.onData, this.onError);

  bool isConnected = false;
  Socket? socket;

  Future<void> connect() async {
    try {
      print("Connect $hostname");
      socket = await Socket.connect(hostname, port);
      socket!.listen(onData, onError: onError, onDone: () async {
        print("Done");
        final info = await deviceInfo.androidInfo;
        disconnect(info);
        isConnected = false;
      });
      isConnected = true;
      print("connected");
    } catch (e) {
      debugPrint("Error in conncection: $e");
    }
  }

  void write(String message) {
    print("Writting");
    print(socket);
    socket!.write(message);
  }

  void disconnect(AndroidDeviceInfo androidDeviceInfo) {
    final message =
        "${androidDeviceInfo.brand} ${androidDeviceInfo.device} got disconnect";
    write(message);
    if (socket != null) {
      socket!.destroy();
    }
    isConnected = false;
  }
}
