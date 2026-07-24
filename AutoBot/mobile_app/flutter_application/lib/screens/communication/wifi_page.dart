import 'package:flutter/material.dart';

import '../../services/app_state.dart';
import '../../services/bluetooth/bluetooth_hub.dart';
import '../../services/obd/wifi_elm_transport.dart';
import '../../services/obd/elm_obd_client.dart';

class WifiObdPage extends StatefulWidget {
  final BluetoothHub hub;
  final AppState appState;

  const WifiObdPage({
    super.key,
    required this.hub,
    required this.appState,
  });

  @override
  State<WifiObdPage> createState() => _WifiObdPageState();
}

class _WifiObdPageState extends State<WifiObdPage> {
  final WifiElmTransport transport = WifiElmTransport();
  late final ElmObdClient obd = ElmObdClient(transport);

  final hostCtrl = TextEditingController(text: "192.168.137.1");
  final portCtrl = TextEditingController(text: "35000");

  bool loading = false;
  bool liveRunning = false;
  String statusText = "Disconnected";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    obd.stopLiveStream();
    hostCtrl.dispose();
    portCtrl.dispose();
    super.dispose();
  }

  Future<void> doConnect() async {
    final host = hostCtrl.text.trim();
    final port = int.tryParse(portCtrl.text.trim()) ?? 35000;

    setState(() {
      loading = true;
      statusText = "Connecting to $host:$port ...";
    });

    widget.appState.setStatus(
      type: ConnectionType.wifi,
      connected: false,
      details: "$host:$port",
    );

    try {
      await transport.connect(host: host, port: port);
      await obd.initElm();

      setState(() {
        statusText = "Connected: $host:$port";
      });

      widget.appState.setStatus(
        type: ConnectionType.wifi,
        connected: true,
        details: "$host:$port",
      );

      widget.hub.addLine("Connected to $host:$port");
      _toast("Connected to $host:$port");
    } catch (e) {
      setState(() {
        statusText = "Connect failed: $e";
      });

      widget.appState.setStatus(
        type: ConnectionType.wifi,
        connected: false,
        details: "$host:$port",
      );

      _toast("Connect failed: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> doDisconnect() async {
    setState(() => loading = true);

    try {
      obd.stopLiveStream();
      await transport.disconnect();
    } catch (_) {}

    setState(() {
      loading = false;
      liveRunning = false;
      statusText = "Disconnected";
    });

    widget.appState.setStatus(
      type: ConnectionType.wifi,
      connected: false,
      details: "",
    );

    widget.hub.addLine("Disconnected");
    _toast("Disconnected");
  }

  Future<void> readDtcs() async {
    try {
      final res = await obd.readDtcsRaw();
      widget.hub.addLine("DTCs:");
      widget.hub.addLine(res);
    } catch (e) {
      widget.hub.addLine("Read DTCs failed: $e");
      _toast("Read DTCs failed");
    }
    if (mounted) setState(() {});
  }

  Future<void> readVin() async {
    try {
      final res = await obd.readVinRaw();
      widget.hub.addLine("VIN:");
      widget.hub.addLine(res);
    } catch (e) {
      widget.hub.addLine("Read VIN failed: $e");
      _toast("Read VIN failed");
    }
    if (mounted) setState(() {});
  }

  Future<void> toggleLiveData() async {
    if (!transport.isConnected) return;

    if (!liveRunning) {
      setState(() => liveRunning = true);

      widget.hub.addLine("Starting live data stream...");

      try {
        obd.startLiveStream(
          period: const Duration(seconds: 1),
          onSnapshot: (snapshot) {
            widget.hub.addLine("LIVE DATA:");
            widget.hub.addLine(snapshot.toString());

            if (mounted) setState(() {});
          },
          onError: (e) {
            widget.hub.addLine("Live data error: $e");
            if (mounted) {
              setState(() => liveRunning = false);
            }
          },
        );
      } catch (e) {
        widget.hub.addLine("Failed to start live data: $e");
        setState(() => liveRunning = false);
      }
    } else {
      obd.stopLiveStream();
      widget.hub.addLine("Live data stream stopped.");
      setState(() => liveRunning = false);
    }
  }

  void clearTerminal() {
    widget.hub.clear();
    setState(() {});
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connected = transport.isConnected;

    return Scaffold(
      appBar: AppBar(
        title: const Text("WiFi OBD"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: "Clear terminal",
            icon: const Icon(Icons.delete_outline),
            onPressed: clearTerminal,
          ),
        ],
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
                    connected ? Icons.wifi : Icons.wifi_off,
                    color: connected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(statusText)),
                  if (connected)
                    TextButton(
                      onPressed: loading ? null : doDisconnect,
                      child: const Text("Disconnect"),
                    ),
                ],
              ),
            ),

            // IP + Port
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hostCtrl,
                      decoration: const InputDecoration(
                        labelText: "IP",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: portCtrl,
                      decoration: const InputDecoration(
                        labelText: "Port",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),

            // Connect button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : doConnect,
                  child: const Text("CONNECT"),
                ),
              ),
            ),

            if (loading) const LinearProgressIndicator(),

            const SizedBox(height: 10),

            // New general buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: connected ? toggleLiveData : null,
                      child: Text(
                        liveRunning
                            ? "Stop live data"
                            : "Read all live data",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: connected ? readDtcs : null,
                          child: const Text("Read DTCs"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: connected ? readVin : null,
                          child: const Text("Read VIN Number"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Terminal
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: Colors.black,
                child: ListView(
                  reverse: true,
                  children: widget.hub.lastLines
                      .reversed
                      .take(80)
                      .map(
                        (l) => Text(
                      l,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}