/// Represents a node in a [BasicTrie].
class BasicTrieNode<K, V> {
  /// The underlying map of this node.
  Map<K, BasicTrieNode<K, V>> map = {};

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

  final BasicTrieNode<K, V> _rootNode = BasicTrieNode<K, V>();

  BasicTrieNode<K, V> get rootNode => _rootNode;

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
        var newNode = BasicTrieNode<K, V>();
        node.map[key] = newNode;
        node = newNode;
      }
    }
    node.value = val;
  }

  /// Gets the value associated with the specified key.
  BasicTrieNode<K, V>? get(List<K> keys) {
    _checkKeys(keys);
    var node = _getCore(_rootNode, keys, 0);
    if (node == null) {
      return null;
    }
    // Handle empty node due to deletion.
    if (node.map.isEmpty && node.value == null) {
      return null;
    }
    return node;
  }

  /// Deletes the value associated with the specified key.
  /// Returns false if value is not found.
  bool remove(List<K> keys) {
    _checkKeys(keys);

    var parentNode = _getParentNode(keys);
    if (parentNode == null) {
      return false;
    }
    var lastComponent = keys.last!;
    if (parentNode.map[lastComponent] == null) {
      return false;
    }
    parentNode.map.remove(lastComponent);
    return true;
  }

  /// Renames the last component of a specified key to a new name.
  /// Returns false if value is not found.
  bool renameLastComponent(List<K> keys, K newLastComponent) {
    _checkKeys(keys);

    var parentNode = _getParentNode(keys);
    if (parentNode == null) {
      return false;
    }

    var lastComponent = keys.last!;
    var lastNode = parentNode.map[lastComponent];
    if (lastNode == null) {
      return false;
    }
    parentNode.map.remove(lastComponent);
    parentNode.map[newLastComponent] = lastNode;
    return true;
  }

  BasicTrieNode<K, V>? _getParentNode(List<K> keys) {
    return keys.length == 1 ? _rootNode : get(keys.sublist(0, keys.length - 1));
  }

  /// NOTE: this can return an empty node (node.map is empty && node.value == null) if the node was
  /// removed by [remove].
  BasicTrieNode<K, V>? _getCore(
      BasicTrieNode<K, V> node, List<K> keys, int index) {
    // Exit condition.
    if (index >= keys.length) {
      _log('Found the value "${node.value}"');
      return node;
    }

    final key = keys[index];
    _logWithKey(key, 'Getting value with key "$key"');

    BasicTrieNode<K, V>? result;
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
