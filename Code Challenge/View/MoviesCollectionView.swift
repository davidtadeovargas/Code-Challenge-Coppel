import UIKit

class MoviesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    private let itemsPerRow: CGFloat = 2

    private var results:[ResultResponse] = []
    private var currentPage:Int32 = 0
    private var isLoadingData = false
    private var endpoint:String?
    
    init(endpoint:String) {
        
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .black
        
        // Configura el dataSource y el delegate aquí
        self.dataSource = self
        self.delegate = self
        
        self.register(MovieViewGridCell.self, forCellWithReuseIdentifier: "MovieViewGridCell")
        
        self.endpoint = endpoint
        // Carga los datos iniciales
        loadData(currentPage: self.currentPage + 1)
    }

    func loadData(currentPage:Int32) {
        
        self.isLoadingData = true
        
        self.currentPage = currentPage
        
        let moviesRequest = MoviesRequest(onSuccess: { resultsResponse in
                    
            DispatchQueue.main.async { [self] in
                
                self.results.append(contentsOf: resultsResponse!.results)
                
                self.isLoadingData = false
                
                // Llama a reloadData() para actualizar la UICollectionView
                self.reloadData()
            }
            
        }, onError: { error in
            
        })
        moviesRequest.endpoint = self.endpoint
        moviesRequest.page = currentPage
        moviesRequest.request()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String(localized: "init_implemented"))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieViewGridCell", for: indexPath) as! MovieViewGridCell
        let data = results[indexPath.item]

        cell.titleLabel.text = data.original_title
        cell.dateLabel.text = data.release_date
        cell.descriptionLabel.text = data.overview

        // Construye la URL completa de la imagen
        let imageURLString = Constants.MOVIE_IMAGES_ENDPOINT + data.poster_path
        if let imageURL = URL(string: imageURLString) {
            // Cargar la imagen de forma asíncrona utilizando URLSession
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print(String(localized: "Error_al_cargar_la_imagen") + ": \(error.localizedDescription)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Actualizar la vista en el hilo principal con la imagen cargada
                        cell.imageView.image = image
                    }
                }
            }.resume()
        } else {
            // Si la URL de la imagen no se puede construir, puedes configurar una imagen de marcador de posición o manejarla de otra manera
            cell.imageView.image = UIImage(named: "placeholder")
        }
    
        return cell
    }

    // Implementa la función para manejar la selección de elementos
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Obtén la película seleccionada
        let selectedMovie = results[indexPath.item]
        
        // Crea una instancia de MovieDetailViewController
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.resultResponse = selectedMovie
        
        // Presenta el MovieDetailViewController
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(movieDetailVC, animated: true, completion: nil)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 4
        let availableWidth = collectionView.frame.width - padding * (itemsPerRow + 1)
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth * 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Verifica si el usuario ha llegado al final de la lista
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            // El usuario ha llegado al final de la lista
            loadMoreData()
        }
    }

    func loadMoreData() {
        
        // Evita la carga repetida de datos
        guard !isLoadingData else {
            return
        }

        loadData(currentPage: self.currentPage + 1)
    }
}
