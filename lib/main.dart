import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BluetoothDemo(),
    );
  }
}

class BluetoothDemo extends StatefulWidget {
  const BluetoothDemo({super.key});

  @override
  BluetoothDemoState createState() => BluetoothDemoState();
}

class BluetoothDemoState extends State<BluetoothDemo> {
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  Future<void> _startScanning() async {
    try {
    var subscription = FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          if (!devices.contains(result.device)) {
            setState(() {
              devices.add(result.device);
            });
          }
        }
      });
      await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
      await FlutterBluePlus.startScan(withServices:[Guid("180D")]);

      await FlutterBluePlus.stopScan();
      subscription.cancel();
    } catch (e) {
      print("Error scanning: $e");
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS Bluetooth Demo'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device.advName),
            subtitle: Text(device.remoteId.toString()),
            onTap: () {},
          );
        },
      ),
    );
  }
}
