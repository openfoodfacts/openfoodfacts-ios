import Foundation

/**
The `NotificationTokenHelper` class Wraps the observer token received from NotificationCenter.addObserver(forName:object:queue:using:)
and unregisters it in deinit.
*/
final class NotificationTokenHelper: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {
    func observe(name: NSNotification.Name?,
                 object obj: Any?,
                 queue: OperationQueue?,
                 using block: @escaping (Notification) -> Void) -> NotificationTokenHelper {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationTokenHelper(notificationCenter: self, token: token)
    }
}
