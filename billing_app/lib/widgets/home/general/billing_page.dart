// lib/billing_page.dart
import 'package:flutter/material.dart';

class BillingPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int subtotal;

  const BillingPage({
    super.key,
    required this.items,
    required this.subtotal,
  });

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  // Hard-coded dummy coupons (same style as your catalog)
  final List<Map<String, String>> _coupons = [
    {'code': 'DIS10', 'type': 'percent', 'value': '10'},
    {'code': 'FLAT50', 'type': 'flat', 'value': '50'},
  ];

  final TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;
  int _discountAmount = 0;
  double _discountPercent = 0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  int get discountValue {
    if (_discountPercent > 0) {
      return ((widget.subtotal * _discountPercent) / 100).round();
    }
    return _discountAmount;
  }

  int get total {
    final t = widget.subtotal - discountValue;
    return t < 0 ? 0 : t;
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a coupon code')));
      return;
    }

    final coupon = _coupons.firstWhere((c) => c['code'] == code, orElse: () => {});
    if (coupon.isEmpty) {
      setState(() {
        _appliedCoupon = null;
        _discountAmount = 0;
        _discountPercent = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid coupon')));
      return;
    }

    setState(() {
      _appliedCoupon = coupon['code'];
      final type = coupon['type']!;
      final value = int.parse(coupon['value']!);
      if (type == 'percent') {
        _discountPercent = value.toDouble();
        _discountAmount = 0;
      } else {
        _discountAmount = value;
        _discountPercent = 0;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_appliedCoupon!} applied')));
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _discountAmount = 0;
      _discountPercent = 0;
      _couponController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coupon removed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F1FF),
      body: Column(
        children: [
          // Top header (matching order page style)
          Container(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFD69ADE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Billing Page",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Table header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 4, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Base', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Price', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // Items list
          Expanded(
            child: widget.items.isEmpty
                ? const Center(child: Text('No items'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemBuilder: (_, index) {
                      final it = widget.items[index];
                      final lineTotal = (it['price'] as int) * (it['qty'] as int);
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text('${it['item']}', style: const TextStyle(fontSize: 16))),
                            Expanded(flex: 2, child: Text('₹${it['price']}', style: const TextStyle(fontSize: 15))),
                            Expanded(flex: 2, child: Text('${it['qty']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15))),
                            Expanded(flex: 2, child: Text('₹$lineTotal', textAlign: TextAlign.right, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: widget.items.length,
                  ),
          ),

          // Coupon box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: const InputDecoration(
                          hintText: 'Enter discount coupon if available',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyCoupon,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD69ADE)),
                      child: const Text('Apply', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 8),
                    if (_appliedCoupon != null)
                      IconButton(onPressed: _removeCoupon, icon: const Icon(Icons.close)),
                  ],
                ),
                if (_appliedCoupon != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Applied: $_appliedCoupon', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('- ₹$discountValue', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Total area
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF9F1FF),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Subtotal:', style: TextStyle(fontSize: 16))),
                      Text('₹${widget.subtotal}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Expanded(child: Text('Discount:', style: TextStyle(fontSize: 16))),
                      Text('- ₹$discountValue', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(child: Text('Total: ₹$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          // finish / save placeholder
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order finished (placeholder)')));
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD69ADE)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                          child: Text('Finish', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
