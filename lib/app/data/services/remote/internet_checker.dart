import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class InternetChecker {
  Future<bool> hasInternet() async {
    try {
      if (kIsWeb) {
        final response = await get(
          Uri.parse('8.8.8.8'),
        );
        return response.statusCode == 200;
      } else {
        final list = await InternetAddress.lookup('8.8.8.8');
        return list.isNotEmpty && list.first.rawAddress.isNotEmpty;
      }
    } catch (e) {
      debugPrint("😭 Exception : $e", wrapWidth: 1024);
      return false;
    }
  }
}
