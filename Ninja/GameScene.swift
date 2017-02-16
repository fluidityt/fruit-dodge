//
//  GameScene.swift
//  Ninja
//
//  Created by Chris Pelling on 02/09/2016.
//  Copyright (c) 2016 Compelling. All rights reserved.
//

import SpriteKit
import GameplayKit


enum PhysicsCategories:UInt32 {
    case character = 0b001
    case enemy = 0b010
    case sidewall = 0b100
    case topwall = 0b1000
    case powerup = 0b10000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:Player! = nil
    var lastUpdateTime:NSTimeInterval = 0.0
    var running = false
    var enemies:[Enemy] = []
    var enemyList:[Enemy] = []
    var spawnRate = 10
    var maxEnemies = 2
    var scoreSinceLastSpawn = 0
    var score:Int = 0 {
        didSet {
            checkUpdateDifficulty()
            scoreNode.text = String(score)
            scoreSinceLastSpawn+=score-oldValue
        }
    }
    
    var menuLayer:SKNode!
    let scoreNode = SKLabelNode(text: "0")

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let shader = SKShader(fileNamed: "bw.fsh")
    
        
        let bgNode = SKSpriteNode(imageNamed: "jungle")
        //bgNode.texture = nil
        //bgNode.shader = shader
        bgNode.size = self.frame.size
  
        
        //print(shader.source)

        addChild(bgNode)
        bgNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bgNode.zPosition = -1
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4.5)
        view.multipleTouchEnabled = true
        spawnCharacter()
        createWalls()
        createScoreBoard()
        loadEnemies()
        
        startGame()
        
    }
    
    func startGame()
    {
        animateGameStart()
    }
    
    
    // Preload enemies so we can just clone from this array.
    func loadEnemies()
    {
        let filename = NSBundle.mainBundle().pathForResource("fruitlist", ofType: "plist")
        if let enemyData = NSArray(contentsOfFile: filename!) as? [[String:AnyObject]] {
            for data in enemyData {
                //print(data["spritePrefix"])
                let fruit = Enemy(withTextureName: data["spritePrefix"] as! String)
                fruit.setScale(data["baseScale"] as! CGFloat)
                fruit.physicsBody?.mass = data["baseMass"] as! CGFloat
                enemyList.append(fruit)
            }
        }
    }
    
    func createWalls()
    {
        let floorHeight = self.frame.size.height/10.0
        let leftWall = SKNode(); let rightWall = SKNode(); let ceiling = SKNode(); let floor = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: CGPoint(x: 0, y: self.frame.height))
        rightWall.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: self.frame.width, y: 0), toPoint: CGPoint(x:self.frame.width, y: self.frame.height))
        floor.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0, y:floorHeight), toPoint: CGPoint(x: self.frame.width, y: floorHeight))
        
        leftWall.physicsBody?.restitution = 0
        rightWall.physicsBody?.restitution = 0
        
        
        leftWall.physicsBody?.categoryBitMask = PhysicsCategories.sidewall.rawValue
        rightWall.physicsBody?.categoryBitMask = PhysicsCategories.sidewall.rawValue
        floor.physicsBody?.categoryBitMask = PhysicsCategories.topwall.rawValue
        
        self.addChild(leftWall); addChild(rightWall); addChild(ceiling); addChild(floor)
        
        
    }
    
    func startTimer()
    {
        let increment = SKAction.afterDelay(0.2, runBlock: {
            self.score += 1
        })
        
        let count = SKAction.repeatActionForever(increment)
        self.runAction(count, withKey: "count")
    }
    
    func stopTimer()
    {
        self.removeActionForKey("count")
    }
    
    
    func createScoreBoard()
    {
        menuLayer = SKNode()
        //let bar = SKSpriteNode(texture: SKTexture(imageNamed:"topbar"), size: CGSize(width: self.frame.size.width, height: self.frame.size.height/10))
        //menuLayer.addChild(bar)
        menuLayer.position = CGPoint(x: self.frame.width/2, y: self.frame.height-size.height/10)

        //let recessNode = SKSpriteNode(texture: SKTexture(imageNamed:"scoreRecess"), size: CGSize(width: bar.size.width/5, height: bar.size.height*0.7))
        //let fontScaleFactor =  min(recessNode.size.width/scoreNode.frame.width, recessNode.size.height/scoreNode.frame.height)*0.8
        //scoreNode.fontSize *= fontScaleFactor
        //bar.addChild(recessNode)
        //recessNode.addChild(scoreNode)
        //scoreNode.position = CGPoint(x: CGRectGetMidX(recessNode.frame)-scoreNode.frame.width/4, y: CGRectGetMidY(recessNode.frame)-scoreNode.frame.height/2)
        scoreNode.fontName = "French_Fries"
        menuLayer.addChild(scoreNode)
        addChild(menuLayer)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == PhysicsCategories.character.rawValue && secondBody.categoryBitMask == PhysicsCategories.enemy.rawValue) {
            if let enemy = secondBody.node as? Enemy {
                enemy.squash()
                //enemies.remove(enemy)
            }
            //endGame()
        }
        
        if (firstBody.categoryBitMask == PhysicsCategories.enemy.rawValue && secondBody.categoryBitMask == PhysicsCategories.topwall.rawValue) {
            if let enemy = firstBody.node as? Enemy {
                enemy.bounce()
            }
        }
        
        if (firstBody.categoryBitMask == PhysicsCategories.character.rawValue && secondBody.categoryBitMask == PhysicsCategories.sidewall.rawValue) {
            if let player = firstBody.node as? Player {
                player.state.enterState(Standing)
            }
        }
        
        if(firstBody.categoryBitMask == PhysicsCategories.character.rawValue && secondBody.categoryBitMask == PhysicsCategories.powerup.rawValue) {
            if let powerUp = secondBody.node as? Powerup {
                powerUp.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
        
            if let node = self.nodeAtPoint(location) as? SKSpriteNode {
                if node.name == "restart" {
                    restart()
                }
            }
        
            let direction = getTouchDirection(touch)
            changeCharacterState(direction)
            
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // There is only one touch registered with this event, so stop moving now it has ended.
        if (event?.allTouches()?.count == 1) {
            player.state.enterState(Standing)
        }
    }
        
    func changeCharacterState(state: GKState.Type) {
        player.state.enterState(state)
    }
    
    
    func getTouchDirection(touch:UITouch) -> GKState.Type
    {
        let location = touch.locationInNode(self)
        
        if (location.x < CGRectGetMidX(self.frame)) {
            return RunLeft.self
        } else {
            return RunRight.self
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var timeSinceLast = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0/60.0
        }
        

        if (running) {
            
            self.enumerateChildNodesWithName("powerup", usingBlock: { node, stop in
                if let powerup = node as? Powerup {
                    powerup.state?.updateWithDeltaTime(timeSinceLast)
                }
            })
            
            updateEnemies()
            if (shouldSpawnEnemy()) {
                self.spawnDanger()
                scoreSinceLastSpawn = 0
            }
            
            if (shouldSpawnStar() ) {
                self.spawnStar()
                //print("Spawning star at score \(score)")
            }
        }
    }
    
    func shouldSpawnStar() -> Bool
    {
        if (score % 40 == 0) {
            return true
        }
        
        return false
    }
    
    func updateEnemies()
    {
        for (index, enemySprite) in enemies.enumerate() {
            if enemySprite.position.x - enemySprite.size.width/2 > self.frame.size.width && self.running {
                enemySprite.removeFromParent()
                enemies.removeAtIndex(index)
            }
            
            enemySprite.physicsBody?.angularVelocity = -7.0
        }
    }
    
    
    func spawnDanger()
    {
        var enemySprite:Enemy
        let lastSpawn = enemies.last?.textureName
        
        repeat {
             enemySprite = enemyList.randomItem().clone()
        } while (enemySprite.textureName == lastSpawn)
        
        
        let spawnHeight = CGFloat.random(min: self.frame.height*0.66, max: self.frame.height - enemySprite.frame.size.height)
        let minSpeed = enemySprite.physicsBody!.mass * 100
        let moveSpeed = CGFloat.random(min: minSpeed, max: minSpeed*2.5)
        enemySprite.position = CGPoint(x:0, y: spawnHeight)
        addChild(enemySprite)
        enemySprite.physicsBody?.applyImpulse(CGVector(dx:moveSpeed, dy:0))
        enemies.append(enemySprite)
    }
    
    
    func spawnCharacter()
    {
        player = Player()
        player.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height/10.0+player.frame.size.height/2)
        player.state.enterState(Standing)

        self.addChild(player)
    }
    
    
    
    func spawnStar()
    {
        /*let sprite = SKShapeNode(circleOfRadius: 10.0)
        sprite.fillColor = SKColor.yellowColor()*/
        
        let star = Powerup(withType: "star")
        
        let xPos = CGFloat.random(min: 0, max: self.frame.width)
        
        let position = CGPoint(x: xPos, y: self.frame.height + star.frame.height)
        
        star.position = position
        star.scaleAsSize = CGSize(width: 20, height: 25)
        
    
        addChild(star)
        star.state?.enterState(Collectible)
    }
    
    func killCharacter()
    {
        player.state.enterState(Defeated)
    }
    
    func endGame()
    {
        killCharacter()
        stopTimer()
        running = false
        let restartNode = SKSpriteNode(imageNamed: "restart")
        restartNode.zPosition = 1000
        restartNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        restartNode.name = "restart"
        addChild(restartNode)
    }
    
    func restart()
    {
        self.removeAllChildren()
        let scene = GameScene(size: self.size)
        scene.scaleMode = self.scaleMode
        self.view?.presentScene(scene)
    }
    
    func shouldSpawnEnemy() -> Bool
    {
        // Always spawn if there are no enemies at all.
        if (enemies.count < 1) {
            return true;
    
        } else if (enemies.count < maxEnemies) {
            if (scoreSinceLastSpawn > spawnRate) {
                return true
            }
        }
        
        return false
    }
    
    func checkUpdateDifficulty()
    {
        if (score % 60 == 0 && spawnRate > 0) {
            spawnRate-=1
        }
        if (score % 100 == 0 && spawnRate < 10) {
            maxEnemies+=1
        }
    }
    
    
    func animateGameStart()
    {
        let countDownTimer = CountdownNode(size: self.size, count: 3, delay: 0.75, bgColor: UIColor.blackColor())
        countDownTimer.alpha = 0.5
        countDownTimer.finalText = "GO!"
        countDownTimer.initialText = "READY?"
        addChild(countDownTimer)
        countDownTimer.start() {
            self.running = true
            self.startTimer()
        }
    }

}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension CGRect {
    func getMidPoint() -> CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

