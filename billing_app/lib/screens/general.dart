import 'package:flutter/material.dart';

class General extends StatefulWidget {
  final String categoryTitle;

  const General({super.key, required this.categoryTitle});

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  final TextEditingController _controller = TextEditingController();
  final List<String> items = [];

  // Hard-coded catalog (id, item, price)
  final List<Map<String, String>> _catalog = [
    {'id': '01', 'item': 'biscuit', 'price': '10'},
    {'id': '02', 'item': 'chocolate', 'price': '15'},
    {'id': '03', 'item': 'ice cream', 'price': '30'},
    {'id': '04', 'item': 'chips', 'price': '5'},
    {'id': '05', 'item': 'cake', 'price': '10'},
    {'id': '06', 'item': 'soda', 'price': '10'},
  ];

  // helper: list of item names
  late final List<String> _catalogNames;

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

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      items.add(text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F1FF),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFD69ADE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child:
                      const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.categoryTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final query = textEditingValue.text.toLowerCase();
                        if (query.isEmpty) return const Iterable<String>.empty();
                        return _catalogNames.where((name) =>
                            name.toLowerCase().contains(query));
                      },
                      displayStringForOption: (option) => option,
                      fieldViewBuilder:
                          (context, textController, focusNode, onFieldSubmitted) {
                        // use our controller so add button can read
                        textController.text = _controller.text;
                        textController.selection = _controller.selection;

                        // keep the backing controller in sync
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
                      onSelected: (String selection) {
                        // when user selects a suggestion, fill the input
                        _controller.text = selection;
                        // place cursor at end
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                        // optionally you could auto-add or show price
                        // e.g. find the price:
                        // final price = _catalog.firstWhere((c) => c['item']==selection)['price'];
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  // find price for display
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
  child: items.isEmpty
      ? const Center(
          child: Text(
            "No items added yet",
            style: TextStyle(fontSize: 16),
          ),
        )
      : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
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
                      items[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() => items.removeAt(index));
                    },
                  ),
                ],
              ),
            );
          },
        ),
),

// ---------------- NEXT BUTTON ----------------
Padding(
  padding: const EdgeInsets.only(bottom: 25, right: 20),
  child: Align(
    alignment: Alignment.bottomRight,
    child: GestureDetector(
      onTap: () {
        // Navigate to next page:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => NextPage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFD69ADE),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Next",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}
