import 'package:basic_trie/basic_trie.dart';
import 'package:test/test.dart';

void main() {
  test('Get and set values', () {
    var trie = BasicTrie<int, String>();
    expect(trie.get([1, 2, 3]), isNull);

    trie.set([1, 2, 3], '123');
    expect(trie.get([1, 2, 3])?.value, '123');
    expect(trie.get([1, 2])?.value, isNull);
    expect(trie.get([1, 2])?.map.length, 1);
    expect(trie.get([1, 2, 3, 4]), isNull);
    expect(trie.get([1])?.value, null);
    expect(trie.get([1])?.map.length, 1);
    expect(trie.get([2, 1]), isNull);
  });

  test('Get a node', () {
    var trie = BasicTrie<int, String>();
    trie.set([1, 2, 3], '123');
    trie.set([1, 3, 2], '132');

    expect(trie.get([1])?.value, null);
    expect(trie.get([1])?.map.length, 2);
    expect(trie.get([1, 2, 3])?.value, '123');
    expect(trie.get([1, 3, 2])?.value, '132');
  });

  test('Node with both value and map', () {
    var trie = BasicTrie<int, String>();
    trie.set([1, 2], '12');
    trie.set([1, 2, 3], '123');
    expect(trie.get([1, 2])?.value, '12');
    expect(trie.get([1, 2, 3])?.value, '123');
  });
}
