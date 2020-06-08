import Foundation

/**
 The `NotificationCenterToken` class Wraps the observer token received from NotificationCenter.addObserver(forName:object:queue:using:)
 and unregisters it in deinit.
 This binds the lifetime of the notification observation to the lifetime of the wrapper object. All we have to do is store the wrapper in a private property so that it gets
 destroyed when its owner gets deallocated. So this is equivalent to manual unregistering in deinit, but has the benefit that you can’t forget it anymore. And by making
 the property an Optional​<Notification​Token>, you can unregister anytime simply by assigning nil.
 This pattern is known as Resource acquisition is initialization (RAII).
*/
final class NotificationCenterToken: NSObject {
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
                 using block: @escaping (Notification) -> Void) -> NotificationCenterToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationCenterToken(notificationCenter: self, token: token)
    }
}
