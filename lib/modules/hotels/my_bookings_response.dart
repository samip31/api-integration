class MyBookingsResponse {
  bool? response;
  String? msg;
  List<Result>? result;

  MyBookingsResponse({this.response, this.msg, this.result});

  MyBookingsResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  String? userId;
  String? hotelId;
  String? checkIn;
  String? checkOut;
  String? status;
  Hotel? hotel;

  Result(
      {this.id,
        this.userId,
        this.hotelId,
        this.checkIn,
        this.checkOut,
        this.status,
        this.hotel});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    hotelId = json['hotel_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    status = json['status'];
    hotel = json['hotel'] != null ? new Hotel.fromJson(json['hotel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['hotel_id'] = this.hotelId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['status'] = this.status;
    if (this.hotel != null) {
      data['hotel'] = this.hotel!.toJson();
    }
    return data;
  }
}

class Hotel {
  int? id;
  String? name;
  String? description;
  String? pricePerNight;

  Hotel({this.id, this.name, this.description, this.pricePerNight});

  Hotel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pricePerNight = json['price_per_night'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price_per_night'] = this.pricePerNight;
    return data;
  }
}
