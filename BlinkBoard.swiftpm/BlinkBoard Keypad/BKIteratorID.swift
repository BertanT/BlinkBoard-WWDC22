//
//  BKIteratorID.swift
//  
//
//  Created with love and passion by Bertan
//
// Enum used to give tags to BKIterator objects! See BKIterator.swift for more!

enum BKIteratorID {
    case main,
         oneM, oneA, oneB, // Row one iterator and it's sub iterators and so on!
         twoM, twoA, twoB,
         threeM, threeA, threeB,
         fourM, fourA, fourB,
         control, // The last row does not have any sub row iterators
         wordPredictions, // The word prediction iterator next to the text field
         moreMenu // The more menu iterator that can be accessed with the last button of the last row
}
