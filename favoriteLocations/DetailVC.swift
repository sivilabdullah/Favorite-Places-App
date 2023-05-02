//
//  DetailVC.swift
//  favoriteLocations
//
//  Created by abdullah's Ventura on 2.05.2023.
//
//1)ilk islem mapkit tanimlama ve delegasyon islemlerini yapma
//2)kullanicinin konumunu almak icin core location kutuphanesini import ettik
//3) location managerin delegation islemini yapiyoruz viewcontroller'a
//4) kullanicinin konumunu aldiktan sonra ne yapilacagini didupdatelocation func 'da belirtiyoruz
import UIKit
import MapKit
import CoreData
import CoreLocation /// kullanicinin konumunu almak icin
class DetailVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //Variables
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var commentTF: UITextField!
    @IBOutlet weak var placeNameTF: UITextField!
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var targetName = ""
    var targetId : UUID?
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotoinLongitude = Double()
    var annotationLatitude = Double()
    
    //functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKitView.delegate = self
    
       ///konum yoneticisi olusturuyoruz
        locationManager.delegate = self
        
        ///konumdogrulugu
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        ///uygulamayi kullandiginda konumunu almak
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        
        //pin eklemek icin geturerecognizer yapicaz
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocations(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapKitView.addGestureRecognizer(gestureRecognizer)
        
        
        if targetName != ""{
            saveBtnOutlet.isHidden = true
            //core data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request =  NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            request.returnsObjectsAsFaults = false
            
            let idString = targetId!.uuidString
            
            request.predicate = NSPredicate(format: "id = %@", idString)
            
            do{
                let results = try context.fetch(request)
                if results.count > 0 {
                   
                    for result in results as! [NSManagedObject]{
                        if let title = result.value(forKey: "title") as? String{
                           annotationTitle = title
                            if let comment = result.value(forKey: "subTitle") as? String{
                                annotationSubtitle = comment
                                if let latitude = result.value(forKey: "latitude") as? Double{
                                    annotationLatitude = latitude
                                    
                                    if let longitude = result.value(forKey: "longitude") as? Double{
                                        annotoinLongitude = longitude
                                        
                                        //adding annotation
                                        let annotation = MKPointAnnotation()
                                        annotation.title = annotationTitle
                                        annotation.subtitle = annotationSubtitle
                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotoinLongitude)
                                        annotation.coordinate = coordinate
                                        mapKitView.addAnnotation(annotation)
                                        placeNameTF.text = annotationTitle
                                        commentTF.text = annotationSubtitle
                                        
                                        locationManager.stopUpdatingLocation()
                                        //zoom
                                        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        mapKitView.setRegion(region, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }catch{
                print("error target section")
            }
            
        }
        
        
        
    }
    
    
    
    
    ///fonksiyonun gesture Recongizer parametresi almasi
    ///pinin eklendigi fail oldugu ve vazgecildigi fonksiyonlarin yazilabilmesi icin
    @objc func chooseLocations(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            ///mapkit icinde dokunulan noktayi kaydetme
            let touchPoint = gestureRecognizer.location(in: self.mapKitView)
           ///dokunulan noktayi kordinata cevirmeliyiz
            let touchedCoordinates = mapKitView.convert(touchPoint, toCoordinateFrom: mapKitView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            /// pini olusturma
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = placeNameTF.text
            annotation.subtitle = commentTF.text
            self.mapKitView.addAnnotation(annotation)
        }
        
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if targetName == ""{
            //kullanicinin son konumunu alir
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            //zoom seviyes
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapKitView.setRegion(region, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil{
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.blue
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button

        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    //apple map navigasyon acma
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if targetName != ""{
            let newLocation = CLLocation(latitude: annotationLatitude, longitude: annotoinLongitude)
            CLGeocoder().reverseGeocodeLocation(newLocation) { placemarks, error in
                if let placemarks = placemarks{
                    if placemarks.count > 0{
                        let newPlacemark = MKPlacemark(placemark: placemarks[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        
                        item.name = self.annotationTitle
                        let launchOption = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
                        item.openInMaps(launchOptions: launchOption)
                    }
                }
            }
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
      
        newPlace.setValue(commentTF.text, forKey: "subTitle")
        newPlace.setValue(placeNameTF.text, forKey: "title")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("success")
        }catch{
            print("error: context save")
        }
        navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
