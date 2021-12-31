// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   sensorData();
  // }

  @override
  void dispose() {
    if (stopData) {
      sensorData();
    }
    super.dispose();
  }

  sensorData() {
    listerners.add(
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        gyroscopeValues = [event.x, event.y];
      });
      gyroscopeEvents.listen((event) { }).pause();
    }));
    listerners.add(
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerValues = [event.x, event.y];
      });
    }));
     listerners.add(
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        userAccelerometerValues = [event.x, event.y];
      });
    }));
     listerners.add(
    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        magnetometerValues = [event.x, event.y];
      });
    }));
  }
  cancelSensorData(){
    
    if (listerners.isNotEmpty){
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
              onPressed: () => sensorData(), label: const Text("Get Data")),
          const SizedBox(height: 20),
          FloatingActionButton.extended(
              onPressed: () => cancelSensorData(), label: const Text("Stop Data")),
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
