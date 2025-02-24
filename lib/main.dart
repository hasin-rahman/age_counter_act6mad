import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void setValue(double newValue) {
    value = newValue.toInt();
    notifyListeners();
  }

  void increment() {
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Counter App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Counter'), centerTitle: true),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          String message;
          Color backgroundColor;

          if (counter.value <= 12) {
            message = "You're a child!";
            backgroundColor = Colors.lightBlue;
          } else if (counter.value <= 19) {
            message = "Teenager time!";
            backgroundColor = Colors.lightGreen;
          } else if (counter.value <= 30) {
            message = "You're a young adult!";
            backgroundColor = Colors.yellow;
          } else if (counter.value <= 50) {
            message = "You're an adult now!";
            backgroundColor = Colors.orange;
          } else {
            message = "Golden years!";
            backgroundColor = Colors.grey;
          }

          Color progressBarColor;
          if (counter.value <= 33) {
            progressBarColor = Colors.green;
          } else if (counter.value <= 67) {
            progressBarColor = Colors.yellow;
          } else {
            progressBarColor = Colors.red;
          }

          return Container(
            color: backgroundColor,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Age:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${counter.value}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Slider(
                      value: counter.value.toDouble(),
                      min: 0,
                      max: 99,
                      divisions: 99,
                      label: counter.value.toString(),
                      onChanged:
                          (value) => context.read<Counter>().setValue(value),
                    ),
                    Container(
                      height: 10,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: counter.value / 99,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: progressBarColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () => context.read<Counter>().decrement(),
                          tooltip: 'Decrement',
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 20),
                        FloatingActionButton(
                          onPressed: () => context.read<Counter>().increment(),
                          tooltip: 'Increment',
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
