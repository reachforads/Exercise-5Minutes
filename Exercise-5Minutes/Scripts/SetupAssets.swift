import Foundation

// MARK: - Asset Structure Generator
struct AssetFolderGenerator {
    // MARK: - Properties
    private let baseURL: URL
    private let categories = [
        "Chest",
        "Triceps",
        "Back",
        "Biceps",
        "Legs",
        "Shoulders",
        "Abs",
        "HIIT",
        "Yoga",
        "Rest-Walk"
    ]
    
    // MARK: - Initialization
    init(projectPath: String) {
        self.baseURL = URL(fileURLWithPath: projectPath)
            .appendingPathComponent("Exercise-5Minutes")
            .appendingPathComponent("Assets.xcassets")
            .appendingPathComponent("Exercises")
    }
    
    // MARK: - Methods
    func generateFolderStructure() throws {
        // Create base Exercises folder
        try createFolder(at: baseURL)
        print("Created Exercises folder")
        
        // Create category folders
        for category in categories {
            let categoryURL = baseURL.appendingPathComponent(category)
            try createFolder(at: categoryURL)
            print("Created \(category) folder")
            
            // Create difficulty folders (except for Rest-Walk)
            if category != "Rest-Walk" {
                let easyURL = categoryURL.appendingPathComponent("Easy")
                let hardURL = categoryURL.appendingPathComponent("Hard")
                
                try createFolder(at: easyURL)
                try createFolder(at: hardURL)
                
                // Create Contents.json for each folder
                try createContentsJSON(at: easyURL)
                try createContentsJSON(at: hardURL)
                
                print("Created Easy and Hard folders for \(category)")
            } else {
                // Create Contents.json for Rest-Walk
                try createContentsJSON(at: categoryURL)
            }
            
            // Create Contents.json for category
            try createContentsJSON(at: categoryURL)
        }
        
        // Create Contents.json for base folder
        try createContentsJSON(at: baseURL)
        
        print("✅ Asset catalog structure created successfully!")
    }
    
    private func createFolder(at url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    private func createContentsJSON(at url: URL) throws {
        let contentsJSON = """
        {
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """
        
        let contentsURL = url.appendingPathComponent("Contents.json")
        try contentsJSON.write(to: contentsURL, atomically: true, encoding: .utf8)
    }
}

// MARK: - Script Execution
do {
    let projectPath = FileManager.default.currentDirectoryPath
    let generator = AssetFolderGenerator(projectPath: projectPath)
    try generator.generateFolderStructure()
} catch {
    print("❌ Error: \(error.localizedDescription)")
} 