class HotelBookResponse {
  bool? response;
  String? msg;
  Result? result;

  HotelBookResponse({this.response, this.msg, this.result});

  HotelBookResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? hotelId;
  String? checkIn;
  String? checkOut;
  String? status;
  int? id;

  Result(
      {this.userId,
        this.hotelId,
        this.checkIn,
        this.checkOut,
        this.status,
        this.id});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    hotelId = json['hotel_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['hotel_id'] = this.hotelId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['status'] = this.status;
    data['id'] = this.id;
    return data;
  }
}
