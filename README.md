# Favorite Places

My Favorite Places is an iOS application that allows users to save and list their favorite places. The application presents users with a map view and users can mark their favorite places on this map. Additionally, users can add extra information (address, description, photo, etc.) for each marked location.

## Features

- Users can save their favorite places in the application.
- Saved places are marked on the map and users can click on them to see detailed information.
- Users can add extra information (address, description, photo, etc.) for each saved place.
- Users can list their saved places.
- The application stores the data using Core Data and preserves the data that the user saved.
- The application includes map features using MapKit.


## Screenshots
| List Screen | Save Location Screen |
| ------- | ------- |
|![Screenshot 2023-05-04 at 7 54 09 AM](https://user-images.githubusercontent.com/57291537/236115689-8eb57170-6887-4b65-be44-6dd7a1958bbc.png) |![Screenshot 2023-05-04 at 7 51 33 AM](https://user-images.githubusercontent.com/57291537/236115691-a830bdfb-b217-46c7-9681-e61c1c2b6efd.png) |

| Delete Screen | Apple Map Screen |
| ------- | ------- |
|![Screenshot 2023-05-04 at 7 54 26 AM](https://user-images.githubusercontent.com/57291537/236115693-1ef93a95-6e3a-4853-884f-84f694a2d6de.png) | ![Screenshot 2023-05-04 at 7 56 09 AM](https://user-images.githubusercontent.com/57291537/236115694-401b3b5e-d2bd-4cdf-8240-6f89bd1b15c0.png)|

## Requirements

- iOS 13.0 or later
- Xcode 12 or later
- Swift 5

## Installation

1. Clone or download this repo.
2. In the terminal, navigate to the project directory and run the command `pod install`. This will install all the libraries used in the project.
3. Open the project file in Xcode.
4. Open the `favoriteLocations.xcodeproj` file.
5. Select the simulator and click the "Run" button.

## Usage

The application presents users with a simple interface to save and list their favorite places. When users open the application, they will see a map view and a toolbar. In the toolbar, users can add a new place, list saved places, or exit the application.

To add a new place, users click on the "+" button in the toolbar. This will open a form and users can add a new location. After filling out the form, users can add a new location by clicking the "Save" button. Locations are marked on the map and users can click on any marked location to see the detailed information. 

To list saved places, users click on the "List" button in the toolbar. This will show a list of all the saved places. Users can click on any item in the list to see the detailed information.

## Contributing

Contributions to this project are welcome. If you find a bug or have a feature request, please open an issue in the repo. If you would like to contribute code, please fork the repo and create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
