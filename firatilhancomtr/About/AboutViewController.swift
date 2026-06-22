

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTitle: UILabel!
    @IBOutlet weak var aboutContent: UILabel!
    
    private let viewModel = AboutViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchAbout()
    }
    
    private func bindViewModel() {
        
        viewModel.onStateChanged = { state in
            switch state {
            case .success:
                self.ekraniGuncelle()
            case .error(let message):
                print(message)
                
            }
        }
    }
    
    private func ekraniGuncelle() {
        aboutTitle.text = viewModel.title
        aboutContent.text = viewModel.content
    }
}


