import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var ball: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var score = 0

    private var dragStart: CGPoint?

    override func didMove(to view: SKView) {

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self

        backgroundColor = .white

        // Ball
        ball = SKSpriteNode(color: .orange, size: CGSize(width: 50, height: 50))
        ball.position = CGPoint(x: size.width / 2, y: 120)

        ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        ball.physicsBody?.restitution = 0.7
        ball.physicsBody?.friction = 0.2

        addChild(ball)

        // Backboard
        let backboard = SKSpriteNode(color: .gray,
                                     size: CGSize(width: 10, height: 120))
        backboard.position = CGPoint(x: size.width - 60,
                                     y: size.height * 0.7)

        backboard.physicsBody = SKPhysicsBody(rectangleOf: backboard.size)
        backboard.physicsBody?.isDynamic = false

        addChild(backboard)

        // Rim
        let rim = SKSpriteNode(color: .red,
                               size: CGSize(width: 70, height: 8))

        rim.position = CGPoint(x: size.width - 100,
                               y: size.height * 0.65)

        rim.physicsBody = SKPhysicsBody(rectangleOf: rim.size)
        rim.physicsBody?.isDynamic = false

        addChild(rim)

        // Score Sensor
        let sensor = SKNode()
        sensor.position = CGPoint(x: rim.position.x,
                                  y: rim.position.y - 20)

        sensor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60,
                                                               height: 10))
        sensor.physicsBody?.isDynamic = false
        sensor.physicsBody?.categoryBitMask = 2
        sensor.physicsBody?.contactTestBitMask = 1

        addChild(sensor)

        // Ball category
        ball.physicsBody?.categoryBitMask = 1

        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: size.width/2,
                                      y: size.height - 80)

        scoreLabel.text = "Score: 0"

        addChild(scoreLabel)
    }

    // MARK: Touches

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {

        guard let touch = touches.first else { return }

        dragStart = touch.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {

        guard let touch = touches.first,
              let start = dragStart else { return }

        let end = touch.location(in: self)

        let dx = start.x - end.x
        let dy = start.y - end.y

        ball.physicsBody?.velocity = .zero

        ball.physicsBody?.applyImpulse(
            CGVector(dx: dx * 0.12,
                     dy: dy * 0.12)
        )
    }

    // MARK: Score

    func didBegin(_ contact: SKPhysicsContact) {

        score += 1
        scoreLabel.text = "Score: \(score)"
    }
} 
