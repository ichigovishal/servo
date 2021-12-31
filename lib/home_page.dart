// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double>? accelerometerValues;
  List<double>? userAccelerometerValues;
  List<double>? gyroscopeValues;
  List<double>? magnetometerValues;
  List<StreamSubscription<Object>> listerners = [];

  bool stopData = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }


startScan() async {
try {
    String? address;
    BluetoothConnection connection = await BluetoothConnection.toAddress(address);
    print('Connected to the device');

    connection.input!.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');
        connection.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
            connection.finish(); // Closing connection
            print('Disconnecting by local host');
        }
    }).onDone(() {
        print('Disconnected by remote request');
    });
}
catch (exception) {
    print('Cannot connect, exception occured');
}
}

  sensorData() {
    listerners.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        gyroscopeValues = [event.x, event.y];
      });
    }));
    listerners.add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerValues = [event.x, event.y];
      });
    }));
    listerners
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        userAccelerometerValues = [event.x, event.y];
      });
    }));
    listerners.add(magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        magnetometerValues = [event.x, event.y];
      });
    }));
  }

  cancelSensorData() {
    if (listerners.isNotEmpty) {
      for (var listerner in listerners) {
        listerner.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
              onPressed: () => setState(() {
                    stopData = !stopData;
                    if (stopData)
                      sensorData();
                    else
                      cancelSensorData();
                  }),
              label: Text(stopData == false ? "Get Data" : "Stop Data")),
        ],
      ),
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(userAccelerometerValues == null || gyroscopeValues == null
                ? " Press get data below to get Value"
                : """
                Gyro \n X-Axis: ${gyroscopeValues?[0].toString()}\n  Y-Axis: ${gyroscopeValues?[1].toString()}
                \n\n
                Accelerometer \n  X-Axis: ${accelerometerValues?[0].toString()} \n Y-Axis: ${accelerometerValues?[1].toString()}
                \n\n
                UserAccelerometer\n  X-Axis: ${userAccelerometerValues?[0].toString()} \n Y-Axis: ${userAccelerometerValues?[1].toString()}
                \n\n
                Magnetometer\n  X-Axis: ${magnetometerValues?[0].toString()}\n  Y-Axis: ${magnetometerValues?[1].toString()}
                \n\n
                """),
          ],
        ),
      ),
    );
  }
}
