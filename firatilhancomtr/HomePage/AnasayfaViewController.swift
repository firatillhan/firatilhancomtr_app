
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
        let url = "https://\(Bundle.main.addURL)?action=foto_ekle"
        print("URL: \(url)")
    }
    
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            anasayfaBaslik.text = viewModel.baslik
            anasayfaIcerik.text = viewModel.icerik
            anasayfaFoto.sd_setImage(with: viewModel.fotoURL)
        }
        
        viewModel.onError = { hata in
            print("Hata: \(hata)")
        }
    }
}


