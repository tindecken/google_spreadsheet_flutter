import 'package:flutter/material.dart';
import 'add_section.dart';
import 'transactions_section.dart';
import 'services/transaction_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _perDay = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadPerDay();
  }

  Future<void> _loadPerDay() async {
    final response = await TransactionService.getPerDay();
    if (response.success && response.data != null) {
      setState(() {
        _perDay = response.data!.perDay;
      });
    } else {
      setState(() {
        _perDay = 'Error';
      });
    }
  }

  void _updatePerDay(String newPerDay) {
    setState(() {
      _perDay = newPerDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Per day: ${_perDay}"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _currentIndex == 0
          ? AddSection(onPerDayUpdate: _updatePerDay)
          : const TransactionsSection(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
        ],
      ),
    );
  }
}
