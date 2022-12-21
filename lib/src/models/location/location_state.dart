part of models;

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    UserLocation? location,
  }) = LocationState$;

  factory LocationState.fromJson(Map<String, dynamic> json) => _$LocationStateFromJson(Map<String, dynamic>.from(json));
}
