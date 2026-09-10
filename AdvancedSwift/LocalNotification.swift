//
//  LocalNotification.swift
//  AdvancedSwift
//
//  Created by Emirhan Gökçe on 10.09.2026.
//

import SwiftUI
import UserNotifications
import CoreLocation

class LocalNotificationManager{
    static let instance = LocalNotificationManager()
    
    func requestAuthorization(){
        //Gerekli izinleri istiyoruz
        let options : UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error{
                print("ERROR \(error.localizedDescription)")
            }else{
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(){
        //MARK: 1- Değişken içeriğimizi oluşturuyoruz
        let content = UNMutableNotificationContent()
        content.title = "Su İçme Vakti! 💧"
        content.subtitle = "Sağlığın için önemli"
        content.body = "Bugün yeterince su içmedin, hadi hemen bir bardak su kap!"
        content.sound = .default
        content.badge = 1
        
        //MARK: 2- Zamana, tarihe ya da konuma göre trigger oluşturuyoruz
        //time
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        //TODO: EN ÖNEMLİSİ ! calendar -> Her gün saat 17.47de bildirim gelecek
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 47
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        //location
        let coordinate = CLLocationCoordinate2D(latitude: 40.00, longitude: 50.00)
        let region = CLCircularRegion(
            center: coordinate,
            radius: 100, //100 metre
            identifier: UUID().uuidString
        )
        region.notifyOnEntry = true //Bölgeye girerken bildirim at
        region.notifyOnExit = false //Bölgeden çıkarken atma
        
        //let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        //MARK: 3- İsteği oluşturuyoruz
        let request = UNNotificationRequest(
            identifier: "waterReminder", //İleride bunu takip etmek istersek kullanacağımız id
            content: content,
            trigger: trigger
        )
        //MARK: 4- İsteği yolluyoruz
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

struct LocalNotification: View {
    var body: some View {
        VStack(spacing:40){
            Button("Request permission"){
                LocalNotificationManager.instance.requestAuthorization()
            }
            Button("Schedule notification"){
                LocalNotificationManager.instance.scheduleNotification()
            }
            Button("Cancel notification"){
                LocalNotificationManager.instance.cancelNotifications()
            }
        }
        .task {
            do {
                // Badge sayısını 0 yaparak bildirim sayısını (kırmızı balonu) temizliyoruz
                try await UNUserNotificationCenter.current().setBadgeCount(0)
            } catch {
                print("Badge sıfırlanırken hata oluştu: \(error.localizedDescription)")
            }
        }
        
    }
    
}

#Preview {
    LocalNotification()
}
