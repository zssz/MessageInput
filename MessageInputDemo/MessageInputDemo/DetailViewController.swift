//
//  Created by Zsombor Szabo on 14/01/2020.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit
import MessageInput

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = self.tableView!
        scrollView.keyboardDismissMode = .interactive
        
        let messageInputView = MessageInputView(frame: .zero)
        messageInputView.hostScrollView = scrollView
        messageInputView.setup(withView: self.view)
        
        // Used to identify views during UI testing.
        scrollView.accessibilityIdentifier = "DetailScrollView"
        messageInputView.accessibilityIdentifier = "MessageInputView"
    }
    
    private var observation: NSKeyValueObservation?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Important: Call `startAutomaticallyAdjustingAdditionalSafeAreaInsets()` in `viewDidAppear(_:)` and not in `viewDidLoad()`, otherwise the keyboard interactive dismissal won't work because `view.window` is nil in `viewDidLoad()`, which is required for succesful configuration.
        if self.observation == nil {
            self.observation = self.startAutomaticallyAdjustingAdditionalSafeAreaInsets()
        }
    }
    
    deinit {
        self.stopAutomaticallyAdjustingAdditionalSafeAreaInsets(observation: self.observation)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 31
        //        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .orange
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
