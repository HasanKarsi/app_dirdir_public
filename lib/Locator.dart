import 'package:app_dirdir/Repository/UserRepository.dart';
import 'package:app_dirdir/services/fakeAuthServices.dart';
import 'package:get_it/get_it.dart';

// Firebase service imports removed for public repository
// To enable Firebase services, add these imports:
// import 'package:app_dirdir/services/FireBaseAuthServices.dart';
// import 'package:app_dirdir/services/FireBaseStorageService.dart';
// import 'package:app_dirdir/services/FireStoreDbServices.dart';
// import 'package:app_dirdir/services/FirebaseCMServices.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Firebase services removed for public repository
  // To enable Firebase services, uncomment these lines:
  // locator.registerLazySingleton(() => FireBaseAuthServices());
  // locator.registerLazySingleton(() => FireStoreDbServices());
  // locator.registerLazySingleton(() => Firebasestorageservice());
  // locator.registerLazySingleton(() => FirebaseCMServices.instance);

  // Core services that don't depend on Firebase
  locator.registerLazySingleton(() => Fakeauthservices());
  locator.registerLazySingleton(() => USerRepository());
}
