part of actions;

@freezed
class UpdatePassword with _$UpdatePassword {
  const factory UpdatePassword({required String password}) = UpdatePasswordStart;

  const factory UpdatePassword.successful() = UpdatePasswordSuccessful;

  const factory UpdatePassword.error(Object error, StackTrace stackTrace) = UpdatePasswordError;
}
