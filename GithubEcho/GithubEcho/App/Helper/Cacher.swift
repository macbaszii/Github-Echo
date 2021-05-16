import Foundation

final class Cacher<Key: Hashable, Value> {

    private let wrapped = NSCache<WrappedKey, Entry>()

    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(with: value)
        wrapped.setObject(entry, forKey: WrappedKey(with: key))
    }

    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(with: key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(with: key))
    }

    // Type Declaration

    final class WrappedKey: NSObject {
        let key: Key

        init(with key: Key) {
            self.key = key
        }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return value.key == key
        }
    }

    final class Entry {

        let value: Value

        init(with value: Value) {
            self.value = value
        }
    }
}
