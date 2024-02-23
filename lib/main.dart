import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/crypt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _qrData = Crypt().set(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), "encrypt");
  int _start = 30;
  bool _visible = true;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start <= 1) {
            _visible = false;
            _qrData = Crypt().set(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), "encrypt");
            _start = 30;
            print(_qrData);

            print(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
          } else {
            _visible = true;
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const Text(
              'Giriş-Çıkış işlemleri için QR kodunu okutunuz.',
              style: TextStyle(fontSize: 24),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _visible
                    ? QrImage(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: width * .25,
                      )
                    : SizedBox(
                        width: width * .25,
                        height: width * .25,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        ),
                      ),
              ),
            ),
            const Spacer(),
            Text(
              ' Kodun yenilenmesine $_start saniye kaldı.',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
