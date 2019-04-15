//
//  Model.swift
//  Hospital AR
//
//  Created by YS on 4/10/19.
//  Copyright © 2019 YS. All rights reserved.
//

import Foundation

struct ObjectInfo {
    
    private static let handText = "A hand is a prehensile, multi-fingered appendage located at the end of the forearm or forelimb of primates such as humans, chimpanzees, monkeys, and lemurs. A few other vertebrates such as the koala (which has two opposable thumbs on each \"hand\" and fingerprints extremely similar to human fingerprints) are often described as having \"hands\" instead of paws on their front limbs. The raccoon is usually described as having \"hands\" though opposable thumbs are lacking."
    private static let armText = "In human anatomy, the arm is the part of the upper limb between the glenohumeral joint (shoulder joint) and the elbow joint. In common usage, the arm extends to the hand. It can be divided into the upper arm, which extends from the shoulder to the elbow, the forearm which extends from the elbow to the hand, and the hand. Anatomically the shoulder girdle with bones and corresponding muscles is by definition a part of the arm. The Latin term brachium may refer to either the arm as a whole or to the upper arm on its own."

    
    static func getText(for object: String) -> String {
        if object == "Arm" {
            return armText
        } else {
            return handText
        }
    }
}
