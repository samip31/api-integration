import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:leadslanes/app/widgets/custom_snackbar.dart';

import '../../config/prefs.dart';
import '../../modules/auth/login/login_controller.dart';
import '../../modules/auth/user_controller.dart';
import 'api_end_point.dart';

class ApiClient {


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
      String authToken = userController.userData[userToken] ?? "";
      if (userController.userData[userToken] == null) {
        loginController.logout();
      }
      // if(authToken == null){
      //
      //   print("null ");
      // CustomSnackbar().getSnackBar(type: "Error", message: "no Token");
      // }
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      };
    }
    try {
      log('HITTING URL: ${ApiUrls.baseUrl + endPoint}');
      log("HEADERS: ${header}");
      final response = await http.get(
        Uri.parse(ApiUrls.baseUrl + endPoint),
        headers: header,
      );
      log(response.statusCode.toString());
      // log(response.statusCode.toString());
      // log(response.body);
      log(
        'RESPONSE FROM THE GET URL : ${ApiUrls.baseUrl + endPoint} : ${response.body}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // log("URL ${ApiUrls.baseUrl + endPoint} HITTING SUCCESSFULL");
        final utfDecoded = utf8.decode(response.bodyBytes);
        final json = jsonDecode(utfDecoded);
        if (json['success'] != true) {
          return ApiResponse.error(
            json['message']?.toString() ?? "Request failed",
          );
        }
        final data = fromJson != null ? fromJson(json) : json as T;
        return ApiResponse.completed(data);
      } else if (response.statusCode == 403) {
        // loginController.logout();
        return ApiResponse.error("User has been suspended");
      } else {
        final res = jsonDecode(response.body);
        final message = res['message'].toString();
        if (message == "Unauthenticated.") {
          loginController.logout();
        }
        if (message == "Expired token") {
          loginController.generateNewToken(
            userController.userData["refreshToken"],
          );
          // loginController.logout();
        }
        if (message == "Invalid refresh token") {
          print("Invalid token coming");
          //loginController.generateNewToken(userController.userData["refreshToken"]);
          loginController.logout();
        }
        if (message ==
            "Your employment status is INACTIVE. Please contact HR.") {
          loginController.logout();
        }
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
        requestBody,
        T Function(dynamic json)? responseType,
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
    print(isMultiPartRequest ?? "Mutlti");

    if (isTokenRequired) {
      if (userController.userData[userToken] == null) {
        loginController.logout();
      }
      print("Token is needed. This line represents token being required.");
      print("Token");
      String authToken = userController.userData[userToken]??"";
      print(authToken);
      print("fsauhufa");
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token == null ? "Bearer $authToken" : "Bearer $token",
      };
      print(header);
      print(authToken);
    }

    log('HITTING URL: ${ApiUrls.baseUrl + endPoint}');

    try {
      if (isMultiPartRequest ?? false) {
        print("fasoifajs00");
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
          //   for (var entry in imageBody.entries) {
          //     var file = await http.MultipartFile.fromPath(entry.key, entry.value);
          //     request.files.add(file);
          //   }
          // }

          // if (imageBody != null) {
          //   for (var imagePath in imageBody["images"]) {
          //     print("Files");
          //     // Create a MultipartFile from the file path
          //     var file = await http.MultipartFile.fromPath('images', imagePath);
          //     print(file);
          //     // Add the file to the request
          //     request.files.add(file);
          //   }

          for (var entry in imageBody.entries) {
            if (entry.value is List<String>) {
              for (var imagePath in entry.value) {
                var file = await http.MultipartFile.fromPath(
                  entry.key,
                  imagePath,
                );
                request.files.add(file);
                print("photo: $imagePath");
              }
            } else if (entry.value is String) {
              // Handle the case where a single image is passed as a String
              var file = await http.MultipartFile.fromPath(
                entry.key,
                entry.value,
              );
              request.files.add(file);
              print("photo: ${entry.value}");
            }
          }
        }

        log("Response ta auna parne");
        print(request.headers);
        final response = await request.send();
        log("Response ta auna parne");
        log("COde:${response.statusCode}");
        log(response.statusCode.toString());

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("API CALL SUCCESSFULL");
          final json = await response.stream.bytesToString();
          log("JSON RAW");
          log(json);
          if (jsonDecode(json)['success'] != true) {
            return ApiResponse.error(
              jsonDecode(json)['message']?.toString() ?? "Request failed",
            );
          }
          log("JSON DECODE");
          final message = jsonDecode(json)['message'].toString();
          print("DAtaaaa");
          final data =
          responseType != null ? responseType(jsonDecode(json)) : json as T;
          debugPrint(data.toString());
          print("tala");
          return ApiResponse.completed(data);
        } else {
          print("error");
          final json = await response.stream.bytesToString();
          log(json);
          final message = jsonDecode(json)['message'].toString();
          if (message == "Unauthenticated.") {
            loginController.logout();
          }
          if (message == "Expired token") {
            loginController.generateNewToken(
              userController.userData["refreshToken"],
            );
          }
          if (message == "Invalid refresh token") {
            print("Invalid token coming");
            //loginController.generateNewToken(userController.userData["refreshToken"]);
            loginController.logout();
          }
          if (message ==
              "Your employment status is INACTIVE. Please contact HR.") {
            loginController.logout();
          }
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
          debugPrint("Login Successful: $json");
          if (json['success'] != true) {
            return ApiResponse.error(
              json['message']?.toString() ?? "Request failed",
            );
          }
          final data = responseType != null ? responseType(json) : json as T;
          debugPrint(data.toString());
          return ApiResponse.completed(data);
        } else {
          final message = jsonDecode(response.body)['message'].toString();
          if (message == "Unauthenticated.") {
            loginController.logout();
          }
          if (message == "Expired token") {
            loginController.generateNewToken(
              userController.userData["refreshToken"],
            );

            // loginController.logout();
          }
          if (message == "Invalid refresh token") {
            print("Invalid token coming");
            //loginController.generateNewToken(userController.userData["refreshToken"]);
            loginController.logout();
          }
          if (message ==
              "Your employment status is INACTIVE. Please contact HR.") {
            loginController.logout();
          }
          return ApiResponse.error(message);
        }
      }
    } on SocketException {
      return ApiResponse.error("No Internet Connection");
    } catch (e) {
      log(requestBody.toString());
      print("down ${e.toString()} down");
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
      if (userController.userData[userToken] == null) {
        loginController.logout();
      }
      header = {
        "Accept": "application/json",
        "Authorization": "Bearer ${storage.read(userToken)}",
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
      // if (imageBody != null) {
      //   imageBody.forEach((key, value) async {
      //     var file = await http.MultipartFile.fromPath(key, value);
      //     request.files.add(file);
      //   });
      // }
      if (imageBody != null) {
        for (var entry in imageBody.entries) {
          if (entry.value is List<String>) {
            for (var imagePath in entry.value) {
              var file = await http.MultipartFile.fromPath(
                entry.key,
                imagePath,
              );
              request.files.add(file);
              print("photo: $imagePath");
            }
          } else if (entry.value is String) {
            // Handle the case where a single image is passed as a String
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
      // final response = await http.Response.fromStream(streamedResponse);
      if (streamedResponse.statusCode == 200) {
        debugPrint(response.body);
        final json = jsonDecode(response.body);
        if (json['success'] != true) {
          return ApiResponse.error(
            json['message']?.toString() ?? "Request failed",
          );
        }
        final data = responseType != null ? responseType(json) : json as T;
        return ApiResponse.completed(data);
      } else {
        print("samip ${jsonDecode(response.body)["message"]}");
        String message =
            jsonDecode(response.body)["message"] ??
                jsonDecode(response.body)["error"];
        print(message);
        // debugPrint(streamedResponse.statusCode.toString());
        // print(response.body);
        // String message = '';
        // final message = ApiMessage().getMessage(streamedResponse.statusCode);
        // final message = jsonDecode(response.body)['message'].toString();
        // debugPrint(await streamedResponse.stream.bytesToString());
        if (message == "Unauthenticated.") {
          loginController.logout();
        }
        if (message == "Expired token") {
          loginController.generateNewToken(
            userController.userData["refreshToken"],
          );
          // loginController.logout();
        }
        if (message == "Invalid refresh token") {
          print("Invalid token coming");
          loginController.logout();
        }
        if (message ==
            "Your employment status is INACTIVE. Please contact HR.") {
          loginController.logout();
        }
        return ApiResponse.error(message);
      }
    } on SocketException {
      return ApiResponse.error("No internet connection");
    } catch (e) {
      debugPrint("Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
    }

    //   final response = await http.put(
    //     Uri.parse("${ApiUrls.baseUrl}$endPoint"),
    //     headers: header,
    //     body: requestBody,
    //   );
    //   log(response.statusCode.toString());
    //   if (response.statusCode == 200) {
    //     debugPrint(response.body);
    //     final json = jsonDecode(response.body);
    //     final data = responseType != null ? responseType(json) : json as T;
    //     return ApiResponse.completed(data);
    //   } else {
    //     debugPrint(response.statusCode.toString());
    //
    //     final message = ApiMessage().getMessage(response.statusCode);
    //     debugPrint(response.body);
    //     return ApiResponse.error(message);
    //   }
    // } on SocketException {
    //   return ApiResponse.error("No internet connection");
    // } catch (e) {
    //   debugPrint("Error: $e");
    //   return ApiResponse.error("Something went wrong. Please try again later");
    // }
  }

  Future<ApiResponse<T>> deleteApi<T>(
      String endPoint, {
        Map<String, dynamic>? requestBody,
        T Function(dynamic json)? responseType,
        required bool isTokenRequired,
      }) async {
    var header = {"Accept": "application/json"};
    if (isTokenRequired) {
      if (userController.userData[userToken] == null) {
        loginController.logout();
      }
      header = {
        "Accept": "application/json",
        "Authorization": "Bearer ${storage.read(userToken)}",
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
        if (json['success'] != true) {
          return ApiResponse.error(
            json['message']?.toString() ?? "Request failed",
          );
        }
        final data = responseType != null ? responseType(json) : json as T;
        return ApiResponse.completed(data);
      } else {
        debugPrint(response.statusCode.toString());

        final message = ApiMessage().getMessage(response.statusCode);
        debugPrint(response.body);
        if (message == "Unauthenticated.") {
          loginController.logout();
        }
        if (message == "Expired token") {
          loginController.generateNewToken(
            userController.userData["refreshToken"],
          );
          // loginController.logout();
        }
        if (message == "Invalid refresh token") {
          print("Invalid token coming");
          //loginController.generateNewToken(userController.userData["refreshToken"]);
          loginController.logout();
        }
        if (message ==
            "Your employment status is INACTIVE. Please contact HR.") {
          loginController.logout();
        }
        return ApiResponse.error(message);
      }
    } on SocketException {
      return ApiResponse.error("No internet connection");
    } catch (e) {
      debugPrint("Error: $e");
      return ApiResponse.error("Something went wrong. Please try again later");
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

  ApiResponse.error(this.message) : status = ApiStatus.ERROR, response = null;

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
    // case 403:
    //   return "Forbidden";
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
