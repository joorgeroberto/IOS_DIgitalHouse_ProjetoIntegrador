//
//  Form.swift
//  DigitlaPokedex
//
//  Created by Jorge Carvalho on 10/01/21.
//

import Foundation

class Form: NSObject, NSCoding{

    var name : String!
    var url : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        url = dictionary["url"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         name = aDecoder.decodeObject(forKey: "name") as? String
         url = aDecoder.decodeObject(forKey: "url") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }

    }

}
