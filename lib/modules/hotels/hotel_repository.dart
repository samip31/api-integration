import 'package:democlass/modules/hotels/hotel_book_response.dart';
import 'package:democlass/modules/hotels/my_bookings_response.dart';
import 'package:democlass/service/api_client.dart';
import 'package:democlass/service/api_end_point.dart';

import 'cancel_hotel_response.dart';
import 'hotel_list_response.dart';

class HotelRepository {
  final ApiClient apiClient = ApiClient();

  Future<ApiResponse<HotelListResponse>> getHotelList() async {
    final response = await apiClient.getApi(
      ApiUrls.hotelListUrl,
      isTokenRequired: false,
      fromJson: (json) => HotelListResponse.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<HotelBookResponse>> bookHotel(jsonBody) async {
    final response = await apiClient.postApi(
      ApiUrls.bookHotelUrl,
      isTokenRequired: true,
      requestBody: jsonBody,
      fromJson: (json) => HotelBookResponse.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<CancelBookingResponse>> cancelBooking(jsonBody) async {
    final response = await apiClient.postApi(
      ApiUrls.cancelBookingUrl,
      isTokenRequired: true,
      requestBody: jsonBody,
      fromJson: (json) => CancelBookingResponse.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse<MyBookingsResponse>> getMyBookings() async {
    final response = await apiClient.getApi(
      ApiUrls.myBookingsUrl,
      isTokenRequired: true,
      fromJson: (json) => MyBookingsResponse.fromJson(json),
    );
    return response;
  }
}
