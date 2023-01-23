/// Represents a node in a [BasicTrie].
class Node<K, V> {
  /// The underlying map of this node.
  Map<K, Node<K, V>> map = {};

  /// The value associated with this entry.
  V? value;

  @override
  String toString() {
    return 'Node{value: $value, map: $map}';
  }
}

/// [K] key type.
/// [V] value type.
class BasicTrie<K, V> {
  bool logging = false;

  final Node<K, V> _rootNode = Node<K, V>();

  /// Sets the node value associated with the specified key.
  void set(List<K> keys, V val) {
    _log('Calling set with keys "$keys", val: "$val"');
    _checkKeys(keys);
    var node = _rootNode;
    for (var key in keys) {
      _log('Setting key "$key"');

      var target = node.map[key];
      if (target != null) {
        _log('Target found');
        node = target;
      } else {
        _log('Creating new node');
        var newNode = Node<K, V>();
        node.map[key] = newNode;
        node = newNode;
      }
    }
    node.value = val;
  }

  /// Gets the value associated with the specified key.
  Node<K, V>? get(List<K> keys) {
    _checkKeys(keys);
    return _getCore(_rootNode, keys, 0);
  }

  Node<K, V>? _getCore(Node<K, V> node, List<K> keys, int index) {
    // Exit condition.
    if (index >= keys.length) {
      _log('Found the value "${node.value}"');
      return node;
    }

    final key = keys[index];
    _logWithKey(key, 'Getting value with key "$key"');

    Node<K, V>? result;
    final target = node.map[key];
    if (target != null) {
      _logWithKey(key, 'Target found');
      result = _getCore(target, keys, index + 1);
    }

    _logWithKey(
      key,
      'Checking first attempt result "$result"',
    );
    if (result != null) {
      _logWithKey(key, 'Found the value at first attempt "$result"');
      return result;
    }
    _logWithKey(key, 'Nothing found');
    return result;
  }

  void _log(String s) {
    if (logging) {
      print(s);
    }
  }

  void _logWithKey(K key, String msg) {
    _log('KEY: $key | $msg');
  }

  void _checkKeys(List<K> keys) {
    if (keys.isEmpty) {
      throw 'Keys cannot be an empty array';
    }
  }
}
