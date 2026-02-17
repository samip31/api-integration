import 'package:democlass/modules/hotels/hotel_repository.dart';
import 'package:democlass/service/api_client.dart';
import 'package:get/get.dart';

import 'hotel_list_response.dart';

class HotelController extends GetxController {
  HotelRepository hotelRepository = HotelRepository();
  RxList<Result?> hotels = <Result?>[].obs;

  getHotels() async {
    final response = await hotelRepository.getHotelList();
    if (response.status == ApiStatus.SUCCESS) {
      hotels.value = response!.response!.result ?? [];
    }
    print(hotels.length);
  }

  @override
  void onInit() {
    getHotels();
    // TODO: implement onInit
    super.onInit();
  }
}
