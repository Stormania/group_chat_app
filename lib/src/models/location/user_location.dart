part of models;

@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double lat,
    required double long,
  }) = UserLocation$;

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(Map<String, dynamic>.from(json));
}
