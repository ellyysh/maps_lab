//
//  ViewController.swift
//  maps
//
//  Created by Mishel on 29.01.2024.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // установка текущего местоположения
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        // настройка делегата для текстового поля поиска
        searchTextField.delegate = self
    }
    
    //  добавление маркера на карту
    func addAnnotation(title: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    // отображение информации о месте при нажатии на маркер
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let alertController = UIAlertController(title: annotation.title!!, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // поиск мест на карте
    func searchPlaces(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Ошибка", message:"Возникла ошибка, попробуйте еще раз", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print(error)
                return
            }



            if let response = response, !response.mapItems.isEmpty {
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for item in response.mapItems {
                    self.addAnnotation(title: item.name ?? "", coordinate: item.placemark.coordinate)
                }
                
                let region = MKCoordinateRegion(center: response.mapItems[0].placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // обработка нажатия кнопки "Search"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let query = textField.text {
            searchPlaces(query: query)
        }
        return true
    }
} // симулятор на ноуте не дает доступ к гео и автоматически ставит локацию в центре мск


