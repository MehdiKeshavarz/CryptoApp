import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_json/data/constant/constants.dart';
import 'package:flutter_application_json/data/model/crypto.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({Key? key, this.cryptoList}) : super(key: key);
  List<Crypto>? cryptoList;
  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  bool isSreachLoadingVisible = false;
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          title: Text(
            'کریپتو بازار',
            style: TextStyle(fontFamily: 'mh', fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: blackColor,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _filterList(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'ارز مورد نظر خود را سرچ کنید',
                      hintStyle:
                          TextStyle(fontFamily: 'mh', color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: greenColor),
                ),
              ),
            ),
            Visibility(
              visible: isSreachLoadingVisible,
              child: Text(
                '...در حال آپدیت لیست',
                style: TextStyle(
                    fontFamily: 'mh', fontSize: 15, color: greenColor),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: greenColor,
                color: blackColor,
                strokeWidth: 5,
                onRefresh: () async {
                  List<Crypto> freshData = await _GetData();
                  setState(() {
                    cryptoList = freshData;
                  });
                },
                child: SafeArea(
                  child: ListView.builder(
                    itemCount: cryptoList!.length,
                    itemBuilder: (context, index) {
                      return _getListTileItem(cryptoList![index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(fontSize: 20, color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(fontSize: 18, color: greyColor),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank,
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 20),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 18,
                      color: _colorChangeText(crypto.changePercent24hr)),
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            _getIconChangePercent(crypto.changePercent24hr),
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double ChangePercent) {
    return ChangePercent <= 0
        ? Icon(Icons.trending_down, size: 30, color: redColor)
        : Icon(Icons.trending_up, size: 30, color: greenColor);
  }

  Color _colorChangeText(double ChangePercent) {
    return ChangePercent <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _GetData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  Future<void> _filterList(String enterSreachKeyword) async {
    List<Crypto> cryptoResult = [];

    if (enterSreachKeyword.isEmpty) {
      setState(() {
        isSreachLoadingVisible = true;
      });
      var result = await _GetData();

      setState(() {
        cryptoList = result;
        isSreachLoadingVisible = false;
      });
      return;
    }

    cryptoResult = cryptoList!.where((element) {
      return element.name
          .toLowerCase()
          .contains(enterSreachKeyword.toLowerCase());
    }).toList();

    setState(() {
      cryptoList = cryptoResult;
    });
  }
}
