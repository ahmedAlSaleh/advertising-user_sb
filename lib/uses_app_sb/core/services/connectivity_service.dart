import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool isConnected = false.obs; // Observable for connectivity status
  bool _firstCheck = true; // Flag to track the first connectivity check
  DateTime? lastUpdate; // Variable to store the last update time

  @override
  void onInit() async {
    super.onInit();
    await initConnectivity();
  }

  /// Initializes connectivity monitoring
  initConnectivity() async {
    var initialStatus = await Connectivity().checkConnectivity();
    isConnected.value = initialStatus.isNotEmpty &&
        initialStatus.any((result) => result != ConnectivityResult.none);
    ConnectivityResult.none;
    if (isConnected.value == false) {
      // If not connected at initialization, show a snackbar

      _firstCheck = false; // Update first check status
    }

    // Listening for connectivity changes
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      bool previousState = isConnected.value;
      isConnected.value = results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);

      if (!_firstCheck && previousState != isConnected.value) {
        print(isConnected.value);
        if (isConnected.value) {
          // When connectivity returns

          updateLastUpdateTime(); // Update the last update time
        } else {
          // When connectivity is lost
        }
      }
      _firstCheck = false; // Update the first check flag after the first run
    });
  }

  /// Updates the last update time
  void updateLastUpdateTime() {
    lastUpdate = DateTime.now();
    print("Last update time: $lastUpdate");
  }
}
