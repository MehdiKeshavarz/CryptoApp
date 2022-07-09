class Crypto {
  String id;
  String name;
  String symbol;
  String rank;
  double marketCapUsd;
  double priceUsd;
  double changePercent24hr;

  Crypto(this.id, this.name, this.symbol, this.rank, this.marketCapUsd,
      this.priceUsd, this.changePercent24hr);

  factory Crypto.fromMapJson(Map<String, dynamic> JsonObject) {
    return Crypto(
      JsonObject['id'],
      JsonObject['name'],
      JsonObject['symbol'],
      JsonObject['rank'],
      double.parse(JsonObject['marketCapUsd']),
      double.parse(JsonObject['priceUsd']),
      double.parse(JsonObject['changePercent24Hr']),
    );
  }
}
