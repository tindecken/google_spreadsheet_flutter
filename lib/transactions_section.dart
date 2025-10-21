import 'package:flutter/material.dart';
import 'services/transaction_service.dart';
import 'models/add_transaction.dart';

class TransactionsSection extends StatefulWidget {
  final Function(String) onPerDayUpdate;

  const TransactionsSection({super.key, required this.onPerDayUpdate});

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  bool _isUndoing = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await TransactionService.getLast5Transactions();

    setState(() {
      _isLoading = false;
      if (response.success && response.data != null) {
        _transactions = response.data!;
      } else {
        _errorMessage = response.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTransactions,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_transactions.isEmpty) {
      return const Center(child: Text('No transactions found'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Note',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Cash',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(transaction.date)),
                        Expanded(flex: 4, child: Text(transaction.note)),
                        Expanded(flex: 2, child: Text(transaction.price)),
                        Expanded(
                          flex: 2,
                          child: Checkbox(
                            value: transaction.isCashed,
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isUndoing ? null : _handleUndo,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: _isUndoing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Undo last transaction'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleUndo() async {
    setState(() {
      _isUndoing = true;
    });

    final response = await TransactionService.undoTransaction();

    setState(() {
      _isUndoing = false;
    });

    if (!mounted) return;

    if (response.success) {
      // Reload transactions
      await _loadTransactions();

      // Update perDay in AppBar
      final perDayResponse = await TransactionService.getPerDay();
      if (perDayResponse.success && perDayResponse.data != null) {
        widget.onPerDayUpdate(perDayResponse.data!.perDay);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
