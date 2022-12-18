part of actions;

@freezed
class UpdatePhoto with _$UpdatePhoto {
  const factory UpdatePhoto({required String url}) = UpdatePhotoStart;

  const factory UpdatePhoto.successful(AppUser user) = UpdatePhotoSuccessful;

  const factory UpdatePhoto.error(Object error, StackTrace stackTrace) = UpdatePhotoError;
}
