import 'package:flutter/material.dart';
import 'package:vpon_sdk/Datamodel/VponAdListener.dart';
import 'package:vpon_sdk/Datamodel/VponInterstitialAd.dart';
import 'dart:async';

import 'package:vpon_sdk/vponsdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  VponInterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    vponSDK.init();
    interstitialAd = VponInterstitialAd(
        licenseKey: "8a80854b6a90b5bc016ad81a98cf652e",
        platform: "TW",
        // testAd: true,
        eventListener: VponAdListener(
            onAdLoaded: () {
              print("Ad Loaded");
            },
            onAdOpened: () {
              print("Ad Opened");
            },
            onAdClosed: () {
              print("Ad Colsed");
            },
            onAdClicked: () {
              print("Ad Clicked");
            },
            onAdFailedToLoad: (dynamic error) {
              print("Ad Error : $error");
            },
            onAdLeftApplication: () {
              print("Ad Left App");
            }
        )
    );
  }

  Future<void> createVponInterstitialAd() async {
    try {
      await vponSDK.loadVponInterstitialAd(interstitialAd: interstitialAd!);
    } catch (error) {
      print(error);
    }
    if (!mounted) return;
  }

  Future<void> showAds() async {
    print("show");
    try {
      await vponSDK.showVponInterstitialAd(interstitialAd: interstitialAd!);
    } catch (error) {
      print(error);
      print("Failed to showAds");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vpon SDK Example'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async => createVponInterstitialAd(),
                child: Text("Create Vpon Ads!")
            ),
            ElevatedButton(
                onPressed: () async => showAds(),
                child: Text("Show Vpon Ads!")
            )
          ],
        ),
      ),
    );
  }
}