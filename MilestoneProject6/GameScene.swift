
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var gameTimer: Timer?
    let possibleEnemies = ["target", "mallard1", "mallard2", "duck"]
    var interval = 1.0
    var enemyCount = 0 {
        didSet {
            if enemyCount % 20 == 0 && interval > 0.1 {
//                interval -= 0.1
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: interval,
                                                 target: self,
                                                 selector: #selector(createTarget),
                                                 userInfo: nil,
                                                 repeats: true)
            }
        }
    }
        
    override func didMove(to view: SKView) {
        
        physicsBody = nil
        
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        background.name = "wood-background"
        background.physicsBody = nil
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: interval,
                                         target: self,
                                         selector: #selector(createTarget),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func createTarget() {
        guard let targetImageName = possibleEnemies.randomElement() else { return }
        let targetSprite = TargetSpriteNode(imageNamed: targetImageName)
        targetSprite.setup(imageNamed: targetImageName)
        addChild(targetSprite)
        enemyCount += 1
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let body = physicsWorld.body(at: pos) {
            if let node = body.node as? TargetSpriteNode  {
                score += 1
                print("HIT \(node.name!)")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let touchedNodes = nodes(at: location).filter { $0.name?.starts(with: "target") ?? false }

        var z: CGFloat = -1
        var touched: SKNode?
        physicsWorld.enumerateBodies(at: location) { body,_ in
            if let node = body.node {
                if node.zPosition > z {
                    z = node.zPosition
                    touched = node
                }
            }
        }
        if let touched = touched as? TargetSpriteNode {
            print(touched.name!)
            touched.hit()
        }

        print(touchedNodes.count)
        print("--------------------")
        score += 1
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location = touch.location(in: self)
//
//            let hitNodes = nodes(at: location).filter { $0.name == "target" }
//
//            guard let hitNode = hitNodes.first else { return }
////            guard let parentNode = hitNode.parent as? Target else { return }
//
////            parentNode.hit()
//            print(hitNode)
//            score += 1
//        }
//    }
}
