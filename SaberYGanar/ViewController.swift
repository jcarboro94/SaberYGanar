//
//  ViewController.swift
//  SaberYGanar
//
//  Created by Jordi Carbó Rodríguez on 25/11/2019.
//  Copyright © 2019 Jordi Carbó Rodríguez. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rightWords.count
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        
    }
    
//    MARK: Table View
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = rightWords[indexPath.row]
        
        return cell
    }
    
//    MARK: Collection View
    
    let consonantes = ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","V","W","X","Y","Z"]
    let vocales = ["A","E","I","O","U"]
    var alphabet =  [""]
    
    var rightWords = [""]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        alphabet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! LetterViewCell
        cell.buttonLetter.setTitle(alphabet[indexPath.row], for: .normal)
        cell.buttonLetter.isSelected = false
        cell.buttonLetter.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        

        return cell
    }
    
    var buttonsArray: [UIButton] = []
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        if let letra  = sender.titleLabel?.text {
            print(letra)
//            print(buttonsArray)
            palabraLabel.text! += letra
            lastLetterChosen = sender
            
        }
        sender.isSelected = true
        sender.isEnabled = false
        buttonsArray.append(sender)
        
        for i in 0...buttonsArray.count - 1 {
            print(buttonsArray[i].titleLabel?.text)
        }
        print("___________________________")
        
    }
    
//  MARK Delete Button
    
    @IBAction func deleteButton(_ sender: UIButton) {
        if palabraLabel.text?.isEmpty == false {
            var lastCharacterString = String((palabraLabel.text?.last)!)

            let errorHandler = ErrorHandler()
            
            if errorHandler.wordToCheck(word: palabraLabel.text ?? "") == true {
                print("NAAAH")
            } else{
                let lastIndex = buttonsArray.count - 1
                buttonsArray[lastIndex].isSelected = false
                buttonsArray[lastIndex].isEnabled = true
                buttonsArray.removeLast()
                
                palabraLabel.text?.removeLast()
            }

            
        } else {
            print("error")
        }
        
    }
    
    var previousletterChosen: UIButton?
    var lastLetterChosen: UIButton?

    
    @IBOutlet var palabraLabel: UILabel!
    
//    MARK: Check Word
    
    @IBOutlet var comprobacionLabel: UILabel!
    
    var numOfCharCheck = 0
    var wordExists = false
    
    func checkAnswer() -> Bool{
//        var url = "https://store.apicultur.com/api/corrige-palabra/1.0.0/\(palabraLabel.text)"
//
        let url = "https://store.apicultur.com/api/corrige-palabra/1.0.0/\(palabraLabel.text ?? "perfasfasfe")"
             
         let headers: HTTPHeaders = [
           "Authorization": "Bearer uHS_7Q2Esg7XsUKNsaqFx2sB1mca",
           "Accept": "application/json"
         ]
         
        
         Alamofire.request(url,headers: headers).responseJSON { response in
             
             //print(response.response) // http url response
             print(response.result)  // response serialization result
            print(response.description)
            print(response.description.count)
//            is valid when return is 12!!
            self.numOfCharCheck = response.description.count
            if response.description.contains("error"){
                print("error!!!!!!!")
                self.wordExists = false
                
                self.wrongWord()
                
            } else {
                print("aciertoooo!!!")
                self.wordExists = true
                self.rightWord()
            }
            
         }
        return wordExists
    }
    
    
    
//    MARK: Check Button
    
    @IBAction func checkButton(_ sender: UIButton) {

        
        let errorHandler = ErrorHandler()
        
        if errorHandler.wordToCheck(word: palabraLabel.text ?? "") == true {
            print("NAAAH")
        } else{
             checkAnswer()
        }
    }
    
    
    @IBOutlet var scoreLabel: UILabel!
    
    var score = 0
    
    func rightColorEffect(){
        palabraLabel.textColor = .green
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                   

            self.rightWords.append(self.palabraLabel.text!)
            self.wordsTableView.reloadData()
            self.score += self.palabraLabel.text?.count ?? 0
            self.scoreLabel.text = "Score: \(self.score)"
            
            for i in self.buttonsArray {
                i.isEnabled = true
                i.isSelected = false
            }
            self.buttonsArray = []
            self.palabraLabel.text = ""
            self.palabraLabel.textColor = .black
               }
        
    }
    
    func rightWord(){
        rightColorEffect()

    }
    
    func wrongWord(){

        palabraLabel.textColor = .red
            
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.palabraLabel.textColor = .black

            }
    }
    

    func updateAlphabet(){
        alphabet.removeLast()
        for _ in 1...5{
            let randomNumberConsonantes = Int.random(in: 0 ..< consonantes.count - 1)
            alphabet.append(consonantes[randomNumberConsonantes])
        }
        for _ in 1...5{
            let randomNumberVocales = Int.random(in: 0 ..< vocales.count - 1)
            alphabet.append(vocales[randomNumberVocales])
        }
        
    }
//    MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAlphabet()
        palabraLabel.text = ""
    }
    
    @IBOutlet var wordsTableView: UITableView!

    
    //MARK: Timer
    
    var timerVariable = 60
    
    @IBOutlet var startGameOutlet: UIButton!
    
    
//    MARK: Start Game

    var timer = Timer.init()
    
    @IBAction func startGame(_ sender: UIButton) {
        
        rightWords.removeAll()
        score = 0
        scoreLabel.text = "Score: \(score)"
        wordsTableView.reloadData()
        
        if timer.isValid {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)

        
        timerVariable = 60
            
    }
    @objc func fire()
            {
                if timerVariable > 0 {
                    startGameOutlet.isEnabled = false
                    startGameOutlet.setTitle("Tiempo restante:", for: .disabled)
                    startGameOutlet.setTitleColor(.orange, for: .disabled)
//                    print("\(timer)!!!")
                    timeLeftOutlet.text = "\(timerVariable)"
                                
                    timerVariable -= 1
                } else if timerVariable == 0 {
                    timeLeftOutlet.text = "Time's Up!"
                    endGame()
                }
                
            }
    @IBOutlet var timeLeftOutlet: UILabel!
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
//    MARK: End Game
    
    func endGame(){
        showToast(message: "Insert one coin", font: .preferredFont(forTextStyle: .body))
        for i in buttonsArray{
            i.isEnabled = true
            i.isSelected = false
            
        }
        buttonsArray.removeAll()
        palabraLabel.text = ""
        startGameOutlet.isEnabled = true
    }

}

