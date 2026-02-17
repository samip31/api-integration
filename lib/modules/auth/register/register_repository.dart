import 'dart:convert';

import 'package:democlass/service/api_client.dart';
import 'package:democlass/service/api_end_point.dart';

class RegisterRepository {
  final ApiClient apiClient = ApiClient();

  Future<ApiResponse<RegisterResponse>> register(jsonBody) async {
    final response = await apiClient.postApi<RegisterResponse>(
      ApiUrls.registerUrl,
      isTokenRequired: false,
      requestBody: jsonBody,
      fromJson: (json) => RegisterResponse.fromJson(json),
    );
    return response;
  }
}

class RegisterResponse {
  bool? response;
  String? msg;
  var result;

  RegisterResponse({this.response, this.msg, this.result});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}
