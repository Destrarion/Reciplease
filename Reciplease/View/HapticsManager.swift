import UIKit

final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() {}
    
    /// Create vibration of type notification on the iphone
    /// Not working on simulator, need a real iphone to test it working
    /// for more info of the type of vibration, check apple developpement documentation
    /// https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/haptics/
    /// - Parameter type: Type of vibration of the NotificationFeedbackGenerator ( .success. / .error / .warning )
    public func notificationVibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
    
   
}
