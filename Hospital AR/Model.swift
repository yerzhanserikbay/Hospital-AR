//
//  Model.swift
//  Hospital AR
//
//  Created by YS on 4/10/19.
//  Copyright © 2019 YS. All rights reserved.
//

import Foundation

protocol ActionAfterCloseViewControllerDelegate {
    func closeViewController()
}

struct ObjectInfo {

    private static let handText = "A hand is a prehensile, multi-fingered appendage located at the end of the forearm or forelimb of primates such as humans, chimpanzees, monkeys, and lemurs. A few other vertebrates such as the koala (which has two opposable thumbs on each \"hand\" and fingerprints extremely similar to human fingerprints) are often described as having \"hands\" instead of paws on their front limbs. The raccoon is usually described as having \"hands\" though opposable thumbs are lacking."
    private static let armText = "In human anatomy, the arm is the part of the upper limb between the glenohumeral joint (shoulder joint) and the elbow joint. In common usage, the arm extends to the hand. It can be divided into the upper arm, which extends from the shoulder to the elbow, the forearm which extends from the elbow to the hand, and the hand. Anatomically the shoulder girdle with bones and corresponding muscles is by definition a part of the arm. The Latin term brachium may refer to either the arm as a whole or to the upper arm on its own."

    private static let heartText = "心肺复苏的操作要点和注意事项包括：\n\n1、初期复苏(C、A、B步骤)：即基础生命支持(BLS)。\n\n(1)判断意识与反应在心肺复苏中极其重要，只有在准确地判断心跳呼吸骤停后，才能进行心肺复苏。判断过程要求在10秒内完成。如果病人对刺激无任何反应，大动脉搏动消失，即可判定心脏骤停。\n\n(2)人工循环(Circulation，C)。即心脏按压。\n\n①患者仰卧在硬质平板上，抢救者位于患者一侧。\n\n②应首先从进行30次按压开始心肺复苏，而不是进行2次通气。\n\n③按压部位在胸骨中下1/3交界处，双手掌根部相叠，两臂伸直，以上身的重力垂直按压，使胸骨下陷至少5cm，按压频率至少100次/分，保证每次按压后胸廓回弹。\n\n④心脏按压应与人工呼吸相结合。\n\n⑤成人不论两人操作还是单人操作，均每按压30次吹气2次。\n\n⑥按压和松开的时间比例为1:1时，心排血量最大。且按压不要受人工呼吸的影响。\n\n(3)开放气道(Airway，A)。开放气道、维持气道通畅是复苏关键。常用的方法有仰头举颏法和托颌法。\n\n(4)人工呼吸(Breathing，B)简易、有效、及时的人工呼吸是口对口人工呼吸。每分钟均匀地吹气10～12次，每次吹气应持续1秒以上，看见患者胸廓抬起方为有效。\n\n(5)复苏成功的标志是大动脉出现搏动，收缩压60mmHg以上，瞳孔缩小，发绀减退，自主呼吸恢复，意识恢复。\n\n2、二期复苏\n\n(1)复苏内容：ACLS是BLS的继续，是借助器械设备及复苏知识和技术，争取较佳疗效的阶段。包括药物治疗、除颤、起搏、气管插管等。\n\n(2)电除颤：是治疗心室纤颤的有效方法。\n\n(3)复苏药物的应用：给药途径以静脉给药为主，其他可用气管内、心内给药。"
    
    private static let biodigitalSpineBoneID = "2xwG"
    
    static func getText(for object: String) -> String {
        if object == "Arm" {
            return armText
        } else if object == "Hand" {
            return handText
        } else {
            return heartText
        }
    }
    
    static func getID(for object: String) -> String {
        if object == "spine-bone" {
            return biodigitalSpineBoneID
        } else {
            return "1234"
        }
    }
}

enum Animate {
    case hide
    case unhide
}

enum ConfigType {
    case imageTracking
    case worldTracking
}

