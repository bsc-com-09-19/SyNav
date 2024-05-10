import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Search Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatelessWidget {
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: searchController.clearSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchController.filterData,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for fruits',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: searchController.clearSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: searchController.filteredData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: searchController.highlightMatches(searchController.filteredData[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchController extends GetxController {
  final data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Peach',
    'Quince',
    'Raspberry',
    'Strawberry',
    'Tomato',
    'Ugli fruit',
    'Watermelon',
  ];

  var filteredData = <String>[].obs;
  var query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initially, display the first 10 items
    filteredData.value = data.take(10).toList();
  }

  void filterData(String value) {
    query.value = value;
    filteredData.value = data
        .where((element) => element.toLowerCase().contains(query.value.toLowerCase()))
        .take(10)
        .toList();
  }

  void clearSearch() {
    query.value = '';
    filteredData.value = data.take(10).toList();
  }

  // Function to highlight the matching letters
  Widget highlightMatches(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(query.value, caseSensitive: false);
    Iterable<Match> matches = exp.allMatches(text);
    int lastIndex = 0;
    for (Match match in matches) {
      spans.add(TextSpan(
        text: text.substring(lastIndex, match.start),
      ));
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue, // Change color here
        ),
      ));
      lastIndex = match.end;
    }
    spans.add(TextSpan(
      text: text.substring(lastIndex),
    ));

    return RichText(text: TextSpan(children: spans));
  }
}
