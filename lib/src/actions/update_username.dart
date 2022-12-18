part of actions;

@freezed
class UpdateUsername with _$UpdateUsername {
  const factory UpdateUsername({required String name}) = UpdateUsernameStart;

  const factory UpdateUsername.successful(AppUser user) = UpdateUsernameSuccessful;

  const factory UpdateUsername.error(Object error, StackTrace stackTrace) = UpdateUsernameError;
}
