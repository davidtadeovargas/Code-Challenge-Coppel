import UIKit

class MovieDetailViewController: UIViewController {
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .green
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Permite múltiples líneas
        label.textColor = .white
        return label
    }()
    
    let voteCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yellow
        return label
    }()
    
    let adultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let popularityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yellow
        return label
    }()
    
    var resultResponse: ResultResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        // Agregar las vistas a la vista principal.
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(voteCountLabel)
        view.addSubview(adultLabel)
        view.addSubview(popularityLabel)
        
        // Configurar constraints
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            voteCountLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            voteCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            adultLabel.topAnchor.constraint(equalTo: voteCountLabel.bottomAnchor, constant: 10),
            adultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            popularityLabel.topAnchor.constraint(equalTo: adultLabel.bottomAnchor, constant: 10),
            popularityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        // Configurar la interfaz de usuario con los datos de la película.
        if let resultResponse_ = resultResponse {
            let imageURLString = Constants.MOVIE_IMAGES_ENDPOINT + resultResponse_.poster_path
            if let imageURL = URL(string: imageURLString) {
                // Cargar la imagen de forma asíncrona utilizando URLSession
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    if let error = error {
                        print(String(localized: "Error_al_cargar_la_imagen") + ": \(error.localizedDescription)")
                        return
                    }

                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async { [self] in
                            // Actualizar la vista en el hilo principal con la imagen cargada
                            posterImageView.image = image
                        }
                    }
                }.resume()
            } else {
                // Si la URL de la imagen no se puede construir, puedes configurar una imagen de marcador de posición o manejarla de otra manera
                posterImageView.image = UIImage(named: "placeholder")
            }
            
            titleLabel.text = resultResponse_.original_title
            overviewLabel.text = resultResponse_.overview
            voteCountLabel.text = String(localized: "Votos") + ": \(resultResponse_.vote_average)"
            adultLabel.text = resultResponse_.adult ? String(localized: "Para_adultos") + ": " + String(localized: "Yes") : String(localized: "Para_adultos") + ": " + String(localized: "No")
            popularityLabel.text = String(localized: "Popularidad") + ": \(resultResponse_.popularity)"
        }
    }
}
