import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import './exceptions.dart';

class APIManager {
  static dynamic _decodeResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body.toString());
      case 400:
        throw BadRequestException(message: response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(message: response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            message:
                'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }

  static Future<dynamic> postAPICall(Uri uri, String postBody) async {
    if (kDebugMode) {
      print("Calling POST API: $uri");
      print("[query parameters]: ${uri.queryParameters}");
      print("[body]: ${json.decode(postBody)}");
    }
    try {
      return _decodeResponse(
        await post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: postBody,
        ),
      );
    } on SocketException {
      throw const FetchDataException(message: 'No Internet connection');
    }
  }

  static Future<dynamic> getAPICall(Uri uri) async {
    if (kDebugMode) {
      print("Calling GET API: $uri");
      print("[query parameters]: ${uri.queryParameters}");
    }
    try {
      return _decodeResponse(
        await get(
          uri,
          headers: {"Content-Type": "application/json"},
        ),
      );
    } on SocketException {
      throw const FetchDataException(message: 'No Internet connection');
    }
  }
}
