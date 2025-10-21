import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/add_transaction.dart';
import 'services/transaction_service.dart';

class AddSection extends StatefulWidget {
  final Function(String) onPerDayUpdate;

  const AddSection({super.key, required this.onPerDayUpdate});

  @override
  State<AddSection> createState() => _AddSectionState();
}

class _AddSectionState extends State<AddSection> {
  final _formKey = GlobalKey<FormState>();
  final _dayController = TextEditingController();
  final _noteController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isPaybyCash = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default day to current day
    _dayController.text = DateTime.now().day.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _dayController.dispose();
    _noteController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final transaction = AddTransaction(
        day: _dayController.text,
        note: _noteController.text,
        price: double.parse(_priceController.text),
        isPaybyCash: _isPaybyCash,
      );

      final response = await TransactionService.addTransaction(transaction);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (response.success && response.data != null) {
        // Update the perDay in AppBar
        widget.onPerDayUpdate(response.data!.perDayAfter);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Per Day Before: ${response.data!.perDayBefore}\n'
              'Per Day After: ${response.data!.perDayAfter}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 6),
          ),
        );
        // Clear form after successful submission
        _dayController.text = DateTime.now().day.toString().padLeft(2, '0');
        _noteController.clear();
        _priceController.clear();
        setState(() {
          _isPaybyCash = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _dayController,
              decoration: const InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Day is required';
                }
                final day = int.tryParse(value);
                if (day == null || day < 1 || day > 31) {
                  return 'Please enter a valid day (1-31)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 36),
              maxLength: 1000,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Note is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 36),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Cash'),
              value: _isPaybyCash,
              onChanged: (value) {
                setState(() {
                  _isPaybyCash = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
