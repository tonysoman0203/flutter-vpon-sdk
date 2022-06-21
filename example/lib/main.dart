import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vpon_sdk/callback/ad_listener.dart';
import 'package:vpon_sdk/vpon_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _vponSdkPlugin = VponSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSdk();
    createVponInterstitialAd();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _vponSdkPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> createVponInterstitialAd() async {
    try {
      await _vponSdkPlugin.createVponInterstitialAd(
          adKey: "8a80854b75ab2b0101761cfb968d71c7",
      );
    } on PlatformException{
      print("Failed to init");
    }
    if (!mounted) return;
  }

  Future<void> showAds() async {
    await _vponSdkPlugin.showVponInterstitialAd();
  }

  Future<void> initSdk() async {
    try {
      await _vponSdkPlugin.initSdk();
    } on PlatformException{
      print("Failed to init");
    }
    if (!mounted) return;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
                onPressed: () async => showAds(), child: Text("Show Vpon Ads!"))
          ],
        ),
      ),
    );
  }
}