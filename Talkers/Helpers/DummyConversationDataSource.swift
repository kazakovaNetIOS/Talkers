//
//  DummyConversationDataSource.swift
//  Talkers
//
//  Created by Natalia Kazakova on 30.09.2020.
//  Copyright © 2020 Natalia Kazakova. All rights reserved.
//

import Foundation

enum DummyConversationDataSource {
  // swiftlint:disable line_length
  private static var messages = [
    MessageModel(text: "Давай проверим, помнишь ли ты классику серебряного века? Расскажем стих надвоих.", type: .incoming),
    MessageModel(text: "О чем речь?", type: .outgoing),
    MessageModel(text: "Давай на злобу дня, про осень. Помнишь Цветаеву, \"Когда гляжу на летящие листья\"? Я начну", type: .incoming),
    MessageModel(text: "Когда гляжу на летящие листья,", type: .incoming),
    MessageModel(text: "А мне что, нужно продолжить?", type: .outgoing),
    MessageModel(text: "Слетающие на булыжный торец,", type: .outgoing),
    MessageModel(text: "Сметаемые — как художника кистью,", type: .incoming),
    MessageModel(text: "Картину кончающего наконец,", type: .outgoing),
    MessageModel(text: "Я думаю (уж никому не по нраву", type: .incoming),
    MessageModel(text: "Ни стан мой, ни весь мой задумчивый вид),", type: .outgoing),
    MessageModel(text: "Что явственно желтый, решительно ржавый", type: .incoming),
    MessageModel(text: "Один такой лист на вершине — забыт.", type: .outgoing),
    MessageModel(text: "Все верно!", type: .incoming)
  ]
  // swiftlint:enable line_length

  static func getMessage(by indexPath: IndexPath) -> MessageModel {
    return messages[indexPath.row]
  }

  static func getMessagesCount() -> Int {
    return messages.count
  }
}
