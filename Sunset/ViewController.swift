//
//  ViewController.swift
//  Sunset
//
//  Created by Dmytro Dobrovolskyy on 2/6/19.
//  Copyright © 2019 YellowLeaf. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Variables
    private var placesClient: GMSPlacesClient!
    
    // MARK: - Constants
    private let locationManager = CLLocationManager()
    
    // MARK: - Outlets
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private var sunLabels: [UILabel]!
    
    // MARK: - Actions
    @IBAction private func getCurrentPlace(_ sender: UIButton) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.loadData(
                        lat: String(describing: place.coordinate.latitude),
                        lng: String(describing: place.coordinate.longitude),
                        address: place.formattedAddress
                    )
                }
            }
        })
    }
    
    @IBAction private func autocompleteClicked(_ sender: UIButton) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        
        present(placePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        requestLocation()
    }
    
    // MARK: - Location request
    private func requestLocation() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Load data and refresh labels
    private func loadData(lat: String, lng: String, address: String?) {
        DataLoader().getPlacesInRadius(latitude: lat, longitude: lng) { result in
            for label in self.sunLabels {
                switch label.tag {
                    
                // Sunset
                case 0:
                    label.text = result["sunset"]
                    
                // Sunrise
                case 1:
                    label.text = result["sunrise"]
                    
                default:
                    break
                }
            }
        }
        
        addressLabel.text = address
    }
}

// MARK: - Configure searching
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.loadData(
            lat: String(describing: place.coordinate.latitude),
            lng: String(describing: place.coordinate.longitude),
            address: place.formattedAddress
        )
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
