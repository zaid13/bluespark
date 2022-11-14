import 'package:bluespark/screens/SplashScreen.dart';
import 'package:bluespark/src/ble/ble_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';

class DeviceListScreen1 extends StatelessWidget {
  const DeviceListScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
    builder: (_, bleScanner, bleScannerState, __)
    =>bleScanner.btfound!=null?DeviceDetailScreen(device: bleScanner.btfound): DeviceList(
      scannerState: bleScannerState ?? const BleScannerState(
        discoveredDevices: [],
        scanIsInProgress: false,
      ),
      startScan: bleScanner.startScan,
      stopScan: bleScanner.stopScan,
    ),
  );
}

class DeviceList extends StatefulWidget {
  const DeviceList(
      {required this.scannerState,
        required this.startScan,
        required this.stopScan});

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  late TextEditingController _uuidController;

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }


  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
    !widget.scannerState.scanIsInProgress &&
        _isValidUuidInput()
        ? _startScanning() : null;



  }

  @override
  void dispose() {
    widget.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Scan for devices'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Service UUID (2, 4, 16 bytes):'),
              TextField(
                controller: _uuidController,
                enabled: !widget.scannerState.scanIsInProgress,
                decoration: InputDecoration(
                    errorText:
                    _uuidController.text.isEmpty || _isValidUuidInput()
                        ? null
                        : 'Invalid UUID format'),
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Scan'),
                    onPressed: !widget.scannerState.scanIsInProgress &&
                        _isValidUuidInput()
                        ? _startScanning
                        : null,
                  ),
                  ElevatedButton(
                    child: const Text('Stop'),
                    onPressed: widget.scannerState.scanIsInProgress
                        ? widget.stopScan
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(!widget.scannerState.scanIsInProgress
                        ? 'Enter a UUID above and tap start to begin scanning'
                        : 'Tap a device to connect to it'),
                  ),
                  if (widget.scannerState.scanIsInProgress ||
                      widget.scannerState.discoveredDevices.isNotEmpty)
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.only(start: 18.0),
                      child: Text(
                          'count: ${widget.scannerState.discoveredDevices.length}'),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: ListView(
            children: widget.scannerState.discoveredDevices
                .map(
                  (device) => ListTile(
                title: Text(device.name),
                subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                leading: const BluetoothIcon(),
                onTap: () async {
                  widget.stopScan();
                  Provider.of<BleScanner>(context, listen: false).setFoundDevices( device);
                  await Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const SpalshScreenStateManager( )));
                  // widget.stopScan();
                  // await Navigator.push<void>(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) =>
                  //             DeviceDetailScreen(device: device)));
                },
              ),
            )
                .toList(),
          ),
        ),
      ],
    ),
  );
}
