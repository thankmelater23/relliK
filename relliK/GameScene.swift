//
//  GameScene.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright (c) 2015 Bang Bang Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate {
    //Unassigned
    var isGamePaused: Bool = false
    
    //Array of Monstors and Bullets
    var monstorsInField = [Enemy]()
    var bulletsInField = [Bullet]()
    
    //Sprite Objects
    var player: Player!
    var isShootable:Bool = false
    
    //Background
    var backgroundNode: SKSpriteNode!
    
    //Blocks
    var playerBlock: SKSpriteNode!
    var leftBoxes: [SKSpriteNode]! = []
    var rightBoxes: [SKSpriteNode]! = []
    var upBoxes: [SKSpriteNode]! = []
    var downBoxes: [SKSpriteNode]! = []
    
    //Light Nodes
    var leftLight = SKLightNode()
    var rightLight = SKLightNode()
    var upLight = SKLightNode()
    var downLight = SKLightNode()
    
    //Game Time
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var incrementCurrentGameSpeedTime: NSTimeInterval = 0
    var incrementGameSpeedTime: NSTimeInterval = GAME_MIN_SPEED * 5
    
    //Position and Moving Values
    let movePointsPerSec: CGFloat = 480.0
    var velocity = CGPointZero
    
    //Location and sizes
    let playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let rotateRadiansPerSec:CGFloat = 4.0 * π
    var pointBetweenBlocks = CGFloat(spaceBetweenEnemyBlock)
    var shotStart = 50//No use right now 9-10-15
    let horizontalXAxis :CGFloat
    let verticalAxis :CGFloat
    
    //Enemy Spawn positions
    var leftSideEnemyStartPosition: CGPoint
    var rightSideEnemyStartPosition: CGPoint
    var upSideEnemyStartPosition: CGPoint
    var downSideEnemyStartPosition: CGPoint
    
    
    //Actions
    //var moveUp : SKAction!
    //Move bullets actions to bullet
    var bulletMoveRightAction: SKAction!
    var bulletMoveLeftAction: SKAction!
    var bulletMoveDownAction: SKAction!
    var bulletMoveUpAction: SKAction!
    
    func gameOver(){
        if(player.isDead || errors >= 5){
            exit(EXIT_SUCCESS)
        }
    }
    
    func loadDefaults(){
        let gameHighScore = NSUserDefaults.standardUserDefaults().valueForKey("highscore") as! Int?
        guard let defaultHighScore = gameHighScore else {
            NSUserDefaults.standardUserDefaults().setValue(0, forKeyPath: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            return
        }
        
        highscores = NSUserDefaults.standardUserDefaults().valueForKey("highscore") as! Int!
    }
    
    //Game Labels
    
    
    var scoreBoardLabel = SKLabelNode()
    var score:Int = 0 {
        willSet{
            scoreBoardLabel.text = String("Score: \(newValue)")
            scoreBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
                SKAction.scaleTo(1, duration: 0.1)]))
            
            if newValue > highscores{
                
                let defaults = NSUserDefaults.standardUserDefaults().valueForKey("highscore") as! Int
                if(newValue > defaults){
                    NSUserDefaults.standardUserDefaults().setValue(highscores, forKey: "highscore")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    highscores = newValue
                }
            }
        }
    }
    var killBoardLabel = SKLabelNode()
    var killed:Int = 0 {
        willSet{
            killBoardLabel.text = String("Killed: \(newValue)")
            killBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
                SKAction.scaleTo(1, duration: 0.1)]))
        }
    }
    
    var errorsBoardLabel = SKLabelNode()
    var errors:Int = 0 {
        willSet{
            errorsBoardLabel.text = String("Errors: \(newValue)")
            errorsBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
                SKAction.scaleTo(1, duration: 0.1)]))
        }
    }
    
    var highScoreBoardLabel = SKLabelNode()
    var highscores:Int = 0 {
        willSet{
            highScoreBoardLabel.text = String("High Score: \(newValue)")
            highScoreBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
                SKAction.scaleTo(1, duration: 0.1)]))
        }
    }
    
    var timerBoardLabel = SKLabelNode()
    var gameMiliSecToSec = NSTimeInterval(0.0)
    var gameTimer:Int = 0 {
        willSet{
            timerBoardLabel.text = convertGameTimer(newValue)
            timerBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
                SKAction.scaleTo(1, duration: 0.1)]))
        }
    }
    
   
    var waitTimeBoardLabel = SKLabelNode()
    var gameSpeedBoardLabel = SKLabelNode()
    
    
    func setGameTimeLabel(){
        
        waitTimeBoardLabel.text = String("Game Speed: \(gameSpeed)")
        //waitTimeBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
          //  SKAction.scaleTo(1, duration: 0.1)]))
    }
    
    func setWaitTimeLabel(){
        
        gameSpeedBoardLabel.text = String("Wait Time: \(enemyWaitTime)")
       // gameSpeedBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
           // SKAction.scaleTo(1, duration: 0.1)]))
    }

    func convertGameTimer(timeToConvert: Int)-> String{
        var total = 0
        var min = 0
        var sec = 0
        
        for _ in 0..<timeToConvert{
            total++
            if total == 60{
                total = 0
                min++
            }
        }
        sec = total
        return String("\(min):\(sec)")
     }
    
    func paused(){
        !isGamePaused
    }
    
    
    func setGameLights(){
        rightLight.position = CGPoint(x: 0.5, y: 0.5)
        leftLight.position = CGPoint(x: 0.5, y: 0.5)
        upLight.position = CGPoint(x: 0.5, y: 0.5)
        downLight.position = CGPoint(x: 0.5, y: 0.5)
        
        rightLight.categoryBitMask = BitMaskOfLighting.right
        leftLight.categoryBitMask = BitMaskOfLighting.left
        upLight.categoryBitMask = BitMaskOfLighting.up
        downLight.categoryBitMask = BitMaskOfLighting.down
        
        addChild(rightLight)
        addChild(leftLight)
        addChild(upLight)
        addChild(downLight)
    }
    
    
    //Update Methods
    override func update(currentTime: NSTimeInterval) {
        
        if !isGamePaused{
            if incrementCurrentGameSpeedTime > incrementGameSpeedTime {
                print("Update game speed")
                
                //                if gameSpeed < GAME_MIN_SPEED * 0.75{
                //                    enemyWaitTime -= enemyWaitIncrementalSpeed
                //                    if enemyWaitTime < enemyWaitMaxSpeed{
                //                        enemyW aitTime = enemyWaitMaxSpeed
                //                    }
                //                    print("decrease wait time")
                //                }
                //                if gameSpeed < GAME_MIN_SPEED * 0.25{
                //                    enemyWaitTime += enemyWaitIncrementalSpeed
                //                    if enemyWaitTime > enemyWaitMinSpeed{
                //                        enemyWaitTime = enemyWaitMinSpeed
                //                    }
                //                    print("increase wait time")
                //                }
                
                enemyWaitTime -= enemyWaitIncrementalSpeed
                
                if enemyWaitTime > enemyWaitMinSpeed{
                    enemyWaitTime = enemyWaitMinSpeed
                }
                if enemyWaitTime < enemyWaitMaxSpeed{
                    enemyWaitTime = enemyWaitMaxSpeed
                }
                
                if gameSpeed <= GAME_MAX_SPEED{
                    print("Current gamespeed under min: \(gameSpeed)")
                    gameSpeed = GAME_MAX_SPEED
                    enemyWaitTime == NSTimeInterval(0.4)
                    print("Current gameSpeedChanged to: \(gameSpeed)")
                }else{//Decrese gameSpeed
                    gameSpeed -= gameIncrementalSpeed
                }
//                if gameSpeed > GAME_MIN_SPEED{
//                    print("Current gameSpeed over max: \(gameSpeed)")
//                    gameSpeed = GAME_MIN_SPEED
//                    print("Current gameSpeedChanged: \(gameSpeed)")
//                }
                
                self.setWaitTimeLabel()
                self.setGameTimeLabel()
                
                incrementCurrentGameSpeedTime = 0
                
                print("Current gameSpeed: \(gameSpeed)")
            }else{
                incrementCurrentGameSpeedTime += currentTime - lastUpdateTime
            }
            
            
            if dt >= gameSpeed + enemyWaitTime{
                print("game total Speed: \(gameSpeed + enemyWaitTime)")
                dt = 0
                spawnEnemy()
                moveEnemies()
                print("Spawn and move time")
            }
            
            if lastUpdateTime > 0 {
                dt += currentTime - lastUpdateTime
            } else {
                dt = 0
            }
            
            if bulletCurrentCoolDownTime > bulletCoolDownTime{
                isShootable = true
                bulletCurrentCoolDownTime = 0.0
                lastShot = currentTime
            }else{
                bulletCurrentCoolDownTime += (currentTime - lastShot)
                lastShot = currentTime
            }
            
            
            
            if gameMiliSecToSec >= NSTimeInterval(1.0){
                gameTimer++
                gameMiliSecToSec = 0
            }else{
                gameMiliSecToSec += currentTime - lastUpdateTime
            }
            
            moveBullets()
            gameOver()
            lastUpdateTime = currentTime
        }
    }
    
    //Initialization methods
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 71.0/40.0 // iPhone 5"
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let maxAspectRationWidth = size.height / maxAspectRatio
        let playableMargin = (size.height-maxAspectRatioHeight)/2.0
        let playableMarginWidth = (size.width - maxAspectRationWidth) / 2.0
        playableRect =        CGRect(x: 0, y: playableMargin, width: size.width - playableMarginWidth * 2, height: size.height-playableMargin*2)
        
        leftSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect) -  (spaceBetweenEnemyBlock + spaceToLastBox), y: CGRectGetMidY(playableRect))
        rightSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect) + (spaceBetweenEnemyBlock + spaceToLastBox), y: CGRectGetMidY(playableRect))
        upSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect) + (spaceBetweenEnemyBlock + spaceToLastBox))
        downSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect) - (spaceBetweenEnemyBlock + spaceToLastBox))
        
        horizontalXAxis = CGRectGetMidX(playableRect)
        verticalAxis = CGRectGetMidY(playableRect)
        
        super.init(size: playableRect.size)
    }
    override func didMoveToView(view: SKView) {
        setPhysics()
        setGameLights()
        setLabels()
        createActions()
        particleCreator()
        createPlayer()
        createBlocks()
        debugDrawPlayableArea()
        createSwipeRecognizers()
        loadDefaults()
        playGameBackgroundMusic()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Contact Methods
    func setPhysics(){
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(CGFloat(0), CGFloat(0))
    }
    func didBeginContact(contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node as! Entity
        let secondNode = contact.bodyB.node as! Entity
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Player) &&
            (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy){
                firstNode.hurt()
                secondNode.kill()
        }
        
        if (contact.bodyB.categoryBitMask == PhysicsCategory.Player) &&
            (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy){
                secondNode.hurt()
                firstNode.kill()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) &&
            (contact.bodyB.categoryBitMask == PhysicsCategory.Bullet){
                firstNode as! Enemy
                
                //                if firstNode.name == "ghost" && !(firstNode.isBlockPlaceMoreThanRange()){
                //
                //                }else{
                secondNode.removeActionForKey("move")
                secondNode.kill()
                firstNode.hurt()
                
                if firstNode.isDead{
                    self.upScore(firstNode.sumForScore())
                    self.upKilledEnemy()
                    //                    }
                }
        }
        
        if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) &&
            (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet){
                secondNode as! Enemy
                //                if secondNode.name == "ghost" && !(secondNode.isBlockPlaceMoreThanRange()){
                //
                //                }else{
                firstNode.removeActionForKey("move")
                firstNode.kill()
                secondNode.hurt()
                
                if secondNode.isDead{
                    self.upScore(secondNode.sumForScore())
                    self.upKilledEnemy()
                    //                    }
                }
        }
    }
    
    //UI Methods
    func setLabels(){
        backgroundNode = SKSpriteNode(imageNamed: "appleSpaceBackground")
        backgroundNode.size = playableRect.size
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode.position = CGPoint(x: playableRect.width/2, y: playableRect.height/2)
        backgroundNode.zPosition = -1
        
        
        scoreBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreBoardLabel.name = "scoreBoard"
        score = 0
        scoreBoardLabel.text = String("Score: \(score)")
        scoreBoardLabel.color = SKColor.redColor()
        scoreBoardLabel.fontSize = 15
        scoreBoardLabel.position =  CGPoint(x: horizontalXAxis * 2, y: verticalAxis * 1.8)
        scoreBoardLabel.zPosition = 100
        scoreBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        highScoreBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        highScoreBoardLabel.name = "highscoreBoard"
        highscores = 0
        highScoreBoardLabel.text = String("HighScore: \(highscores)")
        highScoreBoardLabel.color = SKColor.redColor()
        highScoreBoardLabel.fontSize = 15
        highScoreBoardLabel.position = CGPoint(x: horizontalXAxis * 2, y: verticalAxis * 0.8)
        highScoreBoardLabel.zPosition = 100
        highScoreBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        highScoreBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        killBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        killBoardLabel.name = "killBoard"
        killed = 0
        killBoardLabel.text = String("Killed: \(killed)")
        killBoardLabel.color = SKColor.redColor()
        killBoardLabel.fontSize = 15
        killBoardLabel.position = CGPoint(x: horizontalXAxis * 0.10, y: verticalAxis * 1.8)
        killBoardLabel.zPosition = 100
        killBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        killBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        errorsBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        errorsBoardLabel.name = "errorsBoaard"
        errors = 0
        errorsBoardLabel.text = String("Errors: \(errors)")
        errorsBoardLabel.color = SKColor.redColor()
        errorsBoardLabel.fontSize = 15
        errorsBoardLabel.position = CGPoint(x: horizontalXAxis * 0.10, y: verticalAxis * 0.8)
        errorsBoardLabel.zPosition = 100
        errorsBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        errorsBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        let gameName = SKLabelNode(fontNamed:"Chalkduster")
        gameName.text = "relliK"
        gameName.color = SKColor.redColor()
        gameName.fontSize = 20
        gameName.position = CGPoint(x:horizontalXAxis, y:CGRectGetMaxY(playableRect) - gameName.frame.size.height)
        
        timerBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        timerBoardLabel.name = "errorsBoaard"
        gameTimer = 0
        timerBoardLabel.text = String("0:0")
        timerBoardLabel.color = SKColor.redColor()
        timerBoardLabel.fontSize = 15
        timerBoardLabel.position = CGPoint(x:horizontalXAxis, y:CGRectGetMaxY(playableRect) - (timerBoardLabel.frame.size.height + gameName.frame.size.height) )
        timerBoardLabel.zPosition = 100
        timerBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        timerBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        setDebugLabels()
        addChild(gameName)
        addChild(killBoardLabel)
        addChild(backgroundNode)
        addChild(scoreBoardLabel)
        addChild(errorsBoardLabel)
        addChild(highScoreBoardLabel)
        addChild(timerBoardLabel)
    }
    func setDebugLabels(){
        gameSpeedBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        gameSpeedBoardLabel.name = "gameSpeedBoaard"
        gameSpeedBoardLabel.text = String("Game Speed: 0:0")
        gameSpeedBoardLabel.color = SKColor.redColor()
        gameSpeedBoardLabel.fontSize = 15
        gameSpeedBoardLabel.position = CGPoint(x: horizontalXAxis * 1.75, y: verticalAxis * 1.8 - gameSpeedBoardLabel.frame.height*2)//CGPoint(x:horizontalXAxis * 0.30, y:CGRectGetMidY(playableRect) + (gameSpeedBoardLabel.frame.height * 2) )
        gameSpeedBoardLabel.zPosition = 100
        gameSpeedBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        gameSpeedBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        waitTimeBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
        waitTimeBoardLabel.name = "waitTimeBoaard"
        waitTimeBoardLabel.text = String("Wait:0:0")
        waitTimeBoardLabel.color = SKColor.redColor()
        waitTimeBoardLabel.fontSize = 15
        waitTimeBoardLabel.position = CGPoint(x: horizontalXAxis * 0.05, y: verticalAxis * 1.8 - waitTimeBoardLabel.frame.height*2)//CGPoint(x:horizontalXAxis * 1.30, y:CGRectGetMidY(playableRect) + (waitTimeBoardLabel.frame.height * 2) )
        waitTimeBoardLabel.zPosition = 100
        waitTimeBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        waitTimeBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        
        addChild(gameSpeedBoardLabel)
        addChild(waitTimeBoardLabel)
    }
    func createSwipeRecognizers() {
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "shotDirection:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view?.addGestureRecognizer(swipeDown)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "shotDirection:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipeRight)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "shotDirection:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view?.addGestureRecognizer(swipeUp)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "shotDirection:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view?.addGestureRecognizer(swipeLeft)
        
        var tapped = UITapGestureRecognizer(target: self, action: "paused")
        tapped.numberOfTapsRequired = 1
        self.view?.addGestureRecognizer(tapped)
    }
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        addChild(shape)
    }
    func createActions(){
        bulletMoveRightAction = SKAction.repeatAction(SKAction.moveByX(CGFloat(incrementalSpaceBetweenBlocks), y: 0, duration: NSTimeInterval(0.1)), count: 6)
        bulletMoveLeftAction = SKAction.reversedAction(bulletMoveRightAction)()
        bulletMoveDownAction = SKAction.repeatAction(SKAction.moveByX(0, y: CGFloat(-incrementalSpaceBetweenBlocks), duration: NSTimeInterval(0.1)), count: 6)
        bulletMoveUpAction = SKAction.reversedAction(bulletMoveDownAction)()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
        }
    }
    
    //Enemies Methods
    func moveEnemies(){
        for monstor in monstorsInField{
            if(!monstor.isDead){
                monstor.moveFunc()
            }
            
            monstorsInField = monstorsInField.filter({!$0.clearedForMorgue})
        }
    }
    func spawnEnemy(){
        let randomNum = Int.random(min: 1, max: 4)
        var enemy: Enemy!
        
        switch randomNum {
        case 1:
            enemy = randomEnemy(rightSideEnemyStartPosition)
            enemy.directionOf = .right
        case 2:
            enemy = randomEnemy(leftSideEnemyStartPosition)
            enemy.directionOf = .left
        case 3:
            enemy = randomEnemy(upSideEnemyStartPosition)
            enemy.directionOf = .up
        case 4:
            enemy = randomEnemy(downSideEnemyStartPosition)
            enemy.directionOf = .down
        case 5:
            return//This doesn't send out an enemy
        default:
            assertionFailure("out of bounds Spawn enemy")
        }
        enemy.entityCurrentBlock = blockPlace.fifth
        monstorsInField.append(enemy)
        
        addChild(enemy)
        
    }
    func randomEnemy(enemyLocation: CGPoint) -> Enemy{
        let randomNum = Int.random(min: 1, max: 10)
        
        runAction(SKAction.playSoundFileNamed("spawn.wav", waitForCompletion: false))
        switch randomNum {
        case 1:
            return Boss(entityPosition: enemyLocation)
        case 2...5:
            return Soldier(entityPosition: enemyLocation)
        case 5...10:
            return Minion(entityPosition: enemyLocation)
//        case 4:
//            return Ghost(entityPosition: enemyLocation)
        default:
            assertionFailure("out of bounds Spawn enemy")
            return Minion(entityPosition: enemyLocation)
        }
    }
    
    //Player and Bullets Methods
    func createPlayer(){
        self.player = Player(entityPosition: CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)))
        addChild(player)
    }
    func moveBullets(){
        bulletsInField.map({
            $0 as Bullet
            if !$0.isShot{
                $0.moveFunc()
            }else{
                if $0.stopped{
                    addError()
                }
            }
        })
        
        bulletsInField = bulletsInField.filter({$0.stopped == false})
        
    }
    func shotDirection(sender: UISwipeGestureRecognizer){
        if isShootable{
            let newBullet = Bullet(entityPosition: CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)))
            
            switch sender.direction{
            case UISwipeGestureRecognizerDirection.Right:
                newBullet.directionOf = entityDirection.right
                newBullet.move = bulletMoveRightAction
                player.directionOf = entityDirection.right
            case UISwipeGestureRecognizerDirection.Left:
                newBullet.directionOf = entityDirection.left
                newBullet.move = bulletMoveLeftAction
                player.directionOf = entityDirection.left
            case UISwipeGestureRecognizerDirection.Up:
                newBullet.directionOf = entityDirection.up
                newBullet.move = bulletMoveUpAction
                player.directionOf = entityDirection.up
            case UISwipeGestureRecognizerDirection.Down:
                newBullet.directionOf = entityDirection.down
                newBullet.move = bulletMoveDownAction
                player.directionOf = entityDirection.down
            default:
                assertionFailure("Out of bounds")
            }
            addChild(newBullet)
            bulletsInField.append(newBullet)
            isShootable = false
            player.setAngle()
        }
    }
    func particleCreator(){
        let rainTexture = SKTexture(imageNamed: "rainDrop")
        let emitterNOde = SKEmitterNode()
        
        emitterNOde.particleTexture = rainTexture
        emitterNOde.particleBirthRate = 80.0
        emitterNOde.particleColor = SKColor.whiteColor()
        emitterNOde.particleSpeed = -450
        emitterNOde.particleSpeedRange = 150
        emitterNOde.particleLifetime = 2.0
        emitterNOde.particleScale = 0.2
        emitterNOde.particleAlpha = 0.75
        emitterNOde.particleAlphaRange = 0.5
        emitterNOde.particleColorBlendFactor = 1
        emitterNOde.particleScale = 0.2
        emitterNOde.particleScaleRange = 0.5
        emitterNOde.position = CGPoint(
            x: CGRectGetWidth(playableRect)/2, y: CGRectGetHeight(playableRect) + 10)
        emitterNOde.particlePositionRange = CGVector(dx: CGRectGetWidth(playableRect), dy: CGRectGetHeight(playableRect))
    }
    
    //Block creator Methods
    func createPlayerBlock(){
        
        self.playerBlock = SKSpriteNode(imageNamed: "stone")
        self.playerBlock.name = "playerBlock"
        self.playerBlock.color = SKColor.redColor()
        self.playerBlock.colorBlendFactor = 1.0
        self.playerBlock.position = CGPoint(x: horizontalXAxis, y: verticalAxis)
        self.playerBlock.setScale(playerBlockScale)
        self.playerBlock.texture?.filteringMode = .Nearest
        self.playerBlock.texture!.textureByGeneratingNormalMapWithSmoothness(0.5, contrast: 1.0)
        self.playerBlock.lightingBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.up | BitMaskOfLighting.down
        
        
        let playerBlockLight = SKLightNode()
        playerBlockLight.categoryBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.down | BitMaskOfLighting.up
        playerBlockLight.enabled = true
        playerBlockLight.position = playerBlock.position
        playerBlockLight.falloff = 1.0
        playerBlockLight.ambientColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)// SKColor.yellowColor()
        playerBlockLight.lightColor = SKColor(white: 0.1, alpha: 1.0)
        
        addChild(playerBlockLight)
        addChild(playerBlock)
    }
    func createBlocks(){
        for i in 0...4{
            leftBoxes.append(SKSpriteNode(imageNamed: "stone"))
            rightBoxes.append(SKSpriteNode(imageNamed: "stone"))
            upBoxes.append(SKSpriteNode(imageNamed: "stone"))
            downBoxes.append(SKSpriteNode(imageNamed: "stone"))
            
            leftBoxes[i].position = CGPoint(x: horizontalXAxis - pointBetweenBlocks, y: verticalAxis)
            rightBoxes[i].position = CGPoint(x: horizontalXAxis + pointBetweenBlocks, y: verticalAxis)
            upBoxes[i].position = CGPoint(x: horizontalXAxis, y: verticalAxis  + pointBetweenBlocks)
            downBoxes[i].position = CGPoint(x: horizontalXAxis, y: verticalAxis  - pointBetweenBlocks)
            
            leftBoxes[i].setScale(enemyBlockScale)
            rightBoxes[i].setScale(enemyBlockScale)
            downBoxes[i].setScale(enemyBlockScale)
            upBoxes[i].setScale(enemyBlockScale)
            
            leftBoxes[i].texture!.textureByGeneratingNormalMapWithSmoothness(1.0, contrast: 1.0)
            rightBoxes[i].texture!.textureByGeneratingNormalMapWithSmoothness(0.0, contrast: 0.0)
            downBoxes[i].texture!.textureByGeneratingNormalMapWithSmoothness(0.3, contrast: 0.6)
            upBoxes[i].texture!.textureByGeneratingNormalMapWithSmoothness(1.0, contrast: 0.0)
            
            leftBoxes[i].lightingBitMask = BitMaskOfLighting.left
            rightBoxes[i].lightingBitMask = BitMaskOfLighting.right
            downBoxes[i].lightingBitMask = BitMaskOfLighting.down
            upBoxes[i].lightingBitMask = BitMaskOfLighting.up
            
            addChild(leftBoxes[i])
            addChild(rightBoxes[i])
            addChild(upBoxes[i])
            addChild(downBoxes[i])
            
            pointBetweenBlocks += incrementalSpaceBetweenBlocks
            
            createPlayerBlock()
        }
    }
    
    //GamePlay Methods
    func upScore(enemyScoreValue: Int){
        score += enemyScoreValue
    }
    func upKilledEnemy(){
        killed++
    }
    func addError(){
        errors++
    }
    
    //Actions
    func playGameBackgroundMusic(){
        playBackgroundMusic("backgroundMusic.mp3")
    }
    
    //Other Game Scenes Methods
    func createGameOverScene(won: Bool){
        backgroundMusicPlayer.stop()
        let gameOverScene = GameOverScene(size: size, won: won)
        gameOverScene.scaleMode = scaleMode
        
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        
        view?.presentScene(gameOverScene, transition: reveal)
    }
}