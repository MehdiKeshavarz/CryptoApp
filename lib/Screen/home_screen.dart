import 'package:flutter/material.dart';
import 'package:flutter_application_json/Screen/coin_List_screen.dart';
import 'package:flutter_application_json/data/model/crypto.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    GetData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/logo.png')),
              SpinKitCubeGrid(
                color: Colors.white,
                size: 50.0,
              )
            ],
          ),
        )),
      ),
    );
  }

  Future<void> GetData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CoinListScreen(
            cryptoList: cryptoList,
          );
        },
      ),
    );
  }
}
