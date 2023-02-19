import 'package:flutter/material.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

const socketURL = String.fromEnvironment('SERVER_URL', defaultValue: 'ws://localhost:4000/socket/websocket');
const channelName = String.fromEnvironment('CHANNEL_NAME', defaultValue: 'room:lobby');

// coverage:ignore-start
void main() {
  runApp(const MyApp());
}
// coverage:ignore-end

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Phoenix Channels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Who\'s online?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _connected = false;
  String _username = "";
  late PhoenixSocket _socket;
  late PhoenixChannel _channel;
  late PhoenixPresence _presence;

  var _responses = [];

  onButtonPress() {
    // If the user is not connected, create the socket and configure it

    if (!_connected) {
      // Connect socket and adding event handlers
      _socket = PhoenixSocket(socketURL)..connect();

      // If stream is closed
      _socket.closeStream.listen((event) {
        _socket.close();
        setState(() {
          _connected = false;
          _responses = [];
        });
      });

      // If stream is open, join channel with username as param
      _socket.openStream.listen((event) {
        setState(() {
          _channel = _socket.addChannel(topic: channelName, parameters: {"username": _username})..join(const Duration(seconds: 1));
          _connected = true;
        });

        _presence = PhoenixPresence(channel: _channel);
        // https://hexdocs.pm/phoenix/presence.html#the-presence-generator
        // listens to `presence_state` and `presence_diff`
        // events that go through `onSync` callback, forcing re-render
        _presence.onSync = () {
          var updatedResponses = _presence.list(_presence.state, (String id, Presence presence) {
            final metaObj = presence.metas.first.data;
            return {"user_id": id, "username": metaObj["username"]};
          });

          setState(() {
            _responses = updatedResponses;
          });
        };
      });
    } else {
      _socket.close();
      setState(() {
        _responses = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextFormField(
                    enabled: !_connected,
                    onChanged: (value) => setState(() {
                      _username = value;
                    }),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your username',
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _connected ? const Color.fromARGB(255, 215, 75, 75) : const Color.fromARGB(255, 95, 143, 77)),
                      onPressed: _username.isEmpty ? null : onButtonPress,
                      child: _connected ? const Text('Disconnect') : const Text('Connect'),
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _connected
                  ? const Text(
                      'Connected',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(238, 56, 231, 94)),
                    )
                  : const Text(
                      'Disconnected',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(239, 255, 48, 48)),
                    )),
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _responses.length,
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 50,
                      child: Center(child: Text(_responses[index]["username"])),
                    );
                  })),
        ],
      ),
    );
  }
}
