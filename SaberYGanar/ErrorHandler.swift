//
//  ErrorHandler.swift
//  SaberYGanar
//
//  Created by Jordi Carbó Rodríguez on 28/11/2019.
//  Copyright © 2019 Jordi Carbó Rodríguez. All rights reserved.
//

import Foundation

class ErrorHandler{
    enum ValidationError: Error{
        case emptyWord
        case tooLong
        case invalidCharacterFound(Character)
    }
    
    func validate(word: String)throws{
        
        if word == ""{
            throw ValidationError.emptyWord
        }
    }
    
    func wordToCheck(word: String) -> Bool {
        do {
            try validate(word: word)
        }
        catch ValidationError.emptyWord{
            print("The word is empty")
            return true
        }
        catch{
            print(error)
            return false
        }
        return false
    }
    
    
    
    
}

