import 'package:flutter/material.dart';
import './general/order.dart';

class General extends StatefulWidget {
  final String categoryTitle;

  const General({super.key, required this.categoryTitle});

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  final TextEditingController _controller = TextEditingController();

  // selected items stored as maps with 'item' and 'price' (both strings)
  final List<Map<String, String>> selectedItems = [];

  // Hard-coded catalog (id, item, price)
  final List<Map<String, String>> _catalog = [
    {'id': '01', 'item': 'biscuit', 'price': '10'},
    {'id': '02', 'item': 'chocolate', 'price': '15'},
    {'id': '03', 'item': 'ice cream', 'price': '30'},
    {'id': '04', 'item': 'chips', 'price': '5'},
    {'id': '05', 'item': 'cake', 'price': '10'},
    {'id': '06', 'item': 'soda', 'price': '10'},
  ];

  late final List<String> _catalogNames;

  // used to detect left-edge drag for back gesture
  double _dragStartX = 0;

  @override
  void initState() {
    super.initState();
    _catalogNames = _catalog.map((e) => e['item'] ?? '').toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Adds item; if item already selected, just increase quantity later on next page
  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // find price from catalog
    final entry = _catalog.firstWhere(
      (c) => c['item'] == text,
      orElse: () => {'item': text, 'price': '0'},
    );
    setState(() {
      selectedItems.add({'item': entry['item']!, 'price': entry['price']!});
      _controller.clear();
    });
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
        body: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 30),
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
                    "General",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // INPUT ROW (with Autocomplete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "Items :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),

                  // Autocomplete wrapped in a decorated container
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black, width: 2.2),
                      ),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue v) {
                          final q = v.text.toLowerCase();
                          if (q.isEmpty) return const Iterable<String>.empty();
                          return _catalogNames.where(
                              (name) => name.toLowerCase().contains(q));
                        },
                        fieldViewBuilder:
                            (context, textController, focusNode, onFieldSubmitted) {
                          // sync our controller with field controller
                          // keep textController as the source of truth for the Autocomplete field
                          textController.text = _controller.text;
                          textController.selection = _controller.selection;
                          textController.addListener(() {
                            _controller.text = textController.text;
                            _controller.selection = textController.selection;
                          });

                          return TextField(
                            controller: textController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: "Enter item",
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _addItem(),
                          );
                        },
                        onSelected: (selection) {
                          _controller.text = selection;
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length));
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 200),
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    final entry = _catalog.firstWhere(
                                        (c) => c['item'] == option,
                                        orElse: () => {});
                                    final price = entry['price'] ?? '';
                                    return ListTile(
                                      title: Text(option),
                                      subtitle: price.isNotEmpty
                                          ? Text('Price: ₹$price')
                                          : null,
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: _addItem,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ITEMS LIST
            Expanded(
              child: selectedItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No items added yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        final it = selectedItems[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "${it['item']}  •  ₹${it['price']}",
                                style: const TextStyle(fontSize: 16),
                              )),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() => selectedItems.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),

        // ---------------- FIXED BOTTOM BUTTON ----------------
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: const Color(0xFFF9F1FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: selectedItems.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderQuantityPage(items: selectedItems),
                            ),
                          );
                        },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedItems.isEmpty
                          ? Colors.grey.shade300
                          : const Color(0xFFD69ADE),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.black),
                      ],
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
