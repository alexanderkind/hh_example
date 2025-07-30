import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_driver_order_response.freezed.dart';
part 'task_driver_order_response.g.dart';

@freezed
class TaskDriverOrderResponse with _$TaskDriverOrderResponse {
  const factory TaskDriverOrderResponse({
    @JsonKey(name: 'chauffeur_name') String? chauffeurName,
    String? pickup,
    String? client,
    @JsonKey(name: 'number_of_passengers', fromJson: DefaultSerializer.intFromJsonNullable)
    int? numberOfPassengers,
    String? dropoff,
    @JsonKey(name: 'date_and_time_of_booking') String? dateAndTimeOfBooking,
    Vehicle? vehicle,
    @JsonKey(name: 'car_keeper') CarKeeper? carKeeper,
  }) = _TaskDriverOrderResponse;

  factory TaskDriverOrderResponse.fromJson(Map<String, Object?> json) =>
      _$TaskDriverOrderResponseFromJson(json);

  factory TaskDriverOrderResponse.fake() => TaskDriverOrderResponse(
        chauffeurName: 'Aaaaaaa Aaaaaaa',
        pickup: 'Aaaaa aaaaaaaa aaaa aaaaaaaaaa',
        client: 'Aaaaaaa Aaaaaaaa',
        numberOfPassengers: 0,
        carKeeper: CarKeeper.fake(),
        dropoff: 'Aaaaa aaaaaaaa aaaa aaaaaaaaaa',
        vehicle: Vehicle.fake(),
        dateAndTimeOfBooking: '16.12.2024 18:44',
      );
}

@freezed
class CarKeeper with _$CarKeeper {
  const factory CarKeeper({
    @JsonKey(name: 'is_active') int? isActive,
    int? id,
    String? name,
    String? address,
    String? tin,
    String? crn,
    String? iban,
    String? swift,
    int? vat,
  }) = _CarKeeper;

  factory CarKeeper.fromJson(Map<String, Object?> json) => _$CarKeeperFromJson(json);

  factory CarKeeper.fake() => const CarKeeper(
        name: 'Aaaaaaaa',
        address: 'Aaaaaaa aaaaa aaa aaaaaaaaaa',
      );
}

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    @JsonKey(name: 'is_own') int? isOwn,
    @JsonKey(name: 'is_rented') int? isRented,
    @JsonKey(name: 'is_active') int? isActive,
    int? id,
    @JsonKey(name: 'region_id') int? regionId,
    String? number,
    String? vin,
    String? make,
    String? model,
    String? color,
    int? capacity,
    @JsonKey(name: 'capacity_luggage') int? capacityLuggage,
    @JsonKey(name: 'vehicle_class_id') int? vehicleClassId,
    @JsonKey(name: 'car_status_id') int? carStatusId,
    String? notes,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, Object?> json) => _$VehicleFromJson(json);

  factory Vehicle.fake() => const Vehicle(
        make: 'Aaaaa',
        model: 'Aaaaa aa',
        number: 'Aaaaaaa',
      );
}
