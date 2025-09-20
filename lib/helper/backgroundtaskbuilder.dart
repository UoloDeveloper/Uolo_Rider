import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_delivery/api/api_client.dart';
import 'package:sixam_mart_delivery/features/profile/domain/repositories/profile_repository.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:workmanager/workmanager.dart';



import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';



// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     print("🔧 Workmanager: Task started: $task");

//     try {
//       final sharedPrefs = await SharedPreferences.getInstance();
//       final apiClient = ApiClient(
//         appBaseUrl: AppConstants.baseUrl,
//         sharedPreferences: sharedPrefs,
//       );

//       final repo = ProfileRepository(
//         apiClient: apiClient,
//         sharedPreferences: sharedPrefs,
//       );

//       await repo.recordBackgroundLocation();

//       print("✅ Background location recorded successfully.");
//       return Future.value(true);
//     } catch (e, stackTrace) {
//       print("❌ Error during background task: $e\n$stackTrace");
//       return Future.value(false);
//     }
//   });
// }

// Future<void> setupBackgroundTask() async {
//   print("🟡 Initializing background task...");

//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true, // Use true for development logs
//   );

//   await Workmanager().registerPeriodicTask(
//     "locationBackgroundTaskId",
//     "locationBackgroundTask",
//     frequency: const Duration(minutes: 15),
//     initialDelay: const Duration(seconds: 10),
//     constraints: Constraints(networkType: NetworkType.connected),
//     backoffPolicy: BackoffPolicy.linear,
//     backoffPolicyDelay: const Duration(minutes: 1),
//   );

//   print("✅ Background task registered.");
// }
