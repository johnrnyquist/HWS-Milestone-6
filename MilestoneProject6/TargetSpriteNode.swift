
import SpriteKit

class TargetSpriteNode: SKSpriteNode {
    
    static var count = 0
    
    func setup(imageNamed: String) {
        
        TargetSpriteNode.count += 1
                
        let row = [200, 400, 600].randomElement()!
        let dir = [-1, 1].randomElement()!

        zPosition = CGFloat(TargetSpriteNode.count)
        position = CGPoint(x: -600 * dir + 600, y: row)
        name = "target \(imageNamed) \(TargetSpriteNode.count)"

        physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.9,  size: texture!.size())
        alpha = 1
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: 10 * dir, dy: 0)
        physicsBody?.angularVelocity = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
    }
}
