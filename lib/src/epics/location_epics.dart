import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/data/location_api.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/transformers.dart';

class LocationEpics {
  const LocationEpics(this._api);

  final LocationApi _api;

  Epic<AppState> get epic {
    return combineEpics(<Epic<AppState>>[
      TypedEpic<AppState, GetLocation>(_getLocationStart),
    ]);
  }

  Stream<dynamic> _getLocationStart(Stream<GetLocation> actions, EpicStore<AppState> store) {
    return actions.flatMap((GetLocation action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.getLocation(store.state.auth.user!.uid))
          .map((UserLocation? location) => GetLocation.successful(location))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => GetLocation.error(error, stackTrace));
    });
  }
}
