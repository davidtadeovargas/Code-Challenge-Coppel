import UIKit

class UserDetailsViewController: UIViewController {
    
    var sessionId:String?
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yellow
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Agregar subvistas
        view.addSubview(avatarImageView)
        view.addSubview(idLabel)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        
        // Configurar restricciones
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 300),
            avatarImageView.heightAnchor.constraint(equalToConstant: 300),
            
            idLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        loadUserDetails()
    }
    
    func loadUserDetails(){
            
        let moviesRequest = MoviesRequest(onSuccessUserDetails: { userDetailsReponse in
                    
            DispatchQueue.main.async { [self] in
                
                // Configurar contenido
                let imageURLString = Constants.MOVIE_IMAGES_ENDPOINT + (userDetailsReponse?.avatar.tmdb.avatar_path)!
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
                                avatarImageView.image = image
                            }
                        }
                    }.resume()
                } else {
                    // Si la URL de la imagen no se puede construir, puedes configurar una imagen de marcador de posición o manejarla de otra manera
                    avatarImageView.image = UIImage(named: "placeholder")
                }
                
                idLabel.text = String(localized: "ID") + ": " + String(userDetailsReponse!.id)
                nameLabel.text = String(localized: "Nombre") + ": " + userDetailsReponse!.name
                usernameLabel.text = String(localized: "Username") + ": " + userDetailsReponse!.username
            }
            
        }, onError: { error in
            
        })
        moviesRequest.endpoint = Constants.MOVIE_USER_DETAILS_ENDPOINT
        moviesRequest.request()
    }
}
