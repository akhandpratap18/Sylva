import SwiftUI
import SpriteKit

// Created to make this look more sceneric
// Wrapper View
struct SnowfallView: View {
    var body: some View {
        GeometryReader { geo in
            SpriteView(scene: SnowfallScene(size: geo.size), options: [.allowsTransparency])
                .background(Color.clear)
                .ignoresSafeArea()
        }
    }
}

// Scene Logic
class SnowfallScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        view.allowsTransparency = true
        
        let wait = SKAction.wait(forDuration: 0.15)
        let create = SKAction.run { [weak self] in self?.createSnowflake() }
        let sequence = SKAction.sequence([wait, create])
        
        self.run(SKAction.repeatForever(sequence))
    }
    
    func createSnowflake() {
        let size = CGFloat.random(in: 1.5...4.5)
        let flake = SKShapeNode(circleOfRadius: size)
        
        flake.fillColor = .white
        flake.strokeColor = .clear
        flake.alpha = CGFloat.random(in: 0.4...0.8)
        
        let randomX = CGFloat.random(in: -50...self.size.width + 50)
        flake.position = CGPoint(x: randomX, y: self.size.height + 10)
        addChild(flake)
        
        let duration = Double.random(in: 10...18)
        let moveDown = SKAction.moveTo(y: -50, duration: duration)
        let windDrift = CGFloat.random(in: -60...60)
        let moveSide = SKAction.moveBy(x: windDrift, y: 0, duration: duration)
        
        let group = SKAction.group([moveDown, moveSide])
        
        flake.run(group) {
            flake.removeFromParent()
        }
    }
}
