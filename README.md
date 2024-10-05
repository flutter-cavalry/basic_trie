## basic_trie

[![pub package](https://img.shields.io/pub/v/basic_trie.svg)](https://pub.dev/packages/basic_trie)
[![Build Status](https://github.com/flutter-cavalry/basic_trie/workflows/Build/badge.svg)](https://github.com/flutter-cavalry/basic_trie/actions)

A simple trie implementation in Dart.

## Usage

```dart
void main() {
  var trie = BasicTrie<int, String>();

  trie.set([1, 2, 3], '123');
  trie.set([1, 3, 5, 7], '1357');

  // Full match.
  print(trie.get([1, 2, 3]));
  // Node{value: 123, map: {}}

  // No match.
  print(trie.get([1, 4]));
  // null

  // Partial match (key path is valid but doesn't have a value associated with it)
  print(trie.get([1, 2]));
  // Node{value: null, map: {3: Node{value: 123, map: {}}}}

  // Delete a value.
  trie.remove([1, 2, 3]);
  print(trie.get([1, 2, 3]));
  // null

  // Renames the last key component of a value.
  trie.renameLastComponent([1, 3, 5, 7], -7);
  print(trie.get([1, 3, 5, 7]));
  // null
  print(trie.get([1, 3, 5, -7]));
  // Node{value: 1357, map: {}}
}
```
