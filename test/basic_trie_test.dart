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

  test('Move', () {
    // Replace dest with src.
    var trie = BasicTrie<int, String>();
    trie.set([1], '1');
    trie.set([1, 2], '12');

    trie.move([1, 2], [1]);
    expect(trie.get([1])?.value, '12');
    expect(trie.get([1, 2]), null);

    // Replace dest with src as a tree.
    trie = BasicTrie<int, String>();
    trie.set([1], '1');
    trie.set([4, 5, 6, 7], '4567');

    trie.move([4, 5], [1]);
    expect(trie.get([1, 6, 7])?.value, '4567');
    expect(trie.get([4, 5, 6, 7]), null);

    trie = BasicTrie<int, String>();
    trie.set([1, 2, 3], '123');
    trie.set([1, 4], '14');
    trie.set([4, 5, 6, 7], '4567');

    trie.move([4, 5], [1, 2]);
    expect(trie.get([1, 2, 6, 7])?.value, '4567');
    expect(trie.get([1, 4])?.value, '14');
    expect(trie.get([1, 2, 7]), null);

    // Create new dest path.
    trie = BasicTrie<int, String>();
    trie.set([1], '1');
    trie.set([4, 2], '42');

    trie.move([4, 2], [2, 3]);
    expect(trie.get([2, 3])?.value, '42');
    expect(trie.get([1])?.value, '1');
    expect(trie.get([4, 2]), null);

    // Delete dest.
    trie = BasicTrie<int, String>();
    trie.set([1, 2, 3], '123');

    trie.move([9], [1, 2, 3]);
    expect(trie.get([1, 2, 3])?.value, null);
  });
}
