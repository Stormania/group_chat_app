library actions;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:group_chat_app/src/models/index.dart';

part 'create_user.dart';
part 'index.freezed.dart';
part 'login.dart';
part 'logout.dart';
part 'update_password.dart';
part 'update_photo.dart';
part 'update_username.dart';

typedef ActionResponse = void Function(dynamic action);
