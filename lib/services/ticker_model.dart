import 'package:bitcoin_ticker/services/networking.dart';

// const String apiKey = 'BFCDBE24-AD4A-40C9-B04B-94C6CF55D9F0';
const String apiKey = '76518631-BC3B-4678-8AD6-005DE2BB9443';
const String baseURL = 'https://rest.coinapi.io/v1/exchangerate';

class TickerModel {
  final Map<String, String> headers = {'X-CoinAPI-Key': apiKey};

  Future getBaseQuoteRate({String base, String quote}) async {
    String url = '$baseURL/$base/$quote';
    var data = await Networking(url: url, headers: headers).getData();

    if (data != null) {
      return data['rate'].toDouble();
    }
  }
}