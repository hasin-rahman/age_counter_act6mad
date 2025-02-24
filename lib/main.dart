import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
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
