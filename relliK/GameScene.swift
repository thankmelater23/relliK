//
//  GameScene.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright (c) 2015 Bang Bang Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate {
  //MARK: Unassigned
  var isGamePaused: Bool = false
  
  //MARK: Array of Monstors and Bullets
  var monstorsInField = [Enemy]()
  var bulletsInField = [Bullet]()
  
  //MARK: Sprite Objects
  var player: Player!
  var isShootable:Bool = false
  
  //MARK: Background
  var backgroundNode: SKSpriteNode!
  
  //MARK: Blocks
  var playerBlock: SKSpriteNode!
  var leftBoxes: [SKSpriteNode]! = []
  var rightBoxes: [SKSpriteNode]! = []
  var upBoxes: [SKSpriteNode]! = []
  var downBoxes: [SKSpriteNode]! = []
  
  //MARK: Light Nodes
  var leftLight = SKLightNode()
  var rightLight = SKLightNode()
  var upLight = SKLightNode()
  var downLight = SKLightNode()
  
  //MARK: Game Time
  var lastUpdateTime: TimeInterval = 0
  var dt: TimeInterval = 0
  var incrementCurrentGameSpeedTime: TimeInterval = 0
  var incrementGameSpeedTime: TimeInterval = GAME_MIN_SPEED * 5
  
  //MARK: Position and Moving Values
  let movePointsPerSec: CGFloat = 480.0
  var velocity = CGPoint.zero
  
  //MARK: Location and sizes
  let playableRect: CGRect
  var lastTouchLocation: CGPoint?
  let rotateRadiansPerSec:CGFloat = 4.0 * π
  var pointBetweenBlocks = CGFloat(spaceBetweenEnemyBlock)
  var shotStart = 50//No use right now 9-10-15
  let horizontalXAxis :CGFloat
  let verticalAxis :CGFloat
  
  //MARK: Enemy Spawn positions
  var leftSideEnemyStartPosition: CGPoint
  var rightSideEnemyStartPosition: CGPoint
  var upSideEnemyStartPosition: CGPoint
  var downSideEnemyStartPosition: CGPoint
  
  
  //MARK: Action vars
  //var moveUp : SKAction!
  //Move bullets actions to bullet
  var bulletMoveRightAction: SKAction!
  var bulletMoveLeftAction: SKAction!
  var bulletMoveDownAction: SKAction!
  var bulletMoveUpAction: SKAction!
  
  func gameOver(){
    if(player.isDead || errors >= 8){
      exit(EXIT_SUCCESS)
    }
  }
  
  func loadDefaults(){
    let gameHighScore = UserDefaults.standard.value(forKey: "highscore") as! Int?
    guard let defaultHighScore = gameHighScore else {
      UserDefaults.standard.setValue(0, forKeyPath: "highscore")
      UserDefaults.standard.synchronize()
      return
    }
    
    highscores = UserDefaults.standard.value(forKey: "highscore") as! Int!
  }
  
  //MARK: Game Labels
  var scoreBoardLabel = SKLabelNode()
  var score:Int = 0 {
    willSet{
      scoreBoardLabel.text = String("Score: \(newValue)")
      scoreBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                             SKAction.scale(to: 1, duration: 0.1)]))
      
      if newValue > highscores{
        
        let defaults = UserDefaults.standard.value(forKey: "highscore") as! Int
        if(newValue > defaults){
          UserDefaults.standard.setValue(highscores, forKey: "highscore")
          UserDefaults.standard.synchronize()
          highscores = newValue
        }
      }
    }
  }
  var killBoardLabel = SKLabelNode()
  var killed:Int = 0 {
    willSet{
      killBoardLabel.text = String("Killed: \(newValue)")
      killBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                            SKAction.scale(to: 1, duration: 0.1)]))
    }
  }
  
  var errorsBoardLabel = SKLabelNode()
  var errors:Int = 0 {
    willSet{
      errorsBoardLabel.text = String("Errors: \(newValue)")
      errorsBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                              SKAction.scale(to: 1, duration: 0.1)]))
    }
  }
  
  var highScoreBoardLabel = SKLabelNode()
  var highscores:Int = 0 {
    willSet{
      highScoreBoardLabel.text = String("High Score: \(newValue)")
      highScoreBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                                 SKAction.scale(to: 1, duration: 0.1)]))
    }
  }
  
  var timerBoardLabel = SKLabelNode()
  var gameMiliSecToSec = TimeInterval(0.0)
  var gameTimer:Int = 0 {
    willSet{
      timerBoardLabel.text = convertGameTimer(newValue)
      timerBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                             SKAction.scale(to: 1, duration: 0.1)]))
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
  
  func convertGameTimer(_ timeToConvert: Int)-> String{
    var total = 0
    var min = 0
    var sec = 0
    
    for _ in 0..<timeToConvert{
      total += 1
      if total == 60{
        total = 0
        min += 1
      }
    }
    sec = total
    return String("\(min):\(sec)")
  }
  
  @objc func paused(){
    isGamePaused = !isGamePaused
    
    //    if isGamePaused{
    //      while !isGamePaused{
    //        sleep(10)
    //      }
    //    }
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
  
  
  //MARK: Update Methods
  override func update(_ currentTime: TimeInterval) {
    
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
          enemyWaitTime == TimeInterval(0.4)
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
      
      
      
      if gameMiliSecToSec >= TimeInterval(1.0){
        gameTimer += 1
        gameMiliSecToSec = 0
      }else{
        gameMiliSecToSec += currentTime - lastUpdateTime
      }
      
      moveBullets()
      gameOver()
      lastUpdateTime = currentTime
    }
  }
  
  //MARK: Initialization methods
  override init(size: CGSize) {
    let maxAspectRatio:CGFloat = 71.0/40.0 // iPhone 5"
    let maxAspectRatioHeight = size.width / maxAspectRatio
    let maxAspectRationWidth = size.height / maxAspectRatio
    let playableMargin = (size.height-maxAspectRatioHeight)/2.0
    let playableMarginWidth = (size.width - maxAspectRationWidth) / 2.0
    playableRect =        CGRect(x: 0, y: playableMargin, width: size.width - playableMarginWidth * 2, height: size.height-playableMargin*2)
    
    leftSideEnemyStartPosition = CGPoint(x: playableRect.midX -  (spaceBetweenEnemyBlock + spaceToLastBox), y: playableRect.midY)
    rightSideEnemyStartPosition = CGPoint(x: playableRect.midX + (spaceBetweenEnemyBlock + spaceToLastBox), y: playableRect.midY)
    upSideEnemyStartPosition = CGPoint(x: playableRect.midX, y: playableRect.midY + (spaceBetweenEnemyBlock + spaceToLastBox))
    downSideEnemyStartPosition = CGPoint(x: playableRect.midX, y: playableRect.midY - (spaceBetweenEnemyBlock + spaceToLastBox))
    
    horizontalXAxis = playableRect.midX
    verticalAxis = playableRect.midY
    
    super.init(size: playableRect.size)
  }
  override func didMove(to view: SKView) {
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
  
  //MARK: Contact Methods
  func setPhysics(){
    self.physicsWorld.contactDelegate = self
    self.physicsWorld.gravity = CGVector(dx: CGFloat(0), dy: CGFloat(0))
  }
  func didBegin(_ contact: SKPhysicsContact) {
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
      secondNode.removeAction(forKey: "move")
      secondNode.kill()
      firstNode.hurt()
      
      if firstNode.isDead{
        self.upScore(firstNode.sumForScore())
        self.upKilledEnemy()
      }
    }
    
    if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) &&
      (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet){
      secondNode as! Enemy
      firstNode.removeAction(forKey: "move")
      
      firstNode.kill()
      secondNode.hurt()
      
      if secondNode.isDead{
        self.upScore(secondNode.sumForScore())
        self.upKilledEnemy()
        //                    }
      }
    }
  }
  
  //MARK: UI Methods
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
    scoreBoardLabel.color = SKColor.red
    scoreBoardLabel.fontSize = 15
    scoreBoardLabel.position =  CGPoint(x: horizontalXAxis * 2, y: verticalAxis * 1.8)
    scoreBoardLabel.zPosition = 100
    scoreBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    scoreBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    
    highScoreBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    highScoreBoardLabel.name = "highscoreBoard"
    highscores = 0
    highScoreBoardLabel.text = String("HighScore: \(highscores)")
    highScoreBoardLabel.color = SKColor.red
    highScoreBoardLabel.fontSize = 15
    highScoreBoardLabel.position = CGPoint(x: horizontalXAxis * 2, y: verticalAxis * 0.8)
    highScoreBoardLabel.zPosition = 100
    highScoreBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    highScoreBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    
    killBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    killBoardLabel.name = "killBoard"
    killed = 0
    killBoardLabel.text = String("Killed: \(killed)")
    killBoardLabel.color = SKColor.red
    killBoardLabel.fontSize = 15
    killBoardLabel.position = CGPoint(x: horizontalXAxis * 0.10, y: verticalAxis * 1.8)
    killBoardLabel.zPosition = 100
    killBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    killBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    
    errorsBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    errorsBoardLabel.name = "errorsBoaard"
    errors = 0
    errorsBoardLabel.text = String("Errors: \(errors)")
    errorsBoardLabel.color = SKColor.red
    errorsBoardLabel.fontSize = 15
    errorsBoardLabel.position = CGPoint(x: horizontalXAxis * 0.10, y: verticalAxis * 0.8)
    errorsBoardLabel.zPosition = 100
    errorsBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    errorsBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    
    let gameName = SKLabelNode(fontNamed:"Chalkduster")
    gameName.text = "relliK"
    gameName.color = SKColor.red
    gameName.fontSize = 20
    gameName.position = CGPoint(x:horizontalXAxis, y:playableRect.maxY - gameName.frame.size.height)
    
    timerBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    timerBoardLabel.name = "errorsBoaard"
    gameTimer = 0
    timerBoardLabel.text = String("0:0")
    timerBoardLabel.color = SKColor.red
    timerBoardLabel.fontSize = 15
    timerBoardLabel.position = CGPoint(x:horizontalXAxis, y:playableRect.maxY - (timerBoardLabel.frame.size.height + gameName.frame.size.height) )
    timerBoardLabel.zPosition = 100
    timerBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    timerBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    
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
    gameSpeedBoardLabel.color = SKColor.red
    gameSpeedBoardLabel.fontSize = 15
    gameSpeedBoardLabel.fontColor = SKColor.red
    gameSpeedBoardLabel.position = CGPoint(x: horizontalXAxis * 1.25, y: verticalAxis * 1.8 - gameSpeedBoardLabel.frame.height*2)
    gameSpeedBoardLabel.zPosition = 100
    gameSpeedBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    gameSpeedBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    
    waitTimeBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    waitTimeBoardLabel.name = "waitTimeBoaard"
    waitTimeBoardLabel.text = String("Wait:0:0")
    waitTimeBoardLabel.color = SKColor.red
    waitTimeBoardLabel.fontSize = 15
    waitTimeBoardLabel.fontColor = SKColor.red
    waitTimeBoardLabel.position = CGPoint(x: horizontalXAxis * 0.60, y: verticalAxis * 1.8 - waitTimeBoardLabel.frame.height*2)//CGPoint(x:horizontalXAxis * 1.30, y:CGRectGetMidY(playableRect) + (waitTimeBoardLabel.frame.height * 2) )
    waitTimeBoardLabel.zPosition = 100
    waitTimeBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    waitTimeBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    
    
    addChild(gameSpeedBoardLabel)
    addChild(waitTimeBoardLabel)
  }
  func createSwipeRecognizers() {
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeDown.direction = UISwipeGestureRecognizerDirection.down
    self.view?.addGestureRecognizer(swipeDown)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    self.view?.addGestureRecognizer(swipeRight)
    
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeUp.direction = UISwipeGestureRecognizerDirection.up
    self.view?.addGestureRecognizer(swipeUp)
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    self.view?.addGestureRecognizer(swipeLeft)
    
    let tapped = UITapGestureRecognizer(target: self, action: #selector(GameScene.paused as (GameScene) -> () -> ()))
    tapped.numberOfTapsRequired = 1
    tapped.numberOfTouchesRequired = 2
    self.view?.addGestureRecognizer(tapped)
  }
  func debugDrawPlayableArea() {
    let shape = SKShapeNode()
    let path = CGMutablePath()
    
    path.addRect(playableRect)
    shape.path = path
    shape.strokeColor = SKColor.red
    shape.lineWidth = 4.0
    addChild(shape)
  }
  func createActions(){
    bulletMoveRightAction = SKAction.repeat(SKAction.moveBy(x: CGFloat(incrementalSpaceBetweenBlocks), y: 0, duration: TimeInterval(0.1)), count: 6)
    bulletMoveLeftAction = SKAction.reversed(bulletMoveRightAction)()
    bulletMoveDownAction = SKAction.repeat(SKAction.moveBy(x: 0, y: CGFloat(-incrementalSpaceBetweenBlocks), duration: TimeInterval(0.1)), count: 6)
    bulletMoveUpAction = SKAction.reversed(bulletMoveDownAction)()
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /* Called when a touch begins */
    
    for touch in touches {
      let location = touch.location(in: self)
    }
  }
  
  
  //MARK: Enemies Methods
  func moveEnemies(){
    GlobalRellikConcurrent.async {
      for monstor in self.monstorsInField{
      if(!monstor.isDead){
        monstor.moveFunc()
      }
      
        self.monstorsInField = self.monstorsInField.filter({!$0.clearedForMorgue})
    }
    }
  }
  func spawnEnemy(){
    let randomNum = Int.random(min: 1, max: 4)
    var enemy: Enemy!
    
    switch randomNum {
    case 1:
      enemy = self.randomEnemy(self.rightSideEnemyStartPosition)
      enemy.directionOf = .right
    case 2:
      enemy = self.randomEnemy(self.leftSideEnemyStartPosition)
      enemy.directionOf = .left
    case 3:
      enemy = self.randomEnemy(self.upSideEnemyStartPosition)
      enemy.directionOf = .up
    case 4:
      enemy = self.randomEnemy(self.self.downSideEnemyStartPosition)
      enemy.directionOf = .down
    case 5:
    return//This doesn't send out an enemy
    default:
      assertionFailure("out of bounds Spawn enemy")
    }
    enemy.entityCurrentBlock = blockPlace.fifth
  self.monstorsInField.append(enemy)
    
    self.addChild(enemy)
  }
  func randomEnemy(_ enemyLocation: CGPoint) -> Enemy{
    let randomNum = Int.random(min: 1, max: 10)
    
    run(SKAction.playSoundFileNamed("spawn.wav", waitForCompletion: false))
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
  
  //MARK: Player and Bullets Methods
  func createPlayer(){
    self.player = Player(entityPosition: CGPoint(x: playableRect.midX, y: playableRect.midY))
    addChild(player)
  }
  func moveBullets(){
    GlobalBackgroundQueue.async {
      self.bulletsInField.map({
        $0 as Bullet
        if !$0.isShot{
          $0.moveFunc()
        }else{
          if $0.stopped{
            self.addError()
          }
        }
      })
      self.bulletsInField = self.bulletsInField.filter({$0.stopped == false})
    }
  }
  
  @objc func shotDirection(_ sender: UISwipeGestureRecognizer){
    if isShootable && !isGamePaused{
      let newBullet = Bullet(entityPosition: CGPoint(x: playableRect.midX, y: playableRect.midY))
      
      switch sender.direction{
      case UISwipeGestureRecognizerDirection.right:
        newBullet.directionOf = entityDirection.right
        newBullet.move = bulletMoveRightAction
        player.directionOf = entityDirection.right
      case UISwipeGestureRecognizerDirection.left:
        newBullet.directionOf = entityDirection.left
        newBullet.move = bulletMoveLeftAction
        player.directionOf = entityDirection.left
      case UISwipeGestureRecognizerDirection.up:
        newBullet.directionOf = entityDirection.up
        newBullet.move = bulletMoveUpAction
        player.directionOf = entityDirection.up
      case UISwipeGestureRecognizerDirection.down:
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
    GlobalBackgroundQueue.async {
    let rainTexture = SKTexture(imageNamed: "rainDrop")
    let emitterNOde = SKEmitterNode()
    
    emitterNOde.particleTexture = rainTexture
    emitterNOde.particleBirthRate = 80.0
    emitterNOde.particleColor = SKColor.white
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
      x: self.playableRect.width/2, y: self.playableRect.height + 10)
      emitterNOde.particlePositionRange = CGVector(dx: self.playableRect.width, dy: self.playableRect.height)
    }
  }
  
  //MARK: Block creator Methods
  func createPlayerBlock(){
    
    self.playerBlock = SKSpriteNode(imageNamed: "stone")
    self.playerBlock.name = "playerBlock"
    self.playerBlock.color = SKColor.red
    self.playerBlock.colorBlendFactor = 1.0
    self.playerBlock.position = CGPoint(x: horizontalXAxis, y: verticalAxis)
    self.playerBlock.setScale(playerBlockScale)
    self.playerBlock.texture?.filteringMode = .nearest
    self.playerBlock.texture!.generatingNormalMap(withSmoothness: 0.5, contrast: 1.0)
    self.playerBlock.lightingBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.up | BitMaskOfLighting.down
    
    
    let playerBlockLight = SKLightNode()
    playerBlockLight.categoryBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.down | BitMaskOfLighting.up
    playerBlockLight.isEnabled = true
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
      
      leftBoxes[i].texture!.generatingNormalMap(withSmoothness: 1.0, contrast: 1.0)
      rightBoxes[i].texture!.generatingNormalMap(withSmoothness: 0.0, contrast: 0.0)
      downBoxes[i].texture!.generatingNormalMap(withSmoothness: 0.3, contrast: 0.6)
      upBoxes[i].texture!.generatingNormalMap(withSmoothness: 1.0, contrast: 0.0)
      
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
  
  //MARK: GamePlay Methods
  func upScore(_ enemyScoreValue: Int){
    GlobalRellikConcurrent.async {
      self.score += enemyScoreValue
    }
  }
  func upKilledEnemy(){
    GlobalRellikConcurrent.async {
      self.killed += 1
  }
  }
  func addError(){
    GlobalRellikConcurrent.async {
      self.errors += 1
  }
  }
  
  //MARK: Actions
  func playGameBackgroundMusic(){
    GlobalRellikConcurrent.async {
    playBackgroundMusic("backgroundMusic.mp3")
    }
  }
  
  //MARK: Other Game Scenes Methods
  func createGameOverScene(_ won: Bool){
    backgroundMusicPlayer.stop()
    let gameOverScene = GameOverScene(size: size, won: won)
    gameOverScene.scaleMode = scaleMode
    
    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
    
    view?.presentScene(gameOverScene, transition: reveal)
  }
}
