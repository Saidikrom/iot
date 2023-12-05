import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  static Map<String, dynamic>? firebaseData;
  Future<void> getProducts() async {
    final dio = Dio();
    final url = Uri.parse(
        "https://plantwatering-8a3be-default-rtdb.firebaseio.com/Sensor.json");
    try {
      final response = await dio.getUri(url);
      final data = response.data as Map<String, dynamic>;
      firebaseData = data;
    } catch (e) {
      rethrow;
    }
  }

  String _status = "OFF";

  String get status => _status;


  Future<void> updateStatus({required bool isSwitching}) async {
    final dio = Dio();
    _status = isSwitching ? "ON" : "OFF";
    notifyListeners();
    final url = Uri.parse(
        "https://plantwatering-8a3be-default-rtdb.firebaseio.com/WaterPump.json");

    http.patch(url, body: jsonEncode({"status": _status}));
    try {
      final response = await dio.getUri(url, data: {"status": "OFF"});

      if (response.statusCode == 200) {
        print("Status updated successfully: $_status");
      } else {
        print("Error updating status: ${response.statusCode}");
      }
    } catch (e) {
      print("Dio error: $e");
      rethrow;
    }
  }
}
