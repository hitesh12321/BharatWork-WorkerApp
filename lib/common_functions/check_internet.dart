import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  StreamController<ConnectivityResult> controller = StreamController<ConnectivityResult>();
  ConnectivityStatus? lastResult;
  ConnectivityStatus? newState;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.isConnected) {
    if (state == ConnectivityStatus.isConnected) {
      lastResult = ConnectivityStatus.isConnected;
    } else {
      lastResult = ConnectivityStatus.isDisconnected;
    }
    lastResult = ConnectivityStatus.notDetermined;
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile)) {
        // Mobile network available.
        newState = ConnectivityStatus.isConnected;
      } else if (result.contains(ConnectivityResult.wifi)) {
        newState = ConnectivityStatus.isConnected;
        // Wi-fi is available.
        // Note for Android:
        // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
        // } else if (result.contains(ConnectivityResult.ethernet)) {
        //   // Ethernet connection available.
        // } else if (result.contains(ConnectivityResult.vpn)) {
        //   // Vpn connection active.
        //   // Note for iOS and macOS:
        //   // There is no separate network interface type for [vpn].
        //   // It returns [other] on any device (also simulator)
        // } else if (result.contains(ConnectivityResult.bluetooth)) {
        //   // Bluetooth connection available.
        // } else if (result.contains(ConnectivityResult.other)) {
        //   // Connected to a network which is not in the above mentioned networks.
        // } else if (result.contains(ConnectivityResult.none)) {
        //   // No available network types
      } else {
        newState = ConnectivityStatus.isDisconnected;
      }
      if (newState != lastResult) {
        state = newState!;
        lastResult = newState;
      }
    });
  }
}
