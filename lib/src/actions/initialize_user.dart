part of actions;

import 'package:group_chat_app/src/models/index.dart';

@freezed
class InitializeUser with _$InitializeUser {

  factory InitializeUser() = _InitializeUser.successful(AppUser? user) = InitializeUser;

  factory InitializeUser.fromJson(Map<String, dynamic> json) => _$InitializeUserFromJson(json);
  Map<String, dynamic> toJson() => _$InitializeUserToJson(this);
}