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

class GameScene: SKScene {
    
    // MARK: Properties
    
    var playableRect:CGRect
    var player:Player! = nil
    var lastUpdateTime:TimeInterval = 0.0
    var running = false
    var enemies:[Enemy] {
        return children.filter({$0.name == "enemy"}) as! [Enemy]
    }
    var enemyList:[Enemy] = []
    var spawnRate = 15
    var maxEnemies = 2
    var scoreSinceLastSpawn = 0
    var score:Int = 0 {
        didSet {
            doScoreChecks()
            scoreNode.setScore(score: score)
            scoreSinceLastSpawn+=score-oldValue
        }
    }
    
    var starScore:Int = 0 {
        didSet {
            if let scoreNode = menuLayer.childNode(withName: "starscore") as? SKLabelNode {
                scoreNode.text = String(starScore)
            }
        }
    }
    
    var menuLayer:SKNode!
    let scoreNode = ScoreNode(imageNamed: "star_icon")
    let starNode = ScoreNode(imageNamed: "star_icon")
    var dismiss:(()->())?
    
    //MARK: Init
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        let bgNode = SKSpriteNode(imageNamed: "bg")
        bgNode.size = self.frame.size
  

        addChild(bgNode)
        bgNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgNode.zPosition = -1
        self.physicsWorld.contactDelegate = self
        
        view.isMultipleTouchEnabled = true
        spawnCharacter()
        createWalls()
        createScoreBoard()
        loadEnemies()
        
        startGame()
        //debugDrawPlayableArea()
        
        let lightningNode = LightningNode(size: CGSize(width: 1, height:1))
        
        lightningNode.zPosition = 500000
        
        lightningNode.position = CGPoint(x: self.frame.midX, y: self.frame.height)
        lightningNode.name = "lightning"
        
        
        addChild(lightningNode)
        
    }
    
    /*
     * Taken from Ray Wenderlich p73
    */
    override init(size: CGSize)
    {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func debugDrawPlayableArea()
    {
        let shape = SKShapeNode()
        let path = CGMutablePath()

        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func startGame()
    {
        animateGameStart()
    }
    
    func pauseGame()
    {
        self.running = !self.running
        self.isPaused = !self.isPaused
    }
    
    //MARK: Preloading and setup
    
    // Preload enemies so we can just clone from this array.
    func loadEnemies()
    {
        print("preloading enemies")
        let filename = Bundle.main.path(forResource: "fruitlist", ofType: "plist")
        if let enemyData = NSArray(contentsOfFile: filename!) as? [[String:AnyObject]] {
            for data in enemyData {
                let fruit = Enemy(withTextureName: data["spritePrefix"] as! String)
                let baseScale = (data["baseScale"] as! CGFloat)
                fruit.setScale(2.0*baseScale)
                fruit.physicsBody?.mass = data["baseMass"] as! CGFloat
                enemyList.append(fruit)
            }
        }
    }
    
    func createWalls()
    {
        let floorHeight:CGFloat = 270.0
        let leftWall = SKNode(); let rightWall = SKNode(); let ceiling = SKNode(); let floor = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint.zero, to: CGPoint(x: 0, y: self.frame.height))
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: self.frame.width, y: 0), to: CGPoint(x:self.frame.width, y: self.frame.height))
        floor.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y:floorHeight), to: CGPoint(x: self.frame.width, y: floorHeight))
        
        leftWall.physicsBody?.restitution = 0
        rightWall.physicsBody?.restitution = 0
        
        
        leftWall.physicsBody?.categoryBitMask = PhysicsCategories.sidewall.rawValue
        rightWall.physicsBody?.categoryBitMask = PhysicsCategories.sidewall.rawValue
        floor.physicsBody?.categoryBitMask = PhysicsCategories.topwall.rawValue
        
        self.addChild(leftWall); addChild(rightWall); addChild(ceiling); addChild(floor)
    }
    
    func animateGameStart()
    {
        let countDownTimer = CountdownNode(size: self.size, count: 3, delay: 0.75, bgColor: UIColor.black)
        countDownTimer.alpha = 0.5
        countDownTimer.finalText = "GO!"
        countDownTimer.initialText = "READY?"
        addChild(countDownTimer)
        countDownTimer.start() {
            self.running = true
            self.startTimer()
        }
    }
    
    func startTimer()
    {
        let increment = SKAction.afterDelay(0.2, runBlock: {
            self.score += 1
        })
        
        let count = SKAction.repeatForever(increment)
        self.run(count, withKey: "count")
    }
    
    func stopTimer()
    {
        self.removeAction(forKey: "count")
    }
    
    
    func createScoreBoard()
    {
        let convertedPoint = convertPoint(fromView: CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.height/11))
        
        menuLayer = SKNode()
        menuLayer.position = convertedPoint
        
        
        menuLayer.addChild(scoreNode)
    
        starNode.position = CGPoint(x: -self.frame.width/3, y: 0)
        menuLayer.addChild(starNode)
        
        let pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.name = "pause"
        pauseNode.position = CGPoint(x: self.frame.width/3, y:0)
        pauseNode.setScale(0.5)
        menuLayer.addChild(pauseNode)
        
        addChild(menuLayer)
    }
    
    
    // MARK: Touches

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKSpriteNode {
                
                if node.name == "restart" {
                    restart()
                }
                
                if node.name == "home" {
                    self.dismiss!()
                }
                
                if node.name == "pause" {
                    self.running = !self.running
                    self.isPaused = !self.isPaused
                }
            }
        
            if (running) {
                let direction = getTouchDirection(touch)
                changeCharacterState(direction)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // There is only one touch registered with this event, so stop moving now it has ended.
        if (event?.allTouches?.count == 1) {
            player.state.enter(Standing.self)
        }
    }
    
    
    func getTouchDirection(_ touch:UITouch) -> GKState.Type
    {
        let location = touch.location(in: self)
        
        if (location.x < self.frame.midX) {
            return RunLeft.self
        } else {
            return RunRight.self
        }
    }
    
    func changeCharacterState(_ state: GKState.Type) {
        player.state.enter(state)
    }
    
    

    // MARK: Game loop and update logic
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        var timeSinceLast = currentTime - lastUpdateTime
        self.lastUpdateTime = currentTime
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0/60.0
        }
        

        if (running) {
            updateEnemies(timeSinceLast)
            
            if (shouldSpawnEnemy()) {
                self.spawnDanger(fromSide: .Left)
                scoreSinceLastSpawn = 0
            }
            
        }
        
        self.enumerateChildNodes(withName: "powerup", using: { node, stop in
            if let powerup = node as? Powerup {
                powerup.state?.update(deltaTime: timeSinceLast)
            }
        })
    }

    
    func shouldSpawnPowerup() -> [String]
    {
        var toSpawn = [String]()
        
        if (score % 10 == 0) {
            toSpawn.append("star")
        }
        
        if (score % 100 == 0) {
            toSpawn.append("lightning")
        }
        
        return toSpawn
    }
    
    
    func updateEnemies(_ delta:TimeInterval)
    {
        for enemySprite in enemies {
            enemySprite.stateMachine.update(deltaTime: delta)
        }
    }
    
    
    func spawnDanger(fromSide side:EnemyDirection = .Left)
    {
        var enemySprite:Enemy
        
        struct enemyData {
            static var lastSpawn = ""
        }
        
        repeat {
             enemySprite = enemyList.randomItem().clone()
        } while (enemySprite.textureName == enemyData.lastSpawn)
        
        enemyData.lastSpawn = enemySprite.textureName
        
        let spawnHeight = CGFloat.random(min: self.frame.height*0.66, max: self.frame.height - enemySprite.frame.size.height)
        let minSpeed = enemySprite.physicsBody!.mass * 100
        var moveSpeed = CGFloat.random(min: minSpeed, max: minSpeed*2.5)
        var xPos:CGFloat
        
        switch side {
        case .Left:
            xPos = 0.0
            enemySprite.stateMachine.enter(BouncingRight.self)
        case .Right:
            xPos = self.frame.width
            moveSpeed = -moveSpeed
            enemySprite.stateMachine.enter(BouncingLeft.self)
            
        }
        
        enemySprite.position = CGPoint(x:xPos, y: spawnHeight)
        addChild(enemySprite)
        enemySprite.physicsBody?.applyImpulse(CGVector(dx:moveSpeed, dy:0))
    }
    
    
    func spawnCharacter()
    {
        player = Player()

        player.state.enter(Standing.self)

        self.addChild(player)
        
        player.position = CGPoint(x: self.frame.midX, y: 270 + player.frame.size.height/2)
    }
    
    
    
    func spawnPowerup(_ ofType:String)
    {
        guard let powerup = PowerupFactory.createPowerupOfType(ofType) else {
            return
        }
        
        powerup.delegate = self
        
        var xPos:CGFloat
        
        // Randomly generate x value for powerup until we're sure it will not overlap one that already exists.
        repeat {
            xPos = CGFloat.random(min: 0, max: self.frame.width)
        }
        while (
        self.atPoint(CGPoint(x: xPos, y: 331)) is Powerup
            || self.atPoint(CGPoint(x: xPos-powerup.size.width/2, y: 331)) is Powerup
            || self.atPoint(CGPoint(x: xPos+powerup.size.width/2, y: 331)) is Powerup
        )
        

        let position = CGPoint(x: xPos, y: self.frame.height + powerup.frame.height)
        
        powerup.position = position
        addChild(powerup)
        powerup.state?.enter(Collectible.self)
    }
    
    func doScoreChecks()
    {
        checkUpdateDifficulty()
        
        let powerups = shouldSpawnPowerup()
        
        for powerupName in powerups {
            spawnPowerup(powerupName)
        }
        
    }

    
    func endGame()
    {
        if (!running) {
            return
        }
        
        player.kill()
        stopTimer()
        running = false
        let restartNode = SKSpriteNode(imageNamed: "restart")
        let homeNode = SKSpriteNode(imageNamed: "home")
        let highScore = UserDefaults.standard.integer(forKey: "highscore")
        
        let gameoverNode = SKNode()
        gameoverNode.zPosition = 10000
        gameoverNode.name = "gameOver"
        
        let bgNode = SKSpriteNode(imageNamed: "window_shop.png")
        
        let end = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // Make sure the node is positioned before you create the move effect, or it won't work!
        gameoverNode.position =  CGPoint(x: self.frame.getMidPoint().x, y: self.frame.height+bgNode.frame.height)
        
        let effect = SKTMoveEffect(node: gameoverNode, duration: 0.7, startPosition: gameoverNode.position, endPosition: end)
        
        let move = SKAction.actionWithEffect(effect)
        effect.timingFunction = SKTTimingFunctionBounceEaseOut
        
        restartNode.scaleAsSize = CGSize(width: 300, height: 300)
        restartNode.name = "restart"
        restartNode.zPosition = bgNode.zPosition+1
        restartNode.position = CGPoint(x: 300, y: -300)
        
        homeNode.scaleAsSize = CGSize(width: 300, height: 300)
        homeNode.name = "home"
        homeNode.zPosition = bgNode.zPosition+1
        homeNode.position = CGPoint(x: -300, y: -300)
        

        let scoreTexture = SKTexture(imageNamed: "bg_friends_score.png")
        
        let starsBox = SKSpriteNode(texture: scoreTexture, color: UIColor.clear, size: CGSize(width: bgNode.size.width/2, height: scoreTexture.size().height))
        //let star = SKSpriteNode(imageNamed: "newstar")
        
        starsBox.zPosition = gameoverNode.zPosition+1
        starsBox.position = CGPoint(x: 0, y: 200)
        //star.position = CGPoint(x:-100, y:0)
        
        
        let scoreBox = starsBox.copy() as! SKSpriteNode
        scoreBox.position = CGPoint(x: 0, y: 0)
        

        let starsScore = ScoreNode(imageNamed: "newstar")
        let scoreScore = ScoreNode(imageNamed: "newstar")
        starsScore.zPosition = starsBox.zPosition+1
        scoreScore.zPosition = scoreBox.zPosition+1
        
        starsBox.addChild(starsScore)
        scoreBox.addChild(scoreScore)
        
        gameoverNode.addChild(starsBox)
        gameoverNode.addChild(scoreBox)
        
        gameoverNode.addChild(bgNode)
        bgNode.addChild(restartNode)
        bgNode.addChild(homeNode)
        
        // Present scoreboard
        addChild(gameoverNode)
        
        
        // Increment scorecounters
        let wait = SKAction.wait(forDuration: 0.01)
        
        // Move these to the node objects themselves.
        let updateStarScore = SKAction.repeat(SKAction.sequence([wait, starsScore.increment()]), count: starScore)
        let updateTimeScore = SKAction.repeat(SKAction.sequence([wait, scoreScore.increment()]), count: score)
        
        let scoreUpdatesAction = SKAction.group([updateStarScore, updateTimeScore])
        gameoverNode.run(SKAction.sequence([SKAction.wait(forDuration:0.5), move, SKAction.wait(forDuration:0.5), scoreUpdatesAction]))
        
        
        if starScore > highScore {
            UserDefaults.standard.set(starScore, forKey: "highscore")
        }
        
    }
    
    func restart()
    {
        if let gameoverNode = self.childNode(withName: "gameOver") {
            print(gameoverNode.position)
            let effect = SKTMoveEffect(node: gameoverNode, duration: 0.7, startPosition: gameoverNode.position, endPosition: CGPoint(x: self.frame.width+gameoverNode.calculateAccumulatedFrame().width/2, y:self.frame.midY))
            
            effect.timingFunction = SKTTimingFunctionBackEaseIn
            let move = SKAction.actionWithEffect(effect)
            
            gameoverNode.run(move) {
                self.removeAllChildren()
                let scene = GameScene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene)
            }
        } else {
            self.removeAllChildren()
            let scene = GameScene(size: self.size)
            scene.scaleMode = self.scaleMode
            self.view?.presentScene(scene)
        }

    }
    
    func shouldSpawnEnemy() -> Bool
    {
        //let enemies =
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
    
    
    /*
    /   main algorithm for determining difficulty
    /
    */
    func checkUpdateDifficulty()
    {
        if (score % 100 == 0 && spawnRate > 0) {
            spawnRate-=1
        }
        if (score % 150 == 0 && spawnRate < 12) {
            maxEnemies+=1
        }
    }
    
    func checkEnemyHit(_ enemy: Enemy)
    {
        if (!player.invincible) {
            enemy.stateMachine.enter(Squashed.self)
            endGame()
        }
    }
    

}

// MARK: Powerup Delegate

extension GameScene: Powerupable
{
    func didExecutePowerup(_ powerup: Powerup) {
        
        switch(powerup) {
        case is Star:
            self.starScore+=1
        case is Lightning:
            destroyEnemies(withLightning: true)
        default:
            return
        }
    }
    
    
    func didFinishExecutingPower(_ powerup: Powerup) {
        
    }
    
    func destroyEnemies(withLightning:Bool)
    {
        if (withLightning) {
        
            if let node = self.childNode(withName: "lightning") as? LightningNode {
                node.targetPoints.removeAll(keepingCapacity: false)
                node.startLightning()
                
                let switchOffLightning = SKAction.run({ () in
                    node.stopLightning()
                })
                
                node.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), switchOffLightning]))
            }
        }
        
        
        for enemySprite in enemies {
            
            let velocity = CGPoint(vector: enemySprite.physicsBody!.velocity)
            
            enemySprite.physicsBody = nil
            
            if let node = self.childNode(withName: "lightning") as? LightningNode {
                node.targetPoints.append(node.convert(enemySprite.position, from: self))
            }
            
            let pop = SKAction.group([SKAction.screenShakeWithNode(enemySprite, amount:velocity/30, oscillations: 10, duration: 1.0)])
            
            let removeAction = SKAction.sequence([pop, SKAction.run({ enemySprite.stateMachine.enter(Squashed.self) })])
            enemySprite.run(removeAction)
        }

    }
}

// MARK: Physics Delegate

extension GameScene: SKPhysicsContactDelegate
{
    func didBegin(_ contact: SKPhysicsContact) {
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
                checkEnemyHit(enemy)
            }
        }
        
        if (firstBody.categoryBitMask == PhysicsCategories.enemy.rawValue && secondBody.categoryBitMask == PhysicsCategories.topwall.rawValue) {
            if let enemy = firstBody.node as? Enemy {
                enemy.bounce()
            }
        }
        
        if (firstBody.categoryBitMask == PhysicsCategories.character.rawValue && secondBody.categoryBitMask == PhysicsCategories.sidewall.rawValue) {
            if let player = firstBody.node as? Player {
                player.state.enter(Standing.self)
            }
        }
        
        if(firstBody.categoryBitMask == PhysicsCategories.character.rawValue && secondBody.categoryBitMask == PhysicsCategories.powerup.rawValue) {
            if let powerUp = secondBody.node as? Powerup {
                powerUp.state?.enter(Collected.self)
            }
        }
    }
    

}


