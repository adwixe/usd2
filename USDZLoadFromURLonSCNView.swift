class ViewController: UIViewController,URLSessionDownloadDelegate {
    
    @IBOutlet weak var scnView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadSceneTask()
    }
    
    
    func downloadSceneTask(){
        
        //1. Get The URL Of The SCN File
        guard let url = URL(string: "https://devimages-cdn.apple.com/ar/photogrammetry/AirForce.usdz") else { return }
        
        //2. Create The Download Session
        let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: nil)
        
        //3. Create The Download Task & Run It
        let downloadTask = downloadSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        //1. Create The Filename
        let fileURL = getDocumentsDirectory().appendingPathComponent("teapot.usdz")
        
        //2. Copy It To The Documents Directory
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)
            
            print("Successfuly Saved File \(fileURL)")
            
            //3. Load The Model
            loadModel()
            
        } catch {
            
            print("Error Saving: \(error)")
            loadModel()
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
    }
    
    func loadModel(){
        
        //1. Get The Path Of The Downloaded File
        let downloadedScenePath = getDocumentsDirectory().appendingPathComponent("teapot.usdz")
        
        self.scnView.autoenablesDefaultLighting=true
        self.scnView.showsStatistics=true
        self.scnView.backgroundColor = UIColor.blue
        let asset = MDLAsset(url: downloadedScenePath)
        let scene = SCNScene(mdlAsset: asset)
        self.scnView.scene=scene
        self.scnView.allowsCameraControl=true
    }
}