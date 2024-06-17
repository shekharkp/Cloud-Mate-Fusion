import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowOs extends StatefulWidget {
  const ShowOs(
      {super.key,
        required this.imageProvider,
        required this.title,
        required this.content,
        required this.info,
        required this.credentials});
  final ImageProvider<Object> imageProvider;
  final String title;
  final String content;
  final String info;
  final String credentials;

  @override
  State<ShowOs> createState() => _ShowOsState();
}

class _ShowOsState extends State<ShowOs> {


  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.only(top: 50, bottom: 10, right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style:const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333c3a)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(widget.content, style:const TextStyle(color: Colors.grey)),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 40,
                  indent: 50,
                  endIndent: 50,
                ),
                Container(
                  height: 150,
                  width: 150,
                  alignment: Alignment.center,
                  margin:const EdgeInsets.all(25),
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: widget.imageProvider,
                      fit: BoxFit.cover,
                      opacity: 1,
                    ),
                  ),
                ),
                SelectableText(widget.info,
                    style:const TextStyle(
                      color: Colors.black87,

                    ),
                    textAlign: TextAlign.start),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: FloatingActionButton.extended(onPressed: ()async {
          await Clipboard.setData(ClipboardData(text: "${widget.credentials}"));
          showMessage("Credentials Copied");
        },
        label:const Text("Copy Credentials"),
          shape: LinearBorder(),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
