import '../../../service/api_client.dart';
import '../../../service/api_end_point.dart';

class LoginRepository {
  final ApiClient apiClient = ApiClient();

  Future<ApiResponse<LoginResponse>> login(jsonBody) async {
    final response = await apiClient.postApi<LoginResponse>(
      ApiUrls.loginUrl,
      isTokenRequired: false,
      requestBody: jsonBody,
      fromJson: (json) => LoginResponse.fromJson(json),
    );
    return response;
  }
}


class LoginResponse {
  bool? response;
  String? msg;
  Result? result;

  LoginResponse({this.response, this.msg, this.result});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    msg = json['msg'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? token;

  Result({this.token});

  Result.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
