//
//  GameScene.swift
//  relliK
//
//  Created by Andre Villanueva on 7/25/15.
//  Copyright (c) 2015 Bang Bang Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  // MARK: - Unassigned
  var isGamePaused: Bool = false
  var cpuEnabled = true
  // MARK: - Array of Monstors and Bullets
  var _monstorsInField = [Enemy]()
  var monstorsInField: [Enemy]{
    get{
//      return GlobalRellikEnemyConcurrent.sync {
        return _monstorsInField
//      }
    }
    set{
//      GlobalRellikEnemyConcurrent.sync {
        _monstorsInField = newValue
//      }
    }
  }
  var _bulletsInField = [Bullet?]()
  var bulletsInField: [Bullet?]{
    get{
      return GlobalRellikBulletSerial.sync {
        return _bulletsInField
      }
    }
    set{
      GlobalRellikBulletSerial.sync {
        _bulletsInField = newValue
      }
    }
  }
  var _shots = [()->()]()
  var shots: [()->()]{
    get{
//      return GlobalRellikSerial.sync {
        return _shots
//      }
    }
    set{
//      GlobalRellikSerial.sync {
      _shots = newValue
//    }
    }
  }
  
  // MARK: - Sprite Objects
  var player: Player!
  var isShootable: Bool = false
  
  // MARK: - Backgrounds
  var backgroundNode: SKSpriteNode!
  
  // MARK: - Blocks
  var playerBlock: SKSpriteNode!
  var leftBoxes: [SKSpriteNode]! = []
  var rightBoxes: [SKSpriteNode]! = []
  var upBoxes: [SKSpriteNode]! = []
  var downBoxes: [SKSpriteNode]! = []
  
  //MARK: - Loading Views
  var loadingViewNode = SKNode()
  var textLabel = SKLabelNode()
  
  // MARK: - Light Nodes
  var leftLight = SKLightNode()
  var rightLight = SKLightNode()
  var upLight = SKLightNode()
  var downLight = SKLightNode()
  
  // MARK: - Game Time
  var lastUpdateTime: TimeInterval = 0
  var dt: TimeInterval = 0
  var incrementCurrentGameSpeedTime: TimeInterval = 0
  var incrementGameSpeedTime: TimeInterval = GAME_MIN_SPEED * 5
  
  // MARK: - Position and Moving Values
  let movePointsPerSec: CGFloat = 480.0
  var velocity = CGPoint.zero
  
  // MARK: - Location and sizes
  let playableRect: CGRect
  var lastTouchLocation: CGPoint?
  let rotateRadiansPerSec: CGFloat = 4.0 * π
  var pointBetweenBlocks = CGFloat(spaceBetweenEnemyBlock)
  let horizontalXAxis: CGFloat
  let verticalAxis: CGFloat
  
  // MARK: - Enemy Spawn positions
  var leftSideEnemyStartPosition: CGPoint
  var rightSideEnemyStartPosition: CGPoint
  var upSideEnemyStartPosition: CGPoint
  var downSideEnemyStartPosition: CGPoint
  
  // MARK: - Action vars
  //var moveUp : SKAction!
  //Move bullets actions to bullet
  var bulletMoveRightAction: SKAction!
  var bulletMoveLeftAction: SKAction!
  var bulletMoveDownAction: SKAction!
  var bulletMoveUpAction: SKAction!
  
  func gameOver() {
    GlobalRellikConcurrent.sync{
      if(self.player.isDead || self.errors >= 15) {
      //      self.restartGame()
      fatalError()
      }
    }
  }
  
  func highScoreSetup() {
    GlobalRellikConcurrent.async {
      let gameHighScore = UserDefaults.standard.value(forKey: "highscore") as! Int?
      guard let defaultHighScore = gameHighScore else {
        UserDefaults.standard.setValue(0, forKeyPath: "highscore")
        UserDefaults.standard.synchronize()
        return
      }
      
      self.highscores = defaultHighScore
    }
  }
  
  // MARK: - Game Labels
  var scoreBoardLabel = SKLabelNode()
  var score: Int = 0 {
    willSet {
      scoreBoardLabel.text = String("Score: \(newValue)")
      scoreBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                             SKAction.scale(to: 1, duration: 0.1)]))
      //Makes current score new high score if current score is greater than the high score
      if newValue > highscores {
          highscores = newValue
      }
    }
  }
  var killBoardLabel = SKLabelNode()
  var killed: Int = 0 {
    willSet {
      killBoardLabel.text = String("Killed: \(newValue)")
      killBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                            SKAction.scale(to: 1, duration: 0.1)]))
    }
  }
  
  var errorsBoardLabel = SKLabelNode()
  var _errors: Int = 0
  var errors: Int{
    get{
      return GlobalRellikConcurrent.sync {
        return _errors
      }
    }
    set{
      GlobalRellikConcurrent.sync {
    self._errors = newValue
    errorsBoardLabel.text = String("Errors: \(newValue)")
    errorsBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
    SKAction.scale(to: 1, duration: 0.1)]))
    }
    }
  }
  
  var highScoreBoardLabel = SKLabelNode()
  var highscores: Int = 0 {
    willSet {
      highScoreBoardLabel.text = String("High Score: \(newValue)")
      highScoreBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                                 SKAction.scale(to: 1, duration: 0.1)]))
    }
  }
  
  var timerBoardLabel = SKLabelNode()
  var gameMiliSecToSec = TimeInterval(0.0)
  var gameTimer: Int = 0 {
    willSet {
      timerBoardLabel.text = convertGameTimer(newValue)
      timerBoardLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1),
                                             SKAction.scale(to: 1, duration: 0.1)]))
    }
  }
  var gameName = SKLabelNode(fontNamed:"Chalkduster")
  var waitTimeBoardLabel = SKLabelNode()
  var gameSpeedBoardLabel = SKLabelNode()
  
  func setGameLights() {
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
  
  
  // MARK: Update Methods
  override func update(_ currentTime: TimeInterval) {
    if !isGamePaused && gameState == .playing {
      if incrementCurrentGameSpeedTime > incrementGameSpeedTime {
        //        log.verbose("Update game speed")
        
        enemyWaitTime -= enemyWaitIncrementalSpeed
        
        if enemyWaitTime > enemyWaitMinSpeed {
          enemyWaitTime = enemyWaitMinSpeed
        }
        if enemyWaitTime < enemyWaitMaxSpeed {
          enemyWaitTime = enemyWaitMaxSpeed
        }
        
        if gameSpeed <= GAME_MAX_SPEED {
          //          log.verbose("Current gamespeed under min: \(gameSpeed)")
          gameSpeed = GAME_MAX_SPEED
          enemyWaitTime == TimeInterval(0.4)
          //          log.verbose("Current gameSpeedChanged to: \(gameSpeed)")
        } else {//Decrese gameSpeed
          gameSpeed -= gameIncrementalSpeed
        }
        //                if gameSpeed > GAME_MIN_SPEED{
        //                    log.verbose("Current gameSpeed over max: \(gameSpeed)")
        //                    gameSpeed = GAME_MIN_SPEED
        //                    log.verbose("Current gameSpeedChanged: \(gameSpeed)")
        //                }
        
        self.setWaitTimeLabel()
        self.setGameTimeLabel()
        
        incrementCurrentGameSpeedTime = 0
        
        //        log.verbose("Current gameSpeed: \(gameSpeed)")
      } else {
        incrementCurrentGameSpeedTime += currentTime - lastUpdateTime
      }
      
      if dt >= gameSpeed + enemyWaitTime {
        //        log.verbose("game total Speed: \(gameSpeed + enemyWaitTime)")
        dt = 0
        spawnEnemy()
        moveEnemies()
        //        log.verbose("Spawn and move time")
      }
      
      if lastUpdateTime > 0 {
        dt += currentTime - lastUpdateTime
      } else {
        dt = 0
      }
      
      if bulletCurrentCoolDownTime > bulletCoolDownTime {
        isShootable = true
        bulletCurrentCoolDownTime = 0.0
        lastShot = currentTime
      } else {
        bulletCurrentCoolDownTime += (currentTime - lastShot)
        lastShot = currentTime
      }
      
      if gameMiliSecToSec >= TimeInterval(1.0) {
        gameTimer += 1
        gameMiliSecToSec = 0
      } else {
        gameMiliSecToSec += currentTime - lastUpdateTime
      }
      
      if isShootable && !shots.isEmpty && cpuEnabled{
        
        let shoot = shots.removeFirst()
        shoot()
      }
      
      moveBullets()
      gameOver()
      lastUpdateTime = currentTime
    }
  }
  
  
  // MARK: - Initialization methods
  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 71.0/40.0 // iPhone 5"
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
    self.setup()
  }
  
  func setup(){
    let group = DispatchGroup()
    gameState = GameState.loading
//    self.loadingScreen()
    
    GlobalRellikConcurrent.async(group: group, execute:{
    self.setupData()
    self.setupLevel()
    self.setupPlayer()
    self.setupUI()
    })
    group.notify(queue: GlobalRellikSerial, execute:{
    self.loadLevelToView()
//      self.removeLoadingScreen()
    })
  }
  
  func restartGame(){
    //    setupPlayer()
    self.removeAllChildren()
    self.setup()
    //    self.bulletsInField = []
    //    self.playGameBackgroundMusic()
    //    setupData()
  }
  
  func setupPlayer(){
    createActions()
    createPlayer()
  }
  
  func setupLevel(){
    self.setPhysics()
    self.setBackground()
    self.createBlocks()
    self.createPlayerBlock()
    self.createSwipeRecognizers()
    //    setGameLights()
    //    particleCreator()
    
  }
  ///Adds all child nodes to view
  func loadLevelToView(){
    GlobalMainQueue.async {
    //Loads background
    self.addChild(self.backgroundNode)
    //sleep(10)(10)
    //Loads enemy blocks
    for i in 0...4 {
    self.addChild(self.leftBoxes[i])
    self.addChild(self.rightBoxes[i])
    self.addChild(self.upBoxes[i])
    self.addChild(self.downBoxes[i])
    }
      //sleep(10)(10)
    //Set player block
    self.addChild(self.playerBlock)

      //sleep(10)(10)
    //Sets up player
    self.addChild(self.player)
    self.playGameBackgroundMusic()
    
      //sleep(10)(10)
    //Sets labels
    self.addChild(self.gameName)
    self.addChild(self.killBoardLabel)
    self.addChild(self.scoreBoardLabel)
    self.addChild(self.errorsBoardLabel)
    self.addChild(self.highScoreBoardLabel)
    self.addChild(self.timerBoardLabel)
      
      //sleep(10)(10)
    //Sets debug levels
    self.addChild(self.gameSpeedBoardLabel)
    self.addChild(self.waitTimeBoardLabel)
    
      //sleep(10)(10)
    //After everything is loaded
    gameState = GameState.playing
    }
  }
  func loadingScreen(){
    //Create view
//    loadingViewNode = SKNode.init()
    self.backgroundColor = UIColor.white
    //Create label
    textLabel = SKLabelNode(fontNamed:"Chalkduster")
    textLabel.text = "Loading..."
    textLabel.name = "loading label"
    textLabel.color = SKColor.gray
    textLabel.fontSize = 50
    textLabel.position =  CGPoint(x: (self.playableRect.width) / 2 + (textLabel.frame.size.width / 2), y: (self.playableRect.height) / 2)
    textLabel.zPosition = 100
    textLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    
    //Add label to view
    loadingViewNode.addChild(textLabel)
    
    self.addChild(loadingViewNode)
    
    
  }
  
  func removeLoadingScreen(){
    loadingViewNode.removeAllChildren()
    removeChildren(in: [loadingViewNode])
  }
  
  func setupUI(){
    setLabels()
    debugDrawPlayableArea()
    setDebugLabels()
  }
  
  func setupData(){
    highScoreSetup()
  }
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Contact Methods
  func setPhysics() {
//    GlobalBackgroundQueue.sync {
      self.physicsWorld.contactDelegate = self
      self.physicsWorld.gravity = CGVector(dx: CGFloat(0), dy: CGFloat(0))
//    }
  }
  func didBegin(_ contact: SKPhysicsContact) {
    let firstNode = contact.bodyA.node as! Entity
    let secondNode = contact.bodyB.node as! Entity
    
    if (contact.bodyA.categoryBitMask == PhysicsCategory.Player) &&
      (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) {
      firstNode.hurt()
      secondNode.kill()
    }
    
    if (contact.bodyB.categoryBitMask == PhysicsCategory.Player) &&
      (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) {
      secondNode.hurt()
      firstNode.kill()
    }
    
    if (contact.bodyA.categoryBitMask == PhysicsCategory.Enemy) &&
      (contact.bodyB.categoryBitMask == PhysicsCategory.Bullet) {
      firstNode as! Enemy
      //      secondNode.removeAction(forKey: "move")
      secondNode.kill()
      firstNode.hurt()
    }
    
    if (contact.bodyB.categoryBitMask == PhysicsCategory.Enemy) &&
      (contact.bodyA.categoryBitMask == PhysicsCategory.Bullet) {
      secondNode as! Enemy
      //      firstNode.removeAction(forKey: "move")
      
      firstNode.kill()
      secondNode.hurt()
    }
  }
  
  
  // MARK: - Player and Bullets Methods
  func createPlayer() {
    self.player = Player(entityPosition: CGPoint(x: playableRect.midX, y: playableRect.midY + 20))
  }
  
  
@objc func enableCPU(){
  cpuEnabled = !cpuEnabled
}
@objc func shotDirection(_ sender: UISwipeGestureRecognizer) {
  if isShootable && !isGamePaused {
    let newBullet = Bullet(entityPosition: CGPoint(x: playableRect.midX, y: playableRect.midY))
    
    switch sender.direction {
    case UISwipeGestureRecognizerDirection.right:
      newBullet.directionOf = entityDirection.right
      //        newBullet.setAngle()
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
    //      player.setAngle()
  }
}
  
  @objc func shotDirectionSuper(_ sender: UISwipeGestureRecognizer) {
    if isShootable && !isGamePaused {
      let newBullet = SuperBullet(entityPosition: CGPoint(x: playableRect.midX, y: playableRect.midY))
      
      switch sender.direction {
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
    }
  }
func particleCreator() {
//  GlobalRellikSerial.async {
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
    self.addChild(emitterNOde)
//  }
}


// MARK: - Block creator Methods
func createPlayerBlock() {
//  let group = DispatchGroup()
//  let playerBlockLight = SKLightNode()
  
//  group.enter()
  
//  GlobalRellikConcurrent.async {
    self.playerBlock = SKSpriteNode(imageNamed: "stone")
    self.playerBlock.name = "playerBlock"
    self.playerBlock.color = SKColor.red
    self.playerBlock.colorBlendFactor = 1.0
    self.playerBlock.position = CGPoint(x: self.horizontalXAxis, y: self.verticalAxis)
    self.playerBlock.setScale(playerBlockScale)
    self.playerBlock.texture?.filteringMode = .nearest
    self.playerBlock.texture!.generatingNormalMap(withSmoothness: 0.5, contrast: 1.0)
//    self.playerBlock.lightingBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.up | BitMaskOfLighting.down
  
    //      playerBlockLight.categoryBitMask = BitMaskOfLighting.left | BitMaskOfLighting.right | BitMaskOfLighting.down | BitMaskOfLighting.up
    //      playerBlockLight.isEnabled = true
    //      playerBlockLight.position = self.playerBlock.position
    //      playerBlockLight.falloff = 1.0
    //      playerBlockLight.ambientColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)// SKColor.yellowColor()
    //      playerBlockLight.lightColor = SKColor(white: 0.1, alpha: 1.0)
//    group.leave()
//  }
  
//  group.notify(queue: .main){
  
//  }
}

func createBlocks() {
    for i in 0...4 {
      
      self.leftBoxes.append(SKSpriteNode(imageNamed: "horizontal-block"))
      self.rightBoxes.append(SKSpriteNode(imageNamed: "horizontal-block"))
      self.upBoxes.append(SKSpriteNode(imageNamed: "center-block"))
      if i == 4{
      self.downBoxes.append(SKSpriteNode(imageNamed: "horizontal-block"))
      }else{
      self.downBoxes.append(SKSpriteNode(imageNamed: "center-block"))
      }
      self.leftBoxes[i].position = CGPoint(x: self.horizontalXAxis - self.self.pointBetweenBlocks, y: self.verticalAxis)
      self.rightBoxes[i].position = CGPoint(x: self.self.horizontalXAxis + self.self.pointBetweenBlocks, y: self.verticalAxis)
      self.upBoxes[i].position = CGPoint(x: self.horizontalXAxis, y: self.verticalAxis  + self.pointBetweenBlocks)
      if i == 4{
        self.downBoxes[i].position = CGPoint(x: self.horizontalXAxis, y: self.verticalAxis  - self.pointBetweenBlocks * 1.05)
      }else{
        self.downBoxes[i].position = CGPoint(x: self.horizontalXAxis, y: self.verticalAxis  - self.pointBetweenBlocks)
      }
      
      self.leftBoxes[i].setScale(enemyBlockScale)
      self.rightBoxes[i].setScale(enemyBlockScale)
      self.downBoxes[i].setScale(enemyBlockScale)
      self.upBoxes[i].setScale(enemyBlockScale)
      
      self.leftBoxes[i].texture!.generatingNormalMap(withSmoothness: 1.0, contrast: 1.0)
      self.rightBoxes[i].texture!.generatingNormalMap(withSmoothness: 0.0, contrast: 0.0)
      self.downBoxes[i].texture!.generatingNormalMap(withSmoothness: 0.3, contrast: 0.6)
      self.upBoxes[i].texture!.generatingNormalMap(withSmoothness: 1.0, contrast: 0.0)
      
      //        self.leftBoxes[i].lightingBitMask = BitMaskOfLighting.left
      //        self.rightBoxes[i].lightingBitMask = BitMaskOfLighting.right
      //        self.downBoxes[i].lightingBitMask = BitMaskOfLighting.down
      //        self.upBoxes[i].lightingBitMask = BitMaskOfLighting.up
      
      self.pointBetweenBlocks += incrementalSpaceBetweenBlocks
    }
  }



// MARK: - Actions
func playGameBackgroundMusic() {
  GlobalRellikSFXConcurrent.async {
    playBackgroundMusic("backgroundMusic.mp3")
  }
}


// MARK: - Other Game Scenes Methods
func createGameOverScene(_ won: Bool) {
  backgroundMusicPlayer.stop()
  let gameOverScene = GameOverScene(size: size, won: won)
  gameOverScene.scaleMode = scaleMode
  
  let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
  
  view?.presentScene(gameOverScene, transition: reveal)

  }
}


//MARK: - SceneUpdateProtocol
extension GameScene:SceneUpdateProtocol{
  func killCountUpdate() {
    GlobalRellikConcurrent.sync {
      self.killed += 1
    }
  }
  
  func pointCountUpdate(points: Int) {
    GlobalRellikConcurrent.sync {
      self.score += points
    }
  }
  
  func errorCountUpdate() {
    GlobalRellikConcurrent.sync {
      self.errors += 1
    }
  }
}


//MARK: - Enemies
extension GameScene{
  // MARK: - MARK: Enemies Methods
  func moveEnemies() {
//    let group = DispatchGroup()
    
    
      for monstor in self.monstorsInField {
//        GlobalRellikEnemyConcurrent.async(group: group, flags:.barrier){ [weak self] in
//          group.enter()
          if(!monstor.isDead) {
          monstor.moveFunc()
        }
//      group.leave()
//        }
    }
//    group.notify(queue: GlobalRellikEnemyConcurrent){
      self.monstorsInField = self.monstorsInField.filter({!$0.isDead})
//    }
  }
  
  func spawnEnemy() {
//    GlobalRellikEnemySerial.async(flags: .barrier) {
    let randomNum = Int.random(min: 1, max: 4)
    var enemy: Enemy!
    
    switch randomNum {
    case 1:
      enemy = self.randomEnemy(self.rightSideEnemyStartPosition, delegate: self)
      enemy.directionOf = .right
    case 2:
      enemy = self.randomEnemy(self.leftSideEnemyStartPosition, delegate: self)
      enemy.directionOf = .left
    case 3:
      enemy = self.randomEnemy(self.upSideEnemyStartPosition, delegate: self)
      enemy.directionOf = .up
    case 4:
      enemy = self.randomEnemy(self.downSideEnemyStartPosition, delegate: self)
      enemy.directionOf = .down
    case 5:
    return//This doesn't send out an enemy
    default:
      assertionFailure("out of bounds Spawn enemy")
    }
    enemy.entityCurrentBlock = blockPlace.fifth
    self.monstorsInField.append(enemy)
      self.shots += (self.shot(enemyDirection: enemy.directionOf, num: enemy.maxHealth))
    
    self.addChild(enemy)
//    }
  }
  func randomEnemy(_ enemyLocation: CGPoint, delegate: SceneUpdateProtocol) -> Enemy {
    let randomNum = Int.random(min: 1, max: 10)
    
//    GlobalRellikEnemySerial.async {
      //      self.run(SKAction.playSoundFileNamed("spawn.wav", waitForCompletion: false))
    
    switch randomNum {
    case 1:
      return Boss(entityPosition: enemyLocation, delegate: self)
    case 2...5:
      return Soldier(entityPosition: enemyLocation, delegate: self)
    case 5...10:
      return Minion(entityPosition: enemyLocation, delegate: self)
    case 11:
      return Ghost(entityPosition: enemyLocation, delegate: self)
    default:
      assertionFailure("out of bounds Spawn enemy")
      return Minion(entityPosition: enemyLocation, delegate: self)
//    }
    }
  }
  
  func shot(enemyDirection: entityDirection, num: Int) -> [() -> ()]{
    var blocks:[()->()] = []
    
    switch enemyDirection {
    case .down:
      for _ in 1...num {
        blocks.append{[weak self] in
          let newBullet = Bullet(entityPosition: CGPoint(x: (self?.playableRect.midX)!, y: (self?.playableRect.midY)!))
          newBullet.directionOf = enemyDirection
          newBullet.move = self?.bulletMoveDownAction
          self?.addChild(newBullet)
          self?.bulletsInField.append(newBullet)
          self?.isShootable = false
          self?.player.directionOf = enemyDirection
        }
      }
    case .left:
      for _ in 1...num {
        blocks.append{[weak self] in
          let newBullet = Bullet(entityPosition: CGPoint(x: (self?.playableRect.midX)!, y: (self?.playableRect.midY)!))
          newBullet.directionOf = enemyDirection
          newBullet.move = self?.bulletMoveLeftAction
          self?.addChild(newBullet)
          self?.bulletsInField.append(newBullet)
          self?.isShootable = false
          self?.player.directionOf = enemyDirection
        }
      }
      
    case .right:
      for _ in 1...num {
        blocks.append{[weak self] in
          let newBullet = Bullet(entityPosition: CGPoint(x: (self?.playableRect.midX)!, y: (self?.playableRect.midY)!))
          newBullet.directionOf = enemyDirection
          newBullet.move = self?.bulletMoveRightAction
          self?.addChild(newBullet)
          self?.bulletsInField.append(newBullet)
          self?.isShootable = false
          self?.player.directionOf = enemyDirection
        }
      }
    case .up:
      for _ in 1...num {
        blocks.append{[weak self] in
          let newBullet = Bullet(entityPosition: CGPoint(x: (self?.playableRect.midX)!, y: (self?.playableRect.midY)!))
          newBullet.directionOf = enemyDirection
          newBullet.move = self?.bulletMoveUpAction
          self?.addChild(newBullet)
          self?.bulletsInField.append(newBullet)
          self?.isShootable = false
          self?.player.directionOf = enemyDirection
        }
      }
    case .unSelected:
      assertionFailure()
    }
    
    return blocks
  }
}


//MARK: - bullets
extension GameScene{
  func moveBullets() {
//    let group = DispatchGroup()
    
//    GlobalRellikBulletConcurrent.async {
    self.bulletsInField.map{bullet in
//      GlobalRellikBulletConcurrent.async(group: group, flags: .barrier){[weak self] in
//            group.enter()
        bullet as Bullet?
        if !(bullet?.isShot)! {
          bullet?.moveFunc()
        }
          if ((bullet?.stopped)! == true)
          { self.errorCountUpdate() }
//          group.leave()
//      }
    }
    
//    group.notify(queue: GlobalRellikBulletConcurrent){[weak self] in
    
      self.bulletsInField = (self.bulletsInField.filter({$0?.isDead == false}))
//    }
//    }
  }
}


//MARK: - timer
extension GameScene{
  func setGameTimeLabel() {
    
    waitTimeBoardLabel.text = String("Game Speed: \(gameSpeed)")
    //waitTimeBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
    //  SKAction.scaleTo(1, duration: 0.1)]))
  }
  
  func setWaitTimeLabel() {
    
    gameSpeedBoardLabel.text = String("Wait Time: \(enemyWaitTime)")
    // gameSpeedBoardLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.1),
    // SKAction.scaleTo(1, duration: 0.1)]))
  }
  
  func convertGameTimer(_ timeToConvert: Int) -> String {
    var total = 0
    var min = 0
    var sec = 0
    
    for _ in 0..<timeToConvert {
      total += 1
      if total == 60 {
        total = 0
        min += 1
      }
    }
    sec = total
    return String("\(min):\(sec)")
  }
  
  @objc func paused() {
    isGamePaused = !isGamePaused
  }
  
}


//MARK: - Labels
extension GameScene{
  fileprivate func setBackground() {
    GlobalRellikSerial.async {
    var imageString = "blueAndRedGalaxy"
    self.backgroundNode = SKSpriteNode(imageNamed: imageString)
    self.backgroundNode.size = self.playableRect.size
    self.backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    self.backgroundNode.position = CGPoint(x: self.playableRect.width/2, y: self.playableRect.height/2)
      self.backgroundNode.zPosition = -1
    
    self.backgroundNode.texture?.generatingNormalMap(withSmoothness: 1.0, contrast: 0.0)
  }
  }
  
  func setLabels() {
    
    
    scoreBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    scoreBoardLabel.name = "scoreBoard"
    score = 0
    scoreBoardLabel.text = String("Score: \(score)")
    scoreBoardLabel.color = SKColor.red
    scoreBoardLabel.fontSize = 30
    scoreBoardLabel.position =  CGPoint(x: horizontalXAxis * 1.8, y: verticalAxis * 1.8)
    scoreBoardLabel.zPosition = 100
    scoreBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    scoreBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    
    highScoreBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    highScoreBoardLabel.name = "highscoreBoard"
    highscores = 0
    highScoreBoardLabel.text = String("HighScore: \(highscores)")
    highScoreBoardLabel.color = SKColor.red
    highScoreBoardLabel.fontSize = 30
    highScoreBoardLabel.position = CGPoint(x: horizontalXAxis * 1.8, y: verticalAxis * 0.8)
    highScoreBoardLabel.zPosition = 100
    highScoreBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    highScoreBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
    
    killBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    killBoardLabel.name = "killBoard"
    killed = 0
    killBoardLabel.text = String("Killed: \(killed)")
    killBoardLabel.color = SKColor.red
    killBoardLabel.fontSize = 30
    killBoardLabel.position = CGPoint(x: horizontalXAxis * 0.10, y: verticalAxis * 1.8)
    killBoardLabel.zPosition = 100
    killBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    killBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    
    errorsBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    errorsBoardLabel.name = "errorsBoaard"
    errors = 0
    errorsBoardLabel.text = String("Errors: \(errors)")
    errorsBoardLabel.color = SKColor.red
    errorsBoardLabel.fontSize = 30
    errorsBoardLabel.position = CGPoint(x: horizontalXAxis * 0.10, y: verticalAxis * 0.8)
    errorsBoardLabel.zPosition = 100
    errorsBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    errorsBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    
    gameName = SKLabelNode(fontNamed:"Chalkduster")
    gameName.text = "relliK"
    gameName.color = SKColor.red
    gameName.fontSize = 75
    gameName.position = CGPoint(x:horizontalXAxis, y:playableRect.maxY - gameName.frame.size.height)
    
    timerBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    timerBoardLabel.name = "errorsBoaard"
    gameTimer = 0
    timerBoardLabel.text = String("0:0")
    timerBoardLabel.color = SKColor.red
    timerBoardLabel.fontSize = 30
    timerBoardLabel.position = CGPoint(x:horizontalXAxis, y:playableRect.maxY - (timerBoardLabel.frame.size.height + gameName.frame.size.height) )
    timerBoardLabel.zPosition = 100
    timerBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    timerBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
  }
  func setDebugLabels() {
    gameSpeedBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    gameSpeedBoardLabel.name = "gameSpeedBoaard"
    gameSpeedBoardLabel.text = String("Game Speed: 0:0")
    gameSpeedBoardLabel.color = SKColor.red
    gameSpeedBoardLabel.fontSize = 20
    gameSpeedBoardLabel.fontColor = SKColor.red
    gameSpeedBoardLabel.position = CGPoint(x: horizontalXAxis * 1.25, y: verticalAxis * 1.8 - gameSpeedBoardLabel.frame.height*2)
    gameSpeedBoardLabel.zPosition = 100
    gameSpeedBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    gameSpeedBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    
    waitTimeBoardLabel = SKLabelNode(fontNamed:"Chalkduster")
    waitTimeBoardLabel.name = "waitTimeBoaard"
    waitTimeBoardLabel.text = String("Wait:0:0")
    waitTimeBoardLabel.color = SKColor.red
    waitTimeBoardLabel.fontSize = 20
    waitTimeBoardLabel.fontColor = SKColor.red
    waitTimeBoardLabel.position = CGPoint(x: horizontalXAxis * 0.60, y: verticalAxis * 1.8 - waitTimeBoardLabel.frame.height*2)//CGPoint(x:horizontalXAxis * 1.30, y:CGRectGetMidY(playableRect) + (waitTimeBoardLabel.frame.height * 2) )
    waitTimeBoardLabel.zPosition = 100
    waitTimeBoardLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    waitTimeBoardLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
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
}


//MARK: - Controls
extension GameScene{
  func createActions() {
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
  func createSwipeRecognizers() {
    //1 finger swipe
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeDown.direction = UISwipeGestureRecognizerDirection.down
    
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    
    
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeUp.direction = UISwipeGestureRecognizerDirection.up
    
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirection(_:)))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    
    
    //2 finger swipe
    let swipeDownTwoFinger = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirectionSuper(_:)))
    swipeDown.direction = UISwipeGestureRecognizerDirection.down
    swipeDown.numberOfTouchesRequired = 2
    
    
    let swipeRightTwoFinger = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirectionSuper(_:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    swipeRight.numberOfTouchesRequired = 2
    
    
    let swipeUpTwoFinger = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirectionSuper(_:)))
    swipeUp.direction = UISwipeGestureRecognizerDirection.up
    swipeUp.numberOfTouchesRequired = 2
    
    
    let swipeLeftTwoFinger = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.shotDirectionSuper(_:)))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    swipeLeft.numberOfTouchesRequired = 2
    
    
    //Taps
    let doubleTapped = UITapGestureRecognizer(target: self, action: #selector(GameScene.paused as (GameScene) -> () -> Void))
    doubleTapped.numberOfTapsRequired = 1
    doubleTapped.numberOfTouchesRequired = 3
    
    let pressDown = UILongPressGestureRecognizer(target: self, action: #selector(GameScene.enableCPU))
    pressDown.minimumPressDuration = TimeInterval(1000)
    pressDown.numberOfTapsRequired = 1
    pressDown.numberOfTouchesRequired = 1
    
    
    let trippleTapped = UITapGestureRecognizer(target: self, action: #selector(GameScene.enableCPU))
    trippleTapped.numberOfTapsRequired = 1
    trippleTapped.numberOfTouchesRequired = 4
    
    //Adds gesture recognizer to view
    GlobalMainQueue.async {
    self.view?.addGestureRecognizer(swipeDown)
    self.view?.addGestureRecognizer(swipeRight)
    self.view?.addGestureRecognizer(swipeUp)
    self.view?.addGestureRecognizer(swipeLeft)
    self.view?.addGestureRecognizer(swipeDownTwoFinger)
    self.view?.addGestureRecognizer(swipeRightTwoFinger)
    self.view?.addGestureRecognizer(swipeUpTwoFinger)
    self.view?.addGestureRecognizer(swipeLeftTwoFinger)
    self.view?.addGestureRecognizer(doubleTapped)
    self.view?.addGestureRecognizer(pressDown)
    self.view?.addGestureRecognizer(trippleTapped)
    }
  }
}

