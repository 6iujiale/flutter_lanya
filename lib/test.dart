/*
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void main() => runApp(MaterialApp(
  home: Test(),
));

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 400,
                      child: ListView(
                        children: const <Widget>[
                          ListTile(
                            title: Text("1111"),
                            subtitle: Text("1111"),
                          ),
                          ListTile(
                            title: Text("1111"),
                            subtitle: Text("1111"),
                          ),
                          ListTile(
                            title: Text("1111"),
                            subtitle: Text("1111"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text("打开底部菜单"),
              ),
            ],
          ),
        ),
      );
  }
}
*/
List<int> stringToHexList(String input) {
  List<int> hexList = [];
  for (int i = 0; i < input.length; i++) {
    int hexValue = input.codeUnitAt(i);
    hexList.add(hexValue);
  }
  return hexList;
}

void main() {
  String atCommand = "AT\r\n";
  List<int> hexList = atCommand.codeUnits;
  hexList.map((e) => e.toRadixString(16)).toList();
  print(hexList); // [65, 84, 13, 10]
}
