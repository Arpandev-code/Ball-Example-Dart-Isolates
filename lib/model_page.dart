import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:lottie/lottie.dart';

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          "assets/ball.json",
        ),
        //Computing without isolates
        ElevatedButton(
            onPressed: () {
              double result = heavyTask();
              debugPrint(result.toString());
            },
            child: const Text("Task 1")),
        //Computing with isolates
        ElevatedButton(
            onPressed: () {
              ReceivePort receivePort = ReceivePort();
              Isolate.spawn(heavyTaskWithIsolate, receivePort.sendPort);
              receivePort.listen((messsage) => debugPrint(messsage.toString()));
            },
            child: const Text("Task 2")),
      ],
    )));
  }

  double heavyTask() {
    int result = 0;

    for (int i = 0; i < 1000000000; i++) {
      result = result + i;
    }
    return result.toDouble();
  }
}

//End of the class
heavyTaskWithIsolate(SendPort sendport) {
  int result = 0;

  for (int i = 0; i < 1000000000; i++) {
    result = result + i;
  }
  sendport.send(result);
}
