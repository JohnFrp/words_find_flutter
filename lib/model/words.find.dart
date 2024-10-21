import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:words_find/provider/theme.provider.dart';

class WordFind extends StatefulWidget {
  const WordFind({super.key});

  @override
  State<WordFind> createState() => _WordFindState();
}

class _WordFindState extends State<WordFind> {
  String? _selectedItem;

  bool isSelected = ThemeProvider().isSelected;

  final TextEditingController _textController = TextEditingController();

  List<String> _uniqueWords = [];

  final List<String> _items = [
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15'
  ];

  List<String> findUniqueWords(String text, int wordLength) {
    final regExp = RegExp(r'\b\w{' + wordLength.toString() + r'}\b');
    final words =
        regExp.allMatches(text).map((match) => match.group(0)!).toSet();
    return words.map((word) => word.toUpperCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Words Find App"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.white,
                  thumbColor: const WidgetStatePropertyAll(Colors.orange),
                  inactiveTrackColor: Colors.transparent,
                  thumbIcon: WidgetStatePropertyAll(themeProvider.isSelected
                      ? const Icon(Icons.nights_stay)
                      : const Icon(Icons.sunny)),
                  value: themeProvider.isSelected,
                  onChanged: (value) {
                    setState(() {
                      themeProvider.toggleTheme();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 350,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextField(
              controller: _textController,
              expands: true,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Input Paragraph",
                filled: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Check if the width is less than 600
                if (constraints.maxWidth < 600) {
                  // Use a Column for small screens
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Choose Words Length :",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        value: _selectedItem,
                        isExpanded: true,
                        hint: const Text("Select Words Length"),
                        items: _items.map((String value) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedItem = newValue;
                          });
                        },
                      ),
                      const SizedBox(
                          height: 20), // Add spacing between elements
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _uniqueWords = findUniqueWords(_textController.text,
                                int.parse(_selectedItem.toString()));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(MediaQuery.of(context).size.width,
                              50), // Set the width and height
                          padding: const EdgeInsets.symmetric(
                              vertical: 15), // Optional padding
                        ),
                        child: const Text(
                          'Generate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Use a Row for larger screens
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Choose Words Length :          ",
                      ),
                      DropdownButton<String>(
                        alignment: Alignment.center,
                        value: _selectedItem,
                        hint: const Text("Select Words Length"),
                        items: _items.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            alignment: Alignment.center,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedItem = newValue;
                          });
                        },
                      ),
                      const SizedBox(width: 50),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _uniqueWords = findUniqueWords(_textController.text,
                                int.parse(_selectedItem.toString()));
                          });
                        },
                        child: const Text('Generate'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          if (_uniqueWords.isNotEmpty)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Check screen width and adjust the number of columns accordingly
                  int crossAxisCount = constraints.maxWidth < 600 ? 2 : 5;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          crossAxisCount, // Dynamically set number of columns
                      crossAxisSpacing: 10, // Spacing between columns
                      mainAxisSpacing: 10, // Spacing between rows
                      childAspectRatio: 4,
                    ),
                    itemCount: _uniqueWords.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          _uniqueWords[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else
            const Text('No words found for the specified length.'),
        ],
      ),
    );
  }
}
