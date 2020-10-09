import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'services/ticker_model.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  Map<String, dynamic> cryptoRates;

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void resetCryptoRates() {
    cryptoRates = Map.fromIterable(
      cryptoList,
      key: (item) => item,
      value: (item) => null,
    );
  }

  void updateUI() async {
    resetCryptoRates();
    setState(() {});

    for (final String key in cryptoRates.keys) {
      cryptoRates[key] = await TickerModel().getBaseQuoteRate(
        base: key,
        quote: selectedCurrency,
      );
    }
    setState(() {});
  }

  CupertinoPicker getCurrencyCupertinoPicker() => CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 33.0,
        children:
            currenciesList.map((String e) => Text(e)).toList(growable: false),
        onSelectedItemChanged: (int selectedIndex) {
          selectedCurrency = currenciesList[selectedIndex];
          updateUI();
        },
      );

  DropdownButton<String> getCurrencyDropdownButton() => DropdownButton<String>(
        value: selectedCurrency,
        items: currenciesList
            .map((String e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(growable: false),
        onChanged: (String value) {
          setState(() {
            selectedCurrency = value;
            updateUI();
          });
        },
      );

  Padding createCoinCard({String quote, String base, double rate}) => Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $quote = ${rate == null ? '?' : rate.round()} $base',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List<Widget>.from(cryptoList
                .map((String e) => createCoinCard(
                      quote: e,
                      base: selectedCurrency,
                      rate: cryptoRates[e],
                    ))
                .toList()) +
            [
              Expanded(child: SizedBox(height: 400,),),
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS
                    ? getCurrencyCupertinoPicker()
                    : getCurrencyDropdownButton(),
              )
            ],
      ),
    );
  }
}
