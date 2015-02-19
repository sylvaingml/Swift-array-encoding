//
//  main.swift
//  Swift-array-encoding
//
//  Created by Sylvain on 19/02/2015.
//

import Foundation

/* A simple class to wrap array of strings
 */
class Sentence: NSObject, NSCoding
{
    var words: [String]!
    
    let countKey = "size"
    
    
    override init()
    {
        super.init()
        
        words = [String]()
    }
    
    required init(coder decoder: NSCoder)
    {
        super.init()
        
        // Get number of encoded objects
        let nbCounter = decoder.decodeIntegerForKey(countKey)
        words = [String]()
        
        // Extract object from encoded data as many times as specified
        for index in 0 ..< nbCounter {
            if var word = decoder.decodeObject() as? String {
                words.append(word)
            }
        }
    }
    
    func encodeWithCoder(encoder: NSCoder)
    {
        encoder.encodeInteger(words.count, forKey: countKey)
        
        for index in 0 ..< words.count {
            encoder.encodeObject( words[ index ] )
        }
    }
    
    
    /** This allow to use the bracket syntax to access elements.
     */
    subscript(index: Int) -> String {
        /** Implements: sentence[ index ] -> String
         */
        get
        {
            return words[ index ]
        }
        
        /** Implements: sentence[ index ] = aString
         */
        set(newValue)
        {
            if ( index < words.count )
            {
                words[ index ] = newValue
            }
            else
            {
                words.append(newValue)
            }
        }
    }
    
    
    /** Standard way to build a human readable object. 
     */
    func description() -> String
    {
        return "Sentence=[" + join(", ", words) + "]"
    }
}


// Now, let's try to encode something

let example =  "This is not the robot you are looking for."
let sampleArray = example.componentsSeparatedByString(" ")

var sentence = Sentence()
for word in sampleArray {
    sentence[99] = word
}

println("First value: \( sentence )")


println("Encoding and decoding")

let carbonite = NSKeyedArchiver.archivedDataWithRootObject(sentence)

let lazarus = NSKeyedUnarchiver.unarchiveObjectWithData(carbonite) as Sentence

println("New object, decoded from NSData: \( lazarus )")
