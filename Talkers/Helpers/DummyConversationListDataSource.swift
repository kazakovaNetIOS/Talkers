//
//  DummyDataSource.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

class DummyConversationListDataSource {
    private static var conversationList = [
        [
            ConversationModel(name: "Лев Толстой", message: "Последнее время мне стало жить тяжело. Я вижу, я стал понимать слишком много.", date: Date(), isOnline: true, hasUnreadMessage: true),
            ConversationModel(name: "Сергей Довлатов", message: "", date: from(year: 2020, month: 9, day: 28), isOnline: true, hasUnreadMessage: false),
            ConversationModel(name: "Михаил Салтыков-Щедрин", message: "Пошлость имеет громадную силу; она всегда застанет свежего человека врасплох...", date: from(year: 2020, month: 9, day: 28), isOnline: true, hasUnreadMessage: true),
            ConversationModel(name: "Иосиф Бродский", message: "Отсутствие есть всего лишь домашний адрес небытия...", date: from(year: 2020, month: 9, day: 26), isOnline: true, hasUnreadMessage: false),
            ConversationModel(name: "Александр Пушкин", message: "В молчании добро должно твориться.", date: from(year: 2020, month: 9, day: 25), isOnline: true, hasUnreadMessage: true),
            ConversationModel(name: "Венедикт Ерофеев", message: "...худшая из дурных привычек — решаться на подвиг, в котором больше вежливости, чем сострадания.", date: from(year: 2020, month: 8, day: 27), isOnline: true, hasUnreadMessage: false),
            ConversationModel(name: "Михаил Лермонтов", message: "", date: from(year: 2020, month: 8, day: 31), isOnline: true, hasUnreadMessage: false),
            ConversationModel(name: "Дон-Аминадо", message: "Когда душа ближе всего к земле? — Когда она уходит в пятки.", date: from(year: 2020, month: 8, day: 20), isOnline: true, hasUnreadMessage: false),
            ConversationModel(name: "Николай Гоголь", message: "Теперь передо мной всё открыто. Теперь я вижу всё как на ладони. А прежде, я не понимаю, прежде всё было передо мной в каком-то тумане.", date: from(year: 2020, month: 5, day: 5), isOnline: true, hasUnreadMessage: false),
            ConversationModel(name: "Андрей Вознесенский", message: "Дай тебе не ведать, как грущу. Я тебя не огорчу собою. Даже смертью не обеспокою. Даже жизнью не отягощу.", date: from(year: 2020, month: 2, day: 14), isOnline: true, hasUnreadMessage: true)
        ],
        [
            ConversationModel(name: "Иван Тургенев", message: "Как все русские дворяне, он в молодости учился музыке и, как почти все русские дворяне, играл очень плохо; но он страстно любил музыку.", date: from(year: 2020, month: 9, day: 29), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Станислав Ежи Лец", message: "Я знал человека столь мало начитанного, что ему приходилось самому сочинять цитаты из классиков.", date: from(year: 2020, month: 9, day: 27), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Александр Радищев", message: "Я приметил из многочисленных примеров, что русский народ очень терпелив и терпит до самой крайности; но когда конец положит своему терпению, то ничто не может его удержать...", date: from(year: 2020, month: 8, day: 17), isOnline: false, hasUnreadMessage: true),
            ConversationModel(name: "Анна Ахматова", message: "Я научила женщин говорить... Но, боже, как их замолчать заставить!", date: from(year: 2020, month: 7, day: 23), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Владимир Высоцкий", message: "И рано нас равнять с болотной слизью - Мы гнёзд себе на гнили не совьём! Мы не умрём мучительною жизнью - Мы лучше верной смертью оживём!", date: from(year: 2020, month: 6, day: 13), isOnline: false, hasUnreadMessage: true),
            ConversationModel(name: "Денис Фонвизин", message: "Не хочу учиться, хочу жениться.", date: from(year: 2020, month: 5, day: 7), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Евгений Евтушенко", message: "", date: from(year: 2020, month: 4, day: 9), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Козьма Прутков", message: "Что имеем - не храним; потерявши - плачем.", date: from(year: 2020, month: 3, day: 31), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Максим Горький", message: "И едва ли даже когда-нибудь человека нужно пожалеть... Лучше — помочь ему.", date: from(year: 2020, month: 2, day: 2), isOnline: false, hasUnreadMessage: false),
            ConversationModel(name: "Михаил Булгаков", message: "Нет документа, нет и человека.", date: from(year: 2020, month: 1, day: 1), isOnline: false, hasUnreadMessage: false)
        ]
    ]
    
    private static func from(year: Int, month: Int, day: Int) -> Date {
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        guard let date = gregorianCalendar.date(from: dateComponents) else {
            return Date()
        }
        
        return date
    }
    
    static func getConversation(by indexPath: IndexPath) -> ConversationModel {
        if indexPath.section == 1 {
            return conversationList[indexPath.section].filter { !$0.isEmptyMessage }[indexPath.row]
        } else {
            return conversationList[indexPath.section][indexPath.row]
        }
    }
    
    static func getConversationsCount(for section: Int) -> Int {
        if section == 1 {
            return conversationList[section].filter { !$0.isEmptyMessage }.count
        } else {
            return conversationList[section].count
        }
    }
    
    static func getSectionCount() -> Int {
        return conversationList.count
    }
}

