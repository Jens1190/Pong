import UIKit
import SpriteKit
import MultipeerConnectivity


class GameViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, MCAdvertiserAssistantDelegate {
    
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    var firstFlag : Bool = false
    var isServer:Bool = false
    
    var scene:GameScene?
    
    var stream:NSOutputStream?
    var error : NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size, viewController: self)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene?.scaleMode = .ResizeFill
        skView.presentScene(scene!)
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        self.browser.maximumNumberOfPeers = 2
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        self.assistant.delegate = self;
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
    }
    
    func sendData(data: String) {
        let msg = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        stream?.write(UnsafePointer<UInt8>(msg.bytes), maxLength: msg.length)
                print(msg.length)

        if error != nil {
            //println("Error: \(error?.localizedDescription)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(firstFlag == false){
            self.presentViewController(self.browser, animated: true, completion: nil)
        }
        firstFlag = true
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession, didReceiveData data: NSData,
        fromPeer peerID: MCPeerID)  {
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
            
            // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        atURL localURL: NSURL, withError error: NSError?)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream,
        withName streamName: String, fromPeer peerID: MCPeerID)  {
            // Called when a peer establishes a stream with us
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                stream.open()
                
                let bufferSize = 11
                var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
                
                while(true) {
                    let bytesRead = stream.read(&buffer, maxLength: bufferSize)
                    if bytesRead >= 0 {
                        let output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)
                        if ((output?.containsString(";")) != nil) {
                            print("\(output!)")
                            var element = output!.componentsSeparatedByString(";")
                            self.scene?.setBallPosition(element[0] as String, y: element[1] as String)
                        }
                    }
                }
            }
    }

    func advertiserAssistantWillPresentInvitation(advertiserAssistant: MCAdvertiserAssistant) {
        print("Ich bin der Server")
        isServer = true
        scene!.ball?.addPhysicsBody()
        
        browser!.browser!.stopBrowsingForPeers()
    }
    
    func session(session: MCSession, peer peerID: MCPeerID,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
            do {
                if (state.rawValue == 2 && isServer) {
                    try stream = self.session.startStreamWithName("client", toPeer: self.session.connectedPeers[0] as MCPeerID)
                    stream?.open()
                    
                    print("Connection to server successful")
                }
            } catch {
                print(error)
            }
    }
}