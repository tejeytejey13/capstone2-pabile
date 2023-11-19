import 'dart:async';
import 'package:capstone_project_pabile/client/screen/mapwidget.dart';
import 'package:capstone_project_pabile/component/botnavbar.dart';
import 'package:flutter/material.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  double _progressValue = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    const totalTimeInSeconds = 10;
    const updateIntervalInSeconds = 1;

    final totalUpdates = (totalTimeInSeconds / updateIntervalInSeconds).round();

    _timer = Timer.periodic(const Duration(seconds: updateIntervalInSeconds),
        (timer) {
      if (_progressValue < 0.5) {
        setState(() {
          _progressValue += 1 / totalUpdates / 2;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BotNavBar()),
                    );
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              const Text(
                'Waiting for your order... ',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: Colors.lightBlue,
                          child: const Center(
                            child: MapWidget(),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        value: _progressValue,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _progressValue < 0.5 ? Colors.blue : Colors.green,
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Time Remaining: ${(10 * (1 - _progressValue)).toInt()} seconds',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
