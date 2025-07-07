import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final isConnected = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _init() async {
    await _checkConnection();
    _subscription = _connectivity.onConnectivityChanged.listen((_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final newStatus = results.any((result) => result != ConnectivityResult.none);
      
      if (isConnected.value != newStatus) {
        isConnected.value = newStatus;
        if (!newStatus) {
          Get.snackbar("No Internet Connection", 'Please check your network settings');
        }
      }
    } catch (e) {
      Get.snackbar("Connection Error", 'Failed to check network status');
    }
  }
}