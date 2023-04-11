# Shopping App
_Under Construction_ **% 95** 🛠️

* I didn't have aesthetic concerns while developing this App. Focused more on the _**Logic and Clean Code.**_
* Minimum Deployment Version: iOS 12.0

## Screen Recording

Simulator: https://youtu.be/JNBI2_NeZVQ

## How To Install
  Open the destination folder in terminal and paste the following code

```bash
git clone https://github.com/omerFarukKazar/ShoppingApp.git
```

## What i used & learnt?
  * MVVM
  * GitFlow Branching Strategy
    * Source: https://www.flagship.io/git-branching-strategies/

  * Generic Networking
    * Source: https://betterprogramming.pub/async-await-generic-network-layer-with-swift-5-5-2bdd51224ea9
  * Firebase 
    * Auth
    * FireStore

  * Programmatic UI 
    * UICollectionView
    * UITabBar
    * UIDatePicker
    * UIScrollView
    * Navigation Controller
    
  * Data Pass
    * w/Closures
    * w/Delegates
    * w/Properties
  
  * Dependencies
    * Firebase

---
---
---

## App

### In General

* I considered solid principles and clean code
* Good Commenting, Good Commits and explanatory Commit Messages.
* Prevent unnecessary network traffic at server side.
* Better User Experience

### Onboarding Screen

<img width="500" alt="OnboardingScreen" src="https://user-images.githubusercontent.com/101255450/231146089-1680d280-bfdb-4ee2-ade0-6eb1dbfbdad9.png">

---
---
---

### Auth Screen

##### Log In Screen

<img height="500" alt="LogIn" src="https://user-images.githubusercontent.com/101255450/231230566-4bba8aa5-fd93-4444-9021-40935b8fbfc0.png">

---

##### Sign Up Screen
<img height="500" alt="SignUp" src="https://user-images.githubusercontent.com/101255450/231230575-8eddab0e-8dff-4f6f-a203-84431e3ffd3e.png">

---
---
---

### Products Screen

<img height="500" alt="SignUp" src="https://user-images.githubusercontent.com/101255450/231245332-560eccf9-6ec1-4251-85e4-ddaeaf1465e1.png">

---
---
---

### Product Detail

<img height="500" alt="SignUp" src="https://user-images.githubusercontent.com/101255450/231246287-788032b9-2da9-4740-a573-0478b0f60d46.png">

---
---
---

### Cart Screen

<img height="500" alt="SignUp" src="https://user-images.githubusercontent.com/101255450/231246295-f135c091-bad3-471a-835d-685dad6461b6.png">

---
---
---

### Search Screen

<img height="500" alt="SignUp" src="https://user-images.githubusercontent.com/101255450/231246452-d0406652-7700-4cd1-8731-32acf2d2972d.png">

---
---
---

### Profile Screen

<img height="500" alt="SignUp" src="https://user-images.githubusercontent.com/101255450/231246313-074c64e6-b036-4926-a409-6bf05bc754ae.png">

---
---
---

## Logic 

### Onboarding Screen

* Since i need to use more than one pages with the same components, i create the OnboardingPageView to _**avoid code repetition.**_
* OnboardingPageView contains the UI Elements in the blue frames.

---

<img width="1440" alt="Onboarding2" src="https://user-images.githubusercontent.com/101255450/226198212-3bc88a7d-7ad4-40cd-b979-9248a341407e.png">

1. Created a PageModel (it can also be used if properties fetched from server)
2. Created an enum for each page, give them Int RawValues to represent page number
Add 'getPageData()' method to return the Page's Model. 
3. Since OnboardingPage Enum is CaseIterable, get the count of enum while Appending Pages to pagesArray and append them in a for loop. 
That's how, i avoided hard code and also if there are new pages be added or removed from Onboarding page, developer should only change the Onboarding Page Enum and rest of the code will work properly.

---
---
---

### Auth Screen

* Since i need a lot of textfields and labels i created a _**custom component named SATextView.**_
* This contains a Label and TextField. Also an animation to change it's color to red and shake the view if _**nothing is written**_ into the textfield.
* _**By checking if the textfield is empty or not on the client side, i prevent to send unnecessary request to server side and lightened the work at the server side.**_
* Then i created SATextWithWithSecureEntry by inherit from SATextView. It allows user to hide and show password by tapping the button.
* These components can be used in the future while asking for user address, credit card informations...

```swift
import UIKit

/// Custom view which includes a UITextField and a UILabel above the textfield.
class SATextView: UIView {

    // MARK: - Properties
    /// Stands for 'titleLabel.text'. Shortened the property's name.
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    /// Stands for 'textField.text'. Shortened the property's name.
    var text: String? {
        get {
            if textField.text == "" {
                shake()
                changeColor()
                return nil // I'll unwrap it before use anyways.
            } else {
                return textField.text
            }
        }
        set {
            textField.text = newValue
        }
    }

    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabelConstraints()
        setTextFieldConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    /// Shake animation for the view.
    private func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    /// Change color to red and original back.
    private func changeColor() {
        let latestColor = titleLabel.textColor // Created a variable to get latest color to be able to return it.
        // Could've write .lightGray but this is a better approach in case of
        // default color of SATextView is changed after definition.
        titleLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.titleLabel.textColor = latestColor
        }
    }

    // MARK: - Constraints
    func setLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }

    func setTextFieldConstraints() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }

}

```

---

* I created a custom ViewController which conforms to AlertPresentable protocol and two properties that contains screen's width and height.
* Screen's width and height will be used while giving constraints to achieve _**responsive design.**_
* AlertPresentable protocol contains functions to create and present alert easily.

```swift
import UIKit

protocol AlertPresentable { }

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   cancelButtonTitle: String? = nil,
                   handler: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: handler)

        if let cancelButtonTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelButtonTitle,
                                             style: .cancel)
            alertController.addAction(cancelAction)
        }

        alertController.addAction(defaultAction)
        self.present(alertController, animated: true)
    }

    func showError(_ error: Error) {
        showAlert(title: "Error Occurred",
                  message: error.localizedDescription)
    }
}
```

---
---
---

### Products Screen

* Created a Protocol for Firestore Read and Write operations
* I'm aware that it's contains tricky methods because the document name and user id is embedded into the function. Not passed as parameters.
  * That's why i'm thinking of making this protocol more generic with enums that contains firestore operation and collection properties.
  
```swift
//
//  FireStoreReadAndWritable.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 18.03.2023.
//

import Foundation
import FirebaseFirestore

enum FirestoreDocumentPath: String {
    case favorites
    case cart
}

enum CartOperation {
    case increase
    case decrease
    case remove
}

enum CollectionPath: String {
    case users
}

/// Contains two methods to add and remove product in the specified document which is array  in Firestore
protocol FirestoreReadAndWritable: FireBaseFireStoreAccessible,
                                   UserDefaultsAccessible {

    func fetchUserData(completion: @escaping ((_ userData: User?, _ error: Error?) -> Void))

    func addToFavorites(with productId: Int?,
                        completion: @escaping ((_ error: Error?) -> Void))
    func removeFromFavorites(with productId: Int?,
                             completion: @escaping ((_ error: Error?) -> Void))
    func updateCart(with operation: CartOperation,
                    productId: Int?,
                    completion: @escaping ((_ error: Error?) -> Void))

}

extension FirestoreReadAndWritable {
    /**
     Download's user's data from Firebase and returns that data with completion.

     - parameters:
        - completion:: Closure that holds User? or Error? with respect to the response from firebase.
     */
    func fetchUserData(completion: @escaping ((_ userData: User?, _ error: Error?) -> Void)) {
        guard let uid = uid else { return }

        let users = CollectionPath.users.rawValue

        db.collection(users).document(uid).getDocument { document, error in
            if let error = error {
                completion(nil, error)
            } else {
                guard let document = document?.data() else { return }
                let user = User(from: document)
                completion(user, nil)
            }
        }
    }
    /// Accesses FireStore database with user's uid stored in defaults and **removes** the product's id from
    /// corresponding **array** that is stored in firestore db.
    /// - parameters:
    ///     - documentPath:: Name of the document in FireStore
    ///     - id:: The id of the product whose Favorite button was tapped on.
    ///     - completion:: To handle possible outcomes.
    /// - warning: This function's collection is **"users"** and
    /// only adds or removes the id parameter to the **array** in Firebase.
    ///
    func updateCart(with operation: CartOperation,
                    productId: Int?,
                    completion: @escaping ((_ error: Error?) -> Void)) {

        let cartBackup = ProductsManager.cart

        guard let id = productId,
              let uid = uid else { return }

        switch operation {
        case .increase:
            if let count = ProductsManager.cart[id] {
                ProductsManager.cart.updateValue(count + 1, forKey: id)
            } else {
                ProductsManager.cart.updateValue(1, forKey: id)
            }

        case .decrease:
            if let count = ProductsManager.cart[id] {
                if count == 1 {
                    ProductsManager.cart.removeValue(forKey: id)
                } else {
                    ProductsManager.cart.updateValue(count - 1, forKey: id)
                }
            }
        case .remove:
            if let _ = ProductsManager.cart[id] {
                ProductsManager.cart.removeValue(forKey: id)
            }
        }

        var jsonData = Data()
        do {
            jsonData = try JSONEncoder().encode(ProductsManager.cart)
        } catch {
            ProductsManager.cart = cartBackup
            completion(error)
        }

        let documentPath = FirestoreDocumentPath.cart.rawValue

        db.collection("users").document(uid).updateData([documentPath: jsonData]) { error in
            if let error = error {
                ProductsManager.cart = cartBackup
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }

    /// Accesses FireStore database with user's uid stored in defaults and **removes** the product's id from
    /// corresponding **array** that is stored in firestore db.
    /// - parameters:
    ///     - documentPath:: Name of the document in FireStore
    ///     - id:: The id of the product whose Favorite button was tapped on.
    ///     - completion:: To handle possible outcomes.
    /// - warning: This function's collection is **"users"** and only
    /// adds or removes the id parameter to the **array** in Firebase.
    func addToFavorites(with productId: Int?,
                        completion: @escaping ((_ error: Error?) -> Void)) {

        guard let id = productId,
              let uid = uid else { return }

        let documentPath = FirestoreDocumentPath.favorites.rawValue

        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayUnion([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                ProductsManager.favorites.append(id)
                completion(nil)
            }
        }
    }

    /**
     Removes the product with given id from FireBase favorites array.

     - parameters:
        - productId:: id of the product that'll be removed from favorites.
        - completion:: Completion handler closure. Passes error if any error occurs.
     */
    func removeFromFavorites(with productId: Int?, completion: @escaping ((_ error: Error?) -> Void)) {

        guard let id = productId,
              let uid = uid else { return }

        let documentPath = FirestoreDocumentPath.favorites.rawValue

        db.collection("users").document(uid).updateData([documentPath: FieldValue.arrayRemove([id])]) { error in
            if let error = error {
                completion(error)
                return
            } else {
                guard let index = ProductsManager.favorites.firstIndex(of: id) else { return }
                ProductsManager.favorites.remove(at: index)
                completion(nil)
            }
        }
    }

}

```
---
---
---

#### Storing Favorites and Cart items
* I thought about using CoreData to store them but in case of changing to another platform or device user would lost that data.
* I preferred Singleton and Static methods for cart and favorites list and kept them up to date with FireStore.
```swift
final class ProductsManager {
    static let products = ProductsManager()
    static var cart: [Int: Int] = [:]
    static var favorites: [Int] = []
}
```

---
---
---

### Search Screen

* If new segments will be added to Segmented Control in the future, adding that category to API response is enough.
* It'll automatically added to viewModel.category and since all the segmented control based on it with 'forEach' method, no need to do anything else.

```swift
    private func setSegmentedControlSegments() {
        let categories = viewModel.category
        categories.forEach({ category in
            guard let index = categories.firstIndex(of: category) else { return }
            searchView.segmentedControl.insertSegment(withTitle: category, at: index, animated: false)
        })
    }

    private func addSegmentedControl() {
        navigationItem.titleView = searchView.segmentedControl
    }

    private func addSegmentedControlTarget() {
        searchView.segmentedControl.addTarget(self,
                                              action: #selector(segmentedControlValueChanged(_:)),
                                              for: .valueChanged)
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        guard let category = sender.titleForSegment(at: selectedSegment) else { return }
        viewModel.fetchProductsBy(category: category)
    }
```

---
---
---

### Profile Screen

* I didn't want to fetch user's profile picture from server everytime. So i add Core Data to project to be able to store profile picture of user locally if image picking and uploading to firebase firestore is successful.

```swift
import UIKit
import CoreData

/**
 Entities  in Core Data
 - Each entity has own related Attributes enum.
 - To find related attributes enum, write < Entity name + Attributes >
 - _*Example: Attributes for userCoreData is UserCoreDataAttributes*_
 */
enum CoreDataEntities: String {
    case userCoreData = "UserCoreData"
}

enum UserCoreDataAttributes: String {
    case profilePhoto
}

/**
 Defined to ease CoreData usage and avoid Code Repetition.
 */
protocol CoreDataManager { }

extension CoreDataManager {
    var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }

    var context: NSManagedObjectContext? {
        guard let appDelegate = appDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }

     /**
      This is a generic method to save given **data** to the CoreData easily.

      - parameters:
        - data::  Any kind of data.
        - entityName:: Core Data Entity of the desired attribute
        - attributeName:: The name of the attribute where the data is wanted to be stored.
      */

    func saveToCoreData<T>(data: T, entityName: String, attributeName: String) throws {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(data, forKey: attributeName)
        do {
            try context.save()
        } catch {
            throw(error)
        }
    }

    /**
     This is a function to get the desired **data** from CoreData easily.

     - parameters:
       - entityName:: Core Data Entity of the desired attribute
       - attributeName:: The name of the attribute where the data is wanted to be stored.
       - completion:: Closure to handle possible Object or Error.
     */
    func getDataFromCoreData(entityName: String,
                             attributeName: String,
                             completion: ((AnyObject?, Error?) -> Void)) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            guard let fetchResults = try context?.fetch(fetchRequest),
                  let fetchResultsObjects = fetchResults as? [NSManagedObject] else { return }

            for userCoreData in fetchResultsObjects {
                if let data = userCoreData.value(forKey: attributeName) as? AnyObject {
                    completion(data, nil)
                }
            }
        } catch {
            completion(nil, error)
        }
    }
}

```


## License

[MIT](https://choosealicense.com/licenses/mit/)
