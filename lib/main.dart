import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'First Flutter App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Initialize the current WordPair
  var current = WordPair.random();

  // Get the next WordPair
  void getNext() {
    current = WordPair.random();

    // Notify listeners that the current WordPair has changed
    notifyListeners();
  }

  // Array of WordPair objects
  var favorites = <WordPair>[];

  void toggleFavorite() {
    // Returns true if the current WordPair is in the favorites array
    if (favorites.contains(current)) {
      // Remove the current WordPair from the favorites array
      favorites.remove(current);
    } else {
      // Add the current WordPair to the favorites array
      favorites.add(current);
    }
    // Notify listeners that the favorites array has changed
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  // The build method rebuilds the widget tree when the state changes
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // Scaffold is a widget that provides a default app bar, title, and a body
    return Scaffold(
      // Center is a widget that centers its child
      body: Center(
        // Column is a widget that displays its children in a vertical array
        // Columns contains a Row element, this way you get a grid like layout
        child: Column(
          // MainAxisAlignment.center centers the children vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // See BigCard widget below
            BigCard(pair: pair),
            // SizedBox is a widget that displays an empty box for spacing elements
            SizedBox(height: 20),
            // Row is a widget that displays its children in a horizontal array
            Row(
              // MainAxisSize.min sets the size of the Row to the minimum size,
              // this way the Row will only take up as much space as it needs
              // and not the whole width of the screen.
              mainAxisSize: MainAxisSize.min,
              // This row contains 2 buttons:
              children: [
                // Next button
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
                // Space buttons apart horizontally with SizedBox
                SizedBox(width: 10),
                // Like button
                ElevatedButton(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  child: Text('Like'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// A stateless widget that displays a WordPair on a "big" card
class BigCard extends StatelessWidget {
  // BigCard constructor
  const BigCard({
    // `super.key` is a special property that is used to identify widgets
    super.key,
    // `required` means that the variable must be set when the widget is created
    // BigCard requires a WordPair to be passed in
    required this.pair,
  });

  // The WordPair to display on the card
  // `final` means that the value of the variable cannot change after it is set
  final WordPair pair;

  // Rebuild the BigCard widget when the state changes
  @override
  Widget build(BuildContext context) {
    // `Theme.of(context)` gets the current theme
    var theme = Theme.of(context);
    // `textTheme` is a collection of text styles
    // `displaySmall` is a text style that is used for the card text
    // `copyWith` creates a new text style from the current one
    var style = theme.textTheme.displaySmall!.copyWith(
      // `colorScheme.onPrimary` is the text color for the current theme
      // that will fit the best on the primary color
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // `color` is the background color of the card
      color: theme.colorScheme.primary,
      // Add padding inside the card
      child: Padding(
        // `EdgeInsets.all` is shorthand for
        // `EdgeInsets.symmetric(vertical: 20, horizontal: 20)`
        // `EdgeInsets.symmetric` is shorthand for
        // `EdgeInsets.only(top: 20, right: 20, bottom: 20, left: 20)`
        padding: const EdgeInsets.all(20),
        child: Text(
          // `pair.asPascalCase` converts the WordPair to PascalCase
          // this is a function from the english_words package
          pair.asPascalCase,
          // `style` is the text style to use for the text in the card
          style: style,
          // `semanticsLabel` is for accessibility like screen readers to be
          // able to separate the words when all is in lower case:
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
