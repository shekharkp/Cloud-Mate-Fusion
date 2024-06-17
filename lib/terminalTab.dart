import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'virtual_keyboard.dart';
import 'package:xterm/xterm.dart';
import 'package:cmf/Database_helper/securedStorage.dart';


class TerminalTab extends StatefulWidget {
  TerminalTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TerminalTabState createState() => _TerminalTabState();
}

class _TerminalTabState extends State<TerminalTab> {
  var port = 22;
  var password = 'mateserver';

  Securedstorage securedstorage = Securedstorage();
  final TextEditingController _credentials = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String connectionStatus = "Disconnected";

  late final terminal = Terminal(inputHandler: keyboard);

  final keyboard = VirtualKeyboard(defaultInputHandler);

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            color: const Color(0xffe4e2e5),),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF333c3a)),
              SizedBox(height: 10),
              Text("Processing", style: TextStyle(fontSize: 12,
                  color: Color(0xFF333c3a),
                  fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      );
    },);
  }

  checkConnectionStatus() async
  {
    connectionStatus = await securedstorage.getConnectionStatus();
    setState(() {

    });
    if(connectionStatus == "Connected") {
      String username = await securedstorage.getusername();
      String host = await securedstorage.gethostIP();
      initTerminal(host, username);
    }
  }


  @override
  void initState() {
    super.initState();
    checkConnectionStatus();
  }

  Future<void> initTerminal(String host, String username) async {
    terminal.write('Connecting...\r\n');
    try {
      final client = SSHClient(
        await SSHSocket.connect(host, port),
        username: username,
        onPasswordRequest: () => password,
      );
    terminal.write('Connected\r\n');

    final session = await client.shell(
      pty: SSHPtyConfig(
        width: terminal.viewWidth,
        height: terminal.viewHeight,
      ),
    );

    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);


    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      session.resizeTerminal(width, height, pixelWidth, pixelHeight);
    };

    terminal.onOutput = (data) {
      session.write(Uint8List.fromList(data.codeUnits));
    };

    session.stdout
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    session.stderr
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    }
    catch (e)
    {
      showMessage("Something went wrong...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Terminal"),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              LoadingScreen();
              await securedstorage.setConnectionStatus("Disconnected");
              await securedstorage.sethostIP("null");
              await securedstorage.setusername("null");
              connectionStatus = "Disconnected";
              Navigator.of(context).pop();
              setState(() {
              });
            },
            icon: Icon(Icons.remove_circle),
            label: Text("Disconnect"),
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.fromLTRB(55, 15, 55, 15),
                ),
                backgroundColor: MaterialStatePropertyAll(Colors.black)),
          )
        ],
      ),
      body: Stack(
        children:[ Column(
          children: [
            Expanded(
              child: TerminalView(terminal),
            ),
            VirtualKeyboardView(keyboard),
          ],
        ),
          connectionStatus == "Connected" ? Container() : Container(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 200,
                  width: double.maxFinite,
                  decoration:const BoxDecoration(
                    color: Color(0xFFe4e2e5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FormTextFields(
                          Title: "Paste Credentials here",
                          controller: _credentials,
                          maxlength: 25,
                          focusNode: _focusNode,),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try{
                              if(!_credentials.text.contains(" ") && _credentials.text.isNotEmpty)
                                _focusNode.unfocus();
                              LoadingScreen();
                              List<String>  Credentials = _credentials.text.split("@");
                              String serverUserName = Credentials[0];
                              String hostIP = Credentials[1];
                              await initTerminal(hostIP,serverUserName);
                              await securedstorage.sethostIP(hostIP);
                              await securedstorage.setusername(serverUserName);
                              await securedstorage.setConnectionStatus("Connected");
                              _credentials.clear();
                              connectionStatus = "Connected";
                              Navigator.of(context).pop();
                              setState(() {

                              }
                              );
                            }
                            catch (e)
                            {
                              Navigator.of(context).pop();
                              showMessage("Credentials Incorrect!!!");
                            }
                          },
                          style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(55, 15, 55, 15),
                              ),
                              backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                          icon: const Icon(Icons.paste),
                          label: const Text("Connect to MateServer"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormTextFields extends StatelessWidget {
  FormTextFields(
      {super.key,
        required this.Title,
        required this.controller,
        required this.maxlength,
        required this.focusNode});
  final String Title;
  TextEditingController controller;
  int maxlength;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Title,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            cursorColor: Colors.black,
            cursorHeight: 15,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field is required";
              }
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "username@hostIp",
              contentPadding:
              EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
