
import UIKit
import SDWebImage

class AnasayfaViewController: UIViewController {

    @IBOutlet weak var anasayfaFoto: UIImageView!
    @IBOutlet weak var anasayfaBaslik: UILabel!
    @IBOutlet weak var anasayfaIcerik: UILabel!
    
    private let viewModel = AnasayfaViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchAnasayfa()
    }

    
    private func bindViewModel(){
        viewModel.onStateChanged = { [weak self] state in
                switch state {
                case .success:
                    self!.ekraniGuncelle()
                case .error(let message):
                    print(message)
            }
        }
        viewModel.fetchAnasayfa()

    }
    
    private func ekraniGuncelle(){
        anasayfaBaslik.text = viewModel.baslik
        anasayfaIcerik.text = viewModel.icerik
        anasayfaFoto.sd_setImage(with: viewModel.fotoURL)
    }
    
    
}


