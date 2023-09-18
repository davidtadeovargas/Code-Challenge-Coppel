import UIKit

class OnTvViewController: UIViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Espacio adicional en las cuatro orillas
    
    var moviesCollectionView: MoviesCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesCollectionView = MoviesCollectionView(endpoint: Constants.MOVIE_ON_TV_ENDPOINT)
        
        view.addSubview(moviesCollectionView!)
        
        NSLayoutConstraint.activate([
            moviesCollectionView!.topAnchor.constraint(equalTo: view.topAnchor, constant: sectionInsets.top),
            moviesCollectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sectionInsets.left),
            moviesCollectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sectionInsets.right),
            moviesCollectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -sectionInsets.bottom) // Espacio adicional en la parte inferior
        ])
    }
}
