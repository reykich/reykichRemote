import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard self.count > index, index >= 0 else { return nil }
        return self[index]
    }
}
