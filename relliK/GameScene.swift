//
//  GameScene.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright (c) 2015 Bang Bang Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate {

    var monstorsInField = [Enemy]()
    var bulletsInField = [Bullet]()
    var isShootable:Bool = false
    var leftLight = SKLightNode()
    var rightLight = SKLightNode()
    var upLight = SKLightNode()
    var downLight = SKLightNode()
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var incrementCurrentGameSpeedTime: NSTimeInterval = 0
    var incrementGameSpeedTime: NSTimeInterval = NSTimeInterval(10)
    let movePointsPerSec: CGFloat = 480.0
    var velocity = CGPointZero
    let playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let rotateRadiansPerSec:CGFloat = 4.0 * π
    var gameScore: Int = 0
    var killedEnemies: Int = 0
    var errorsMade: Int = 0
    
    var player: Player!
    var backgroundNode: SKSpriteNode!
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
    
    var moveUp : SKAction!
    
    var bulletMoveRightAction: SKAction!
    var bulletMoveLeftAction: SKAction!
    var bulletMoveDownAction: SKAction!
    var bulletMoveUpAction: SKAction!
    
    let horizontalXAxis :CGFloat
    let verticalAxis :CGFloat
    
    //Update Methods
    override func update(currentTime: NSTimeInterval) {
        if dt >= gameSpeed + enemyWaitTime{
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
        
        if incrementCurrentGameSpeedTime > incrementGameSpeedTime {
            print(incrementGameSpeedTime)
            if gameSpeed >= GAME_MAX_SPEED{
                if gameSpeed <= GAME_MAX_SPEED * 0.75{
                    if enemyWaitTime >= enemyWaitMaxSpeed{
                        enemyWaitTime -= enemyWaitIncrementalSpeed
                    }
                }else if gameSpeed <= gameSpeed * 0.25{
                    enemyWaitTime += enemyWaitIncrementalSpeed
                }
                
                gameSpeed -= gameIncrementalSpeed
                print(gameSpeed)
                incrementCurrentGameSpeedTime = 0
            }else{
                gameSpeed == GAME_MAX_SPEED
            }
            
        }else{
            incrementCurrentGameSpeedTime += currentTime - lastUpdateTime
        }
        
        moveBullets()
        player.setAngle()
        lastUpdateTime = currentTime
    }
    
    //Initialization methods
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
        backgroundNode = SKSpriteNode(imageNamed: "background1")// dmgdCheckers
        backgroundNode.size = size
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode.position = CGPoint(x: playableRect.width/2, y: playableRect.height/2)
        backgroundNode.zPosition = -1
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Andre's New Game to with sound"
        myLabel.color = SKColor.redColor()
        myLabel.fontSize = 20
        myLabel.position = CGPoint(x:CGRectGetMinX(playableRect) + myLabel.frame.size.width * 0.75, y:CGRectGetMaxY(playableRect) - myLabel.frame.size.height * 2);
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(CGFloat(0), CGFloat(0))
        
        playBackgroundMusic("backgroundMusic.mp3")
        
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
        
        createActions()
        particleCreator()
        createPlayer()
        createBlocks()
        
        self.addChild(myLabel)
        addChild(backgroundNode)
        
        debugDrawPlayableArea()
        createSwipeRecognizers()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Contact Methods
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
                firstNode.hurt()
                secondNode.removeActionForKey("move")
                secondNode.kill()
        }
        
        if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) &&
            (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet){
                firstNode.removeActionForKey("move")
                firstNode.kill()
                secondNode.hurt()
        }
    }
    
//    func didEndContact(contact: SKPhysicsContact) {
//        let firstNode = contact.bodyA.node as! Entity
//        let secondNode = contact.bodyB.node as! Entity
//        
//        if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) &&
//            (contact.bodyB.categoryBitMask == PhysicsCategory.Bullet){
//                secondNode.kill()
//        }
//        
//        if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) &&
//            (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet){
//                secondNode.kill()
//        }
//    }
    
    //UI Methods
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
        bulletMoveRightAction = SKAction.repeatAction(SKAction.moveByX(CGFloat(incrementalSpaceBetweenBlocks), y: 0, duration: NSTimeInterval(0.5)), count: 5)
        bulletMoveLeftAction = SKAction.reversedAction(bulletMoveRightAction)()
        bulletMoveDownAction = SKAction.moveByX(0, y: -CGFloat(1000), duration: NSTimeInterval(4))
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
        //Insert Angle to face(SKActionAngle)
        
        //Insert Space to move(SKActionMoveByX)
        for monstor in monstorsInField{
            //Check if enemy has reached middle if so removeionOf {
            monstor.moveFunc()
            //iterate through to next space
            
        }
        //Insert Speed it moves
    }
    
    func spawnEnemy() {
        let randomNum = Int.random(min: 1, max: 5)
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

    //Player and Bullets Methods
    func createPlayer(){
        self.player = Player(entityPosition: CGPoint(x: CGRectGetMidX(playableRect), y: CGRectGetMidY(playableRect)))
        addChild(player)
    }
    
    func moveBullets(){
//        if bulletsInField.isEmpty{
//            middleLight.enabled = true
//        }else{
//            middleLight.enabled = false
//        }
        
        for bullet in bulletsInField{
            bullet.moveFunc()
            bullet.getSideForLighting()
        }
        bulletsInField.removeAll()
        
    }
    
    func shotDirection(sender: UISwipeGestureRecognizer) {
        
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
            newBullet.light.categoryBitMask = newBullet.getSideForLighting()
            bulletsInField.append(newBullet)
            isShootable = false
        }
        
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
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
        
        //addChild(emitterNOde)
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
        //self.playerBlock.texture!.textureByGeneratingNormalMap()
        self.playerBlock.texture!.textureByGeneratingNormalMapWithSmoothness(0.5, contrast: 1.0)
        self.playerBlock.lightingBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.up | BitMaskOfLighting.down
        
        
        let playerBlockLight = SKLightNode()
        playerBlockLight.categoryBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.down | BitMaskOfLighting.up
        playerBlockLight.enabled = true
        playerBlockLight.position = playerBlock.position
        playerBlockLight.falloff = 1.0
        playerBlockLight.ambientColor = SKColor.blackColor()
        playerBlockLight.lightColor = SKColor(white: 0.1, alpha: 1.0)

        
        addChild(playerBlockLight)
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
    func upScore(){
        gameScore++
    }
    
    func upKilledEnemy(){
        killedEnemies++
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