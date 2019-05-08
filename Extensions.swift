//
//  Extensions.swift
//  ThePhenomizer
//
//  Created by Robert Wicks on 1/7/16.
//  Copyright © 2016 SE15 UniB. All rights reserved.
//

import Foundation

extension String {
    /// Percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
    
    // Get plist path in the document with this name
    func pathToPlist() -> String {
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let url = NSURL(string: rootPath)
        let plistPathInDocument = (url?.URLByAppendingPathComponent(self).absoluteString)!
        return plistPathInDocument;
    }
}

extension Dictionary {
    /// Build string representation of HTTP parameter dictionary of keys and objects in the form key1=value1&key2=value2
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
}