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

  test('Delete (non-root node)', () {
    var trie = BasicTrie<int, String>();
    trie.set([1, 2, 3], '123');
    trie.set([1, 2], '12');

    var removed = trie.remove([1, 2, 3]);
    expect(removed!.value, '123');
    expect(trie.get([1, 2, 3]), isNull);
    expect(trie.get([1, 2])?.value, '12');
    expect(trie.remove([1, 3, 4]), null);
  });

  test('Delete (root node)', () {
    var trie = BasicTrie<int, String>();
    trie.set([1], '1');

    var removed = trie.remove([1]);
    expect(removed!.value, '1');
    expect(trie.get([1]), isNull);
    expect(trie.remove([4]), null);
  });

  test('Delete parent', () {
    var trie = BasicTrie<int, String>();
    trie.set([1, 2, 3], '123');
    trie.set([1, 2, 4], '124');

    trie.remove([1, 2]);
    expect(trie.get([1, 2]), isNull);
    expect(trie.get([1, 2, 3]), isNull);
    expect(trie.get([1, 2, 4]), isNull);
  });

  test('Rename last component (non-root node)', () {
    var trie = BasicTrie<int, String>();
    trie.set([1, 2, 3], '123');

    trie.renameLastComponent([1, 2, 3], 4);
    expect(trie.get([1, 2, 3]), isNull);
    expect(trie.get([1, 2, 4])?.value, '123');
  });

  test('Rename last component (root node)', () {
    var trie = BasicTrie<int, String>();
    trie.set([1], '1');

    trie.renameLastComponent([1], 3);
    expect(trie.get([1]), isNull);
    expect(trie.get([3])?.value, '1');
  });
}
