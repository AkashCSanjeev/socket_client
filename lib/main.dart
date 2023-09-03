import 'package:comm_client/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: GetBuilder<ClientController>(
          init: ClientController(),
          builder: (controller) {
            return Column(
              children: [
                Container(
                  child: controller.address == null
                      ? Text("No device found")
                      : TextButton(
                          onPressed: () async {
                            await controller.clientModel!.connect();
                            final info = await deviceInfo.androidInfo;
                            print(controller.clientModel);
                            print(controller.clientModel!.hostname);
                            controller.clientModel!.write(
                                "message from : ${info.brand} ${info.device}");
                            setState(() {});
                          },
                          child: Text(
                              "${controller.address!.ip} ${controller.clientModel!.isConnected}"),
                        ),
                ),
                ElevatedButton(
                    onPressed: controller.getIpAdd, child: Text("Search")),
                ElevatedButton(
                    onPressed: () async {
                      final info = await deviceInfo.androidInfo;
                      controller.clientModel!.disconnect(info);
                      setState(() {});
                    },
                    child: Text("Disconnect")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller.textEditingController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      controller.clientModel!
                          .write(controller.textEditingController.text);
                    },
                    child: Text("Send")),
                Expanded(
                  child: ListView(
                    children: controller.logs.map((e) => Text("$e")).toList(),
                  ),
                )
              ],
            );
          },
        ));
  }
}
