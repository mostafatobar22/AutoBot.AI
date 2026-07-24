import 'package:flutter/material.dart';
import '../../models/bt_device.dart';
import '../../services/bluetooth/bluetooth_transport.dart';
import '../../services/bluetooth/classic_transport.dart';
import '../../services/bluetooth/ble_transport.dart';
import '../../services/bluetooth/bluetooth_hub.dart';

enum BtMode { classic, ble }

class BluetoothPage extends StatefulWidget {
  final BluetoothHub hub;

  const BluetoothPage({super.key, required this.hub});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BtMode mode = BtMode.classic;

  BluetoothTransport transport = ClassicTransport();
  List<BtDevice> devices = [];

  bool loading = false;
  String status = "Disconnected";

  @override
  void initState() {
    super.initState();
    _attachRx();
  }

  void _attachRx() {
    transport.rxStream.listen((line) {
      widget.hub.addLine(line);
    });
  }

  Future<void> _switchMode(BtMode newMode) async {
    setState(() => loading = true);
    await transport.disconnect();

    setState(() {
      mode = newMode;
      transport = (mode == BtMode.classic) ? ClassicTransport() : BleTransport();
      devices = [];
      status = "Disconnected";
    });

    _attachRx();
    setState(() => loading = false);
  }

  Future<void> scan() async {
    setState(() => loading = true);
    try {
      final list = await transport.listDevices();
      setState(() => devices = list);
    } catch (e) {
      _toast("Scan error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> connect(BtDevice d) async {
    setState(() => loading = true);
    try {
      await transport.connect(d);
      setState(() => status = "Connected: ${d.name}");
      _toast("Connected to ${d.name}");
    } catch (e) {
      setState(() => status = "Disconnected");
      _toast("Connect failed: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> disconnect() async {
    setState(() => loading = true);
    await transport.disconnect();
    setState(() {
      status = "Disconnected";
      loading = false;
    });
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Bluetooth"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Icon(
                  transport.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: transport.isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(status)),
                if (transport.isConnected)
                  TextButton(
                    onPressed: disconnect,
                    child: const Text("Disconnect"),
                  ),
              ],
            ),
          ),

          // Mode selector + scan
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<BtMode>(
                    value: mode,
                    isExpanded: true,
                    onChanged: (v) => _switchMode(v!),
                    items: const [
                      DropdownMenuItem(
                        value: BtMode.classic,
                        child: Text("Classic (SPP / ELM327 / Terminal)"),
                      ),
                      DropdownMenuItem(
                        value: BtMode.ble,
                        child: Text("BLE (UART service)"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: loading ? null : scan,
                  child: const Text("Scan"),
                ),
              ],
            ),
          ),

          if (loading) const LinearProgressIndicator(),

          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (_, i) {
                final d = devices[i];
                return ListTile(
                  leading:
                      Icon(d.isBle ? Icons.wifi_tethering : Icons.bluetooth),
                  title: Text(d.name),
                  subtitle: Text(d.id),
                  trailing: ElevatedButton(
                    onPressed: loading ? null : () => connect(d),
                    child: const Text("Connect"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}