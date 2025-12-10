// lib/order_quantity_page.dart
import 'package:flutter/material.dart';
import 'billing_page.dart'; // add this import

class OrderQuantityPage extends StatefulWidget {
  final List<Map<String, String>> items;

  const OrderQuantityPage({super.key, required this.items});

  @override
  State<OrderQuantityPage> createState() => _OrderQuantityPageState();
}

class _OrderQuantityPageState extends State<OrderQuantityPage> {
  late List<Map<String, dynamic>> orderItems;

  // used to detect left-edge drag for back gesture
  double _dragStartX = 0;

  @override
  void initState() {
    super.initState();

    orderItems = widget.items.map((item) {
      return {
        'item': item['item'],
        'price': int.tryParse(item['price'] ?? '0') ?? 0,
        'qty': 1,
      };
    }).toList();
  }

  int get total {
    int sum = 0;
    for (var i in orderItems) {
      sum += (i['price'] as int) * (i['qty'] as int);
    }
    return sum;
  }

  void updateQty(int index, int change) {
    setState(() {
      orderItems[index]['qty'] = (orderItems[index]['qty'] as int) + change;
      if (orderItems[index]['qty'] < 1) orderItems[index]['qty'] = 1;
    });
  }

  void _removeAt(int index) {
    final removed = orderItems.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${removed['item']} removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the whole page with a GestureDetector to catch left-edge drags
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (details) {
        _dragStartX = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        // if the drag started near the left edge and user drags right far enough, pop
        const edgeThreshold = 30.0; // how close to the edge the gesture must start
        const dragToPopThreshold = 80.0; // how far to drag to trigger pop
        final dragDelta = details.globalPosition.dx - _dragStartX;
        if (_dragStartX <= edgeThreshold && dragDelta > dragToPopThreshold) {
          // pop once and reset start to avoid multiple pops
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          _dragStartX = double.infinity;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F1FF),
        // no AppBar here so swipe-back can feel more native; keep a top header area
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30,  left: 15, right: 15, bottom: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFD69ADE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  // explicit back button still available
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Order Summary",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Expanded(
              child: orderItems.isEmpty
                  ? const Center(child: Text('No items in order'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: orderItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final it = orderItems[index];

                        // Wrap each item in a Dismissible to allow swipe-to-delete
                        return Dismissible(
                          key: ValueKey('${it['item']}_$index'),
                          direction: DismissDirection.endToStart, // swipe left to delete
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) => _removeAt(index),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 0),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${it['item']}",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("₹${it['price']} each", style: const TextStyle(fontSize: 16)),
                                    Row(
                                      children: [
                                        // decrement
                                        GestureDetector(
                                          onTap: () => updateQty(index, -1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.black12),
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(Icons.remove, size: 18),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // qty
                                        Text("${it['qty']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 12),
                                        // increment
                                        GestureDetector(
                                          onTap: () => updateQty(index, 1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.black12),
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(Icons.add, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text("Subtotal: ₹${it['price'] * it['qty']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),

        // bottom total & confirm — use SafeArea so it won't be overlapped by gesture bar
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF9F1FF),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total: ₹$total",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // navigate to BillingPage (no popup)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillingPage(
                          items: orderItems,
                          subtotal: total,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD69ADE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
