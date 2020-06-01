//
//  GameModel.swift
//  Tilty
//

// Jack Joliet (jrjoliet@iu.edu) • Gavin Steever (ggsteeve@iu.edu) Tilty Jack Johnson (jj266@iu.edu) • Darsh Selarka (dselarka@iu.edu) (5/02/20)



import Foundation

class GameModel {
    var points = 0
    var target: Int
    var highscores:[Int]
    
    func saveData(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let file = path.appendingPathComponent("High_Scores.plist")
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: highscores, requiringSecureCoding: false)
            try data.write(to: file)
        }
        catch{
            fatalError("Cannot encode")
        }
        
    }
    
    func loadData(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let file = path.appendingPathComponent("High_Scores.plist")
        do{
            let data = try Data(contentsOf: file)
            if let vals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Int]{
                highscores = vals
            }
        }
        catch{
            print("Cannot unarchive")
        }
            
    }
    
    init() {
        self.target = Int(arc4random_uniform(3) + 0)
        self.highscores = []
    }
    
    func isInSquare(square: Int) -> Bool {
        if(square == target) {
            return true
        } else {
            return false
        }
    }
    
    func addPoint() -> Int {
        self.points += 1
        let newTarget = getNewTarget()
        self.target = newTarget
        return newTarget
    }
    
    func getNewTarget() -> Int {
        let newTarget = Int(arc4random_uniform(3) + 0)
        if(newTarget == self.target) {return getNewTarget()} else {return newTarget}
    }
    
    func gameOver() {
        self.highscores.append(self.points)
        saveData()
        print("The High Scores are \(self.highscores)")
    }
}
