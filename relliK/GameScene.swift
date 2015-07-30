//
//  GameScene.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright (c) 2015 Bang Bang Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var monstorsInField = [Enemy]()
    var bulletsInField = [Bullet]()
    var isShootable:Bool = false
    
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var incrementGameSpeedTime: NSTimeInterval = 0
    let movePointsPerSec: CGFloat = 480.0
    var velocity = CGPointZero
    let playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let rotateRadiansPerSec:CGFloat = 4.0 * π
    
    var player: Player!
    
    var playerBlock: SKSpriteNode!
    var leftBoxes: [SKSpriteNode]! = []
    var rightBoxes: [SKSpriteNode]! = []
    var upBoxes: [SKSpriteNode]! = []
    var downBoxes: [SKSpriteNode]! = []
    
    var leftSideEnemyStartPosition: CGPoint
    var rightSideEnemyStartPosition: CGPoint
    var upSideEnemyStartPosition: CGPoint
    var downSideEnemyStartPosition: CGPoint
    
    var pointBetweenBlocks = CGFloat(spaceBetweenEnemyBlock)
    
    var shotStart = 50
    
    
    var moveRight : SKAction!
    var moveLeft : SKAction!
    var moveDown : SKAction!
    var moveUp : SKAction!
    
    var bulletMoveRightAction: SKAction!
    var bulletMoveLeftAction: SKAction!
    var bulletMoveDownAction: SKAction!
    var bulletMoveUpAction: SKAction!
    
    let horizontalXAxis :CGFloat
    let verticalAxis :CGFloat
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 4.0/3.0 // 16.0/9.0 // iPhone 5"
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-maxAspectRatioHeight)/2.0
        playableRect =        CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
        let minPlayableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)//Use to position labels
        
        leftSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect) -  (spaceBetweenEnemyBlock + spaceToLastBox), y: CGRectGetMidY(playableRect))
        rightSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect) + (spaceBetweenEnemyBlock + spaceToLastBox), y: CGRectGetMidY(playableRect))
        upSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect) + (spaceBetweenEnemyBlock + spaceToLastBox))
        downSideEnemyStartPosition = CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect) - (spaceBetweenEnemyBlock + spaceToLastBox))
        
        horizontalXAxis = CGRectGetMidX(playableRect)
        verticalAxis = CGRectGetMidY(playableRect)
        
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background = SKSpriteNode(imageNamed: "background1")// dmgdCheckers
        background.size = size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: playableRect.width/2, y: playableRect.height/2)
        background.zPosition = -1
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Andre's New Game"
        myLabel.color = SKColor.redColor()
        myLabel.fontSize = 20
        myLabel.position = CGPoint(x:CGRectGetMinX(playableRect) + myLabel.frame.size.width * 0.75, y:CGRectGetMaxY(playableRect) - myLabel.frame.size.height * 2);
        
        playBackgroundMusic("backgroundMusic.mp3")
        
        createActions()
        particleCreator()
        createPlayer()
        createBlocks()
        
        self.addChild(myLabel)
        addChild(background)
        
        debugDrawPlayableArea()
        createSwipeRecognizers()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func update(currentTime: NSTimeInterval) {
        if dt >= gameSpeed{
            dt = 0
            spawnEnemy()
            moveEnemies()
                    }
        
            if bulletCurrentCoolDownTime > bulletCoolDownTime{
                isShootable = true
                bulletCurrentCoolDownTime = 0.0
                lastShot = currentTime
            }else{
            bulletCurrentCoolDownTime += (currentTime - lastShot)
            lastShot = currentTime
        }
        
        if lastUpdateTime > 0 {
            dt += currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        if incrementGameSpeedTime > 10 {
            gameSpeed += gameIncrementalSpeed
            incrementGameSpeedTime = 0
        }else{
            incrementGameSpeedTime += lastUpdateTime - currentTime
        }
        
        moveBullets()
        player.setAngle()
        lastUpdateTime = currentTime
    }
    
    
    
    //User created functions
    func createPlayer(){
        self.player = Player(entityPosition: CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)))
        addChild(player)
    }
    
    func moveBullets(){
        for bullet in bulletsInField{
            bullet.moveFunc()
        }
        bulletsInField.removeAll()
        
    }
    
    func moveEnemies(){
        //Insert Angle to face(SKActionAngle)
        
        //Insert Space to move(SKActionMoveByX)
        for monstor in monstorsInField{
            //Check if enemy has reached middle if so removeionOf {
            monstor.moveFunc()
            
        }
        //Insert Speed it moves
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    
    func spawnEnemy() {
        let randomNum = Int.random(min: 1, max: 5)
        var enemy: Enemy!
        
        switch randomNum {
        case 1:
            enemy = randomEnemy(rightSideEnemyStartPosition)
            enemy.directionOf = .right
            enemy.move = moveLeft
        case 2:
            enemy = randomEnemy(leftSideEnemyStartPosition)
            enemy.directionOf = .left
            enemy.move = moveRight
        case 3:
            enemy = randomEnemy(upSideEnemyStartPosition)
            enemy.directionOf = .up
            enemy.move = moveDown
        case 4:
            enemy = randomEnemy(downSideEnemyStartPosition)
            enemy.directionOf = .down
            enemy.move = moveUp
        case 5:
            return//This doesn't send out an enemy
        default:
            assertionFailure("out of bounds Spawn enemy")
        }
        
        
        monstorsInField.append(enemy)
        
        addChild(enemy)
        
    }
    
    func randomEnemy(enemyLocation: CGPoint) -> Enemy{
        let randomNum = Int.random(min: 1, max: 4)
        
        switch randomNum {
        case 1:
            return Boss(entityPosition: enemyLocation)
        case 2:
            return Soldier(entityPosition: enemyLocation)
        case 3:
            return Minion(entityPosition: enemyLocation)
        case 4:
            return Ghost(entityPosition: enemyLocation)
        default:
            assertionFailure("out of bounds Spawn enemy")
            return Minion(entityPosition: enemyLocation)
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
        
        addChild(emitterNOde)
    }
    
    func createPlayerBlock(){
        self.playerBlock = SKSpriteNode(imageNamed: "stone")
        self.playerBlock.name = "playerBlock"
        self.playerBlock.color = SKColor.yellowColor()
        self.playerBlock.colorBlendFactor = 0.8
        self.playerBlock.position = CGPoint(x: horizontalXAxis, y: verticalAxis)
        self.playerBlock.setScale(playerBlockScale)
        
        addChild(playerBlock)
    }
    
    func createBlocks(){
        for _ in 0...4{
            leftBoxes.append(SKSpriteNode(imageNamed: "stone"))
            rightBoxes.append(SKSpriteNode(imageNamed: "stone"))
            upBoxes.append(SKSpriteNode(imageNamed: "stone"))
            downBoxes.append(SKSpriteNode(imageNamed: "stone"))
        }
        
        for i in 0...4{
            leftBoxes[i].position = CGPoint(x: horizontalXAxis - pointBetweenBlocks, y: verticalAxis)
            rightBoxes[i].position = CGPoint(x: horizontalXAxis + pointBetweenBlocks, y: verticalAxis)
            upBoxes[i].position = CGPoint(x: horizontalXAxis, y: verticalAxis  + pointBetweenBlocks)
            downBoxes[i].position = CGPoint(x: horizontalXAxis, y: verticalAxis  - pointBetweenBlocks)
            
            leftBoxes[i].setScale(enemyBlockScale)
            rightBoxes[i].setScale(enemyBlockScale)
            downBoxes[i].setScale(enemyBlockScale)
            upBoxes[i].setScale(enemyBlockScale)
            
            addChild(leftBoxes[i])
            addChild(rightBoxes[i])
            addChild(upBoxes[i])
            addChild(downBoxes[i])
            
            pointBetweenBlocks += incrementalSpaceBetweenBlocks
            
            createPlayerBlock()
        }
        //            createEnemies()//Needs to be here because it uses pointsBetweenBlocks *variable*
    }
    
    func shotDirection(sender: UISwipeGestureRecognizer) {
        
        if isShootable{
        let newBullet = Bullet(entityPosition: CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)))

        switch sender.direction{
        case UISwipeGestureRecognizerDirection.Right:
            newBullet.directionTo = entityDirection.right
            newBullet.move = bulletMoveRightAction
            player.directionOf = entityDirection.right
        case UISwipeGestureRecognizerDirection.Left:
            newBullet.directionTo = entityDirection.left
            newBullet.move = bulletMoveLeftAction
            player.directionOf = entityDirection.left
        case UISwipeGestureRecognizerDirection.Up:
            newBullet.directionTo = entityDirection.up
            newBullet.move = bulletMoveUpAction
            player.directionOf = entityDirection.up
        case UISwipeGestureRecognizerDirection.Down:
            newBullet.directionTo = entityDirection.down
            newBullet.move = bulletMoveDownAction
            player.directionOf = entityDirection.down
        default:
            assertionFailure("Out of bounds")
        }
        
        addChild(newBullet)
        bulletsInField.append(newBullet)
            isShootable = false
        }
        
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
    }
    
    func createActions(){
        let moveRightAction = SKAction.moveByX(incrementalSpaceBetweenBlocks, y: 0, duration: gameSpeed - enemyWaitTime)//insert gameSpeed in duration
        let moveLeftAction = SKAction.reversedAction(moveRightAction)()
        let moveDownAction = SKAction.moveByX(0, y:-incrementalSpaceBetweenBlocks, duration: gameSpeed - enemyWaitTime)
        let moveUpAction = SKAction.reversedAction(moveDownAction)()
        
        let wait = SKAction.waitForDuration(enemyWaitTime)
        
        bulletMoveRightAction = SKAction.moveByX(CGFloat(1000), y: 0, duration: NSTimeInterval(4))
        bulletMoveLeftAction = SKAction.reversedAction(bulletMoveRightAction)()
        bulletMoveDownAction = SKAction.moveByX(0, y: -CGFloat(1000), duration: NSTimeInterval(4))
        bulletMoveUpAction = SKAction.reversedAction(bulletMoveDownAction)()
        
        moveRight = SKAction.sequence([moveRightAction, wait])
        moveLeft = SKAction.sequence([moveLeftAction, wait])
        moveDown = SKAction.sequence([moveDownAction, wait])
        moveUp = SKAction.sequence([moveUpAction, wait])
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
        }
    }
    
    func createGameOverScene(won: Bool){
        backgroundMusicPlayer.stop()
        let gameOverScene = GameOverScene(size: size, won: won)
        gameOverScene.scaleMode = scaleMode
        
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        
        view?.presentScene(gameOverScene, transition: reveal)
    }
    
}