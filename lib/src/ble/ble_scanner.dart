import 'dart:async';

import 'package:bluespark/src/ble/reactive_state.dart';
import 'package:bluespark/util/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';

import '../../models/BoxModel.dart';
import '../../providers/box_storage.dart';


class BleScanner implements ReactiveState<BleScannerState> {



  BleScanner({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <DiscoveredDevice>[];
   var btfound ;

   setFoundDevices(newbtfound){
     btfound = newbtfound;
   }
  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;



  void startScan(List<Uuid> serviceIds) {
    _logMessage('Start ble discovery');
    _devices.clear();
    _subscription?.cancel();
    _subscription =
        _ble.scanForDevices(withServices: serviceIds).listen((device) async {
      final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = device;
      } else {
        Box_Model? box = await BoxStorage.getBox(device.id);
        KnownDeviceList;

        if(box!=null){
          if(box.isConnected){
            btfound = device;
          }
        }

        // for (String deviceName in KnownDeviceList){
        //   if(deviceName == device.id){
        //     btfound = device;
        //   }
        // }

        _devices.add(device);
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}
