import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/auth/login/login_controller.dart';
import 'api_end_point.dart';
class ApiClient {

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<ApiResponse<T>> getApi<T>(
      String endPoint, {
        required bool isTokenRequired,
        T Function(dynamic json)? fromJson,
      }) async {
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (isTokenRequired) {
      String? authToken = await _getToken();

      if (authToken == null) {
        // loginController.logout();
        return ApiResponse.error("No authentication token found");
      }

      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      };
    }

    try {
      log('HITTING URL: ${ApiUrls.baseUrl + endPoint}');
      log("HEADERS: $header");

      final response = await http.get(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: header,
      );

      log(response.statusCode.toString());
      log('RESPONSE FROM THE GET URL : ${ApiUrls.baseUrl + endPoint} : ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final utfDecoded = utf8.decode(response.bodyBytes);
        final json = jsonDecode(utfDecoded);



        final data = fromJson != null ? fromJson(json) : json as T;
        return ApiResponse.completed(data);
      } else if (response.statusCode == 403) {
        return ApiResponse.error("User has been suspended");
      } else {
        final res = jsonDecode(response.body);
        final message = res['message'].toString();

        await _handleTokenErrors(message);

        return ApiResponse.error(message);
      }
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } catch (e) {
      debugPrint('error ::${e.toString()}');
      return ApiResponse.error("Something went wrong. Please try again later");
    }
  }

  Future<ApiResponse<T>> postApi<T>(
      String endPoint, {
        dynamic requestBody,
        T Function(dynamic json)? fromJson,
        required bool isTokenRequired,
        Map<String, dynamic>? imageBody,
        bool? isMultiPartRequest,
        String? token,
      }) async {
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    print(requestBody);
    print(imageBody);
    print(isMultiPartRequest ?? "Multi");

    if (isTokenRequired) {
      String? authToken;

      if (token != null) {
        authToken = token;
      } else {
        authToken = await _getToken();
      }

      if (authToken == null) {
        // loginController.logout();
        return ApiResponse.error("No authentication token found");
      }

      print("Token is needed. This line represents token being required.");
      print("Token: $authToken");

      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      };

      print(header);
    }

    log('HITTING URL: ${ApiUrls.baseUrl + endPoint}');

    try {
      if (isMultiPartRequest ?? false) {
        print("Multipart request");
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(ApiUrls.baseUrl + endPoint),
        );
        request.headers.addAll(header);

        print(requestBody);
        requestBody.forEach((key, value) {
          request.fields[key] = value;
        });

        print("Header");
        print(request.headers.toString());

        if (imageBody != null) {
          for (var entry in imageBody.entries) {
            if (entry.value is List) {
              for (var imagePath in entry.value) {
                var file = await http.MultipartFile.fromPath(
                  entry.key,
                  imagePath,
                );
                request.files.add(file);
                print("photo: $imagePath");
              }
            } else if (entry.value is String) {
              var file = await http.MultipartFile.fromPath(
                entry.key,
                entry.value,
              );
              request.files.add(file);
              print("photo: ${entry.value}");
            }
          }
        }

        log("Sending request");
        print(request.headers);
        final response = await request.send();

        log("Response received");
        log("Code: ${response.statusCode}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("API CALL SUCCESSFUL");
          final json = await response.stream.bytesToString();
          log("JSON RAW: $json");

          if (jsonDecode(json)['success'] != true) {
            return ApiResponse.error(
              jsonDecode(json)['message']?.toString() ?? "Request failed",
            );
          }

          final data = fromJson != null
              ? fromJson(jsonDecode(json))
              : json as T;

          debugPrint(data.toString());
          return ApiResponse.completed(data);
        } else {
          print("error");
          final json = await response.stream.bytesToString();
          log(json);
          final message = jsonDecode(json)['message'].toString();

          await _handleTokenErrors(message);

          return ApiResponse.error(message);
        }
      } else {
        final response = await http.post(
          Uri.parse(ApiUrls.baseUrl + endPoint),
          headers: header,
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final json = jsonDecode(response.body);
          debugPrint("Request Successful: $json");


          final data = fromJson != null ? fromJson(json) : json as T;
          debugPrint(data.toString());
          return ApiResponse.completed(data);
        } else {
          final message = jsonDecode(response.body)['message'].toString();

          await _handleTokenErrors(message);

          return ApiResponse.error(message);
        }
      }
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } catch (e) {
      log(requestBody.toString());
      print("Error: ${e.toString()}");
      debugPrint(e.toString());
      return ApiResponse.error("Something went wrong. Please try again later");
    }
  }

  Future<ApiResponse<T>> putApi<T>(
      String endPoint, {
        required Map<String, dynamic> requestBody,
        T Function(dynamic json)? responseType,
        required bool isTokenRequired,
        Map<String, dynamic>? imageBody,
      }) async {
    var header = {"Accept": "application/json"};

    if (isTokenRequired) {
      String? authToken = await _getToken();

      if (authToken == null) {
        // loginController.logout();
        return ApiResponse.error("No authentication token found");
      }

      header = {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      };
    }

    try {
      debugPrint("${ApiUrls.baseUrl}$endPoint");
      debugPrint(requestBody.toString());

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse("${ApiUrls.baseUrl}$endPoint"),
      );
      request.headers.addAll(header);

      requestBody.forEach((key, value) async {
        if (key.toString() == 'recentPhoto') {
          var file = await http.MultipartFile.fromPath(key, value);
          request.files.add(file);
        }
        request.fields[key] = value.toString();
      });

      if (imageBody != null) {
        for (var entry in imageBody.entries) {
          if (entry.value is List) {
            for (var imagePath in entry.value) {
              var file = await http.MultipartFile.fromPath(
                entry.key,
                imagePath,
              );
              request.files.add(file);
              print("photo: $imagePath");
            }
          } else if (entry.value is String) {
            var file = await http.MultipartFile.fromPath(
              entry.key,
              entry.value,
            );
            request.files.add(file);
            print("photo: ${entry.value}");
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      debugPrint(response.body);

      if (streamedResponse.statusCode == 200) {
        debugPrint(response.body);
        final json = jsonDecode(response.body);



        final data = responseType != null ? responseType(json) : json as T;
        return ApiResponse.completed(data);
      } else {
        String message = jsonDecode(response.body)["message"] ??
            jsonDecode(response.body)["error"];
        print(message);

        await _handleTokenErrors(message);

        return ApiResponse.error(message);
      }
    } on SocketException {
      return ApiResponse.error("No internet connection");
    } catch (e) {
      debugPrint("Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    }
  }

  Future<ApiResponse<T>> deleteApi<T>(
      String endPoint, {
        Map<String, dynamic>? requestBody,
        T Function(dynamic json)? responseType,
        required bool isTokenRequired,
      }) async {
    var header = {"Accept": "application/json"};

    if (isTokenRequired) {
      String? authToken = await _getToken();

      if (authToken == null) {
        // loginController.logout();
        return ApiResponse.error("No authentication token found");
      }

      header = {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      };
    }

    try {
      debugPrint("${ApiUrls.baseUrl}$endPoint");
      debugPrint(requestBody.toString());

      final response = await http.delete(
        Uri.parse("${ApiUrls.baseUrl}$endPoint"),
        headers: header,
        body: requestBody,
      );

      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        final json = jsonDecode(response.body);

        final data = responseType != null ? responseType(json) : json as T;
        return ApiResponse.completed(data);
      } else {
        debugPrint(response.statusCode.toString());
        final message = ApiMessage().getMessage(response.statusCode);
        debugPrint(response.body);

        await _handleTokenErrors(message);

        return ApiResponse.error(message);
      }
    } on SocketException {
      return ApiResponse.error("No internet connection");
    } catch (e) {
      debugPrint("Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    }
  }

  // Helper method to handle token-related errors
  Future<void> _handleTokenErrors(String message) async {
    if (message == "Unauthenticated.") {
      // loginController.logout();
    } else if (message == "Expired token") {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken");
      if (refreshToken != null) {
        // loginController.generateNewToken(refreshToken);
      } else {
        // loginController.logout();
      }
    } else if (message == "Invalid refresh token") {
      print("Invalid token coming");
      // loginController.logout();
    } else if (message == "Your employment status is INACTIVE. Please contact HR.") {
      // loginController.logout();
    }
  }
}

class ApiResponse<T> {
  ApiStatus? status;
  T? response;
  String? message;

  ApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  ApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;

  ApiResponse.completed(this.response)
      : status = ApiStatus.SUCCESS,
        message = null;

  ApiResponse.error(this.message)
      : status = ApiStatus.ERROR,
        response = null;

  @override
  String toString() {
    return "Status: $status \n Message: $message \n Response: $response";
  }
}

class ApiMessage {
  String getMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return "Success";
      case 400:
        return "Bad Request";
      case 401:
        return "Unauthorized";
      case 404:
        return "Not Found";
      case 500:
        return "Internal Server Error";
      default:
        return "Oops! Something went wrong. Error code: $statusCode";
    }
  }
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }