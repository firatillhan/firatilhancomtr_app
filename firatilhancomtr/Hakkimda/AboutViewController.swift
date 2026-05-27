

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
        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            aboutTitle.text = viewModel.title
            aboutContent.text = viewModel.content
        }
        
        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }
}


