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
  }

  createVponInterstitialAd(BuildContext context) async {
    try {
      interstitialAd = VponInterstitialAd(
          licenseKey: "8a80854b6a90b5bc016ad81a98cf652e",
          platform: "TW",
          testAd: true,
          eventListener: VponAdListener(
              onAdLoaded: () {
                print("onAdLoaded");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("onAdLoaded")));
              },
              onAdOpened: () {
                print("onAdOpened");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("onAdOpened")));
              },
              onAdClosed: () {
                print("onAdClosed");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("onAdClosed")));
              },
              onAdClicked: () {
                print("onAdClicked");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("onAdClicked")));
              },
              onAdFailedToLoad: (dynamic error) {
                print("onAdFailedToLoad: $error}");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("onAdFailedToLoad \n ${error.toString()}")));
              },
              onAdLeftApplication: () {
                print("onAdLeftApplication");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("onAdLeftApplication")));
              }
          )
      );
      await vponSDK.loadVponInterstitialAd(interstitialAd: interstitialAd!);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("createVponInterstitialAd(Error): ${error.toString()}")));
    }
    if (!mounted) return;
  }

  Future<void> showAds(BuildContext context) async {
    try {
      await vponSDK.showVponInterstitialAd(interstitialAd: interstitialAd!);
    } catch (error) {
      print("showAds(Error): ${error.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("showAds(Error): ${error.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Vpon SDK Example'),
              ),
              body: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        createVponInterstitialAd(context);
                      },
                      child: Text("Create Vpon Ads!")
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showAds(context);
                      },
                      child: Text("Show Vpon Ads!")
                  )
                ],
              ),
            );
          },
        )
    );
  }
}