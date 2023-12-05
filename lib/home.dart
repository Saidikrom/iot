// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/services/products_service.dart';
import 'package:provider/provider.dart';
import 'provider/products.dart';
import 'provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<Services> streamController = StreamController();
  StreamController<Status> streamControllerS = StreamController();

  @override
  void initState() {
    getStatus();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getProducts();
    });
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    streamControllerS.close();
    super.dispose();
  }

  String _status = "OFF";

  String get status => _status;

  Future<void> getProducts() async {
    try {
      final dio = Dio();
      final url = Uri.parse(
          "https://plantwatering-8a3be-default-rtdb.firebaseio.com/Sensor.json");

      final response = await dio.getUri(url);
      final data = response.data as Map<String, dynamic>;
      Services firebaseData = Services.fromJson(data);
      streamController.sink.add(firebaseData);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> updateStatus(bool isSwitching) async {
    _status = isSwitching ? "ON" : "OFF";
    try {
      final dio = Dio();
      final url = Uri.parse(
          "https://plantwatering-8a3be-default-rtdb.firebaseio.com/WaterPump.json");

      await dio.patchUri(url, data: {'status': isSwitching ? 'ON' : 'OFF'});

      context.read<Products>().updateStatus(isSwitching: isSwitching);
    } catch (error) {
      print('Error updating status: $error');
    }
  }

  Future<void> getStatus() async {
    try {
      final dio = Dio();
      final url = Uri.parse(
          "https://plantwatering-8a3be-default-rtdb.firebaseio.com/WaterPump.json");

      final response = await dio.getUri(url);
      final data = response.data as Map<String, dynamic>;

      Status firebaseData = Status.fromJson(data);
      streamControllerS.sink.add(firebaseData);
      _status = firebaseData.status == "ON" ? "ON" : "OFF";
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var providers = Provider.of<Providers>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0ECE9),
                        image: DecorationImage(
                            image: AssetImage("assets/plant.jpg"),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0ECE9),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${snapshot.data!.humidity}%",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Humidity",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0ECE9),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${snapshot.data!.moisture}%",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Moisture",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0ECE9),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${snapshot.data!.temperature}°C",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "ON/OFF",
                          style: TextStyle(fontSize: 25),
                        ),
                        CupertinoSwitch(
                          activeColor: Colors.lightGreenAccent,
                          thumbColor: Colors.white,
                          trackColor: const Color(0xFF3F505A),
                          value: _status == "ON",
                          onChanged: (value) async {
                            updateStatus(value);
                            providers.onOFF(isSwitching: value);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0ECE9),
                        image: DecorationImage(
                            image: AssetImage("assets/plant.jpg"),
                            fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0ECE9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "....%",
                                    style:  TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Humidity",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0ECE9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "...%",
                                    style:  TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Moisture",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF0ECE9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "...°C",
                                    style:  TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Temperature",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "ON/OFF",
                          style: TextStyle(fontSize: 25),
                        ),
                        CupertinoSwitch(
                          activeColor: Colors.lightGreenAccent,
                          thumbColor: Colors.white,
                          trackColor: const Color(0xFF3F505A),
                          value: _status == "ON",
                          onChanged: (value) async {
                            updateStatus(value);
                            providers.onOFF(isSwitching: value);
                          },
                        ),
                      ],
                    ),
                    
                  ],
                );
              }
            },
          )
        ],
      ),
    );
  }
}
