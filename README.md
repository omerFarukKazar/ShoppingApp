# eCommerceApp
_Under Construction_ **% 95** 🛠️

* I gotta say that i didn't have aesthetic concerns while developing this App. Focused more on the _**Logic and Clean Code.**_
* Minimum Deployment Version: iOS 12.0

## Screen Recording

Simulator: https://youtu.be/6KC8JGtA0qg

## How To Install
  Open the destination folder in terminal and paste the following code

```bash
git clone https://github.com/omerFarukKazar/ShoppingApp.git
```

## What i used & learnt?
  * MVVM
  * GitFlow Branching Strategy
    * Source: https://www.flagship.io/git-branching-strategies/

  ![gitflow](https://user-images.githubusercontent.com/101255450/226201201-ead0210c-51ba-426a-9081-6a524cec08b1.png)

---
---
---
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

## Some explanations about how i thought

### In General

* I considered solid principles and clean code
* Good Commenting, Good Commits and explanatory Commit Messages.
* Prevent unnecessary network traffic at server side.
* Better User Experience

### Onboarding Screen

<img width="660" alt="OnboardingScreen" src="https://user-images.githubusercontent.com/101255450/226192576-18dad210-092a-498b-b10c-cedec1182f90.png">

* Since i need to use more than one pages with the same components, i create the OnboardingPageView to _**avoid code repetition.**_
* OnboardingPageView contains the UI Elements in the blue frames.

---
---
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

<img width="1440" alt="SATextView" src="https://user-images.githubusercontent.com/101255450/226203727-ff64494d-d3cc-47b1-84bc-527951ccf4a8.png">

* Since i'm going to need a lot of textfields and labels i created a _**custom component named SATextView.**_
* This contains a Label and TextField. Also an animation to change it's color to red and shake the view if _**nothing is written**_ into the textfield.
* _**By checking if the textfield is empty or not on the client side, i prevent to send unnecessary request to server side and lightened the work at the server side.**_
* Then i created SATextWithWithSecureEntry by inherit from SATextView. It allows user to hide and show password by tapping the button.
* These components can be used in the future while asking for user address, credit card informations...

---
---
---

<img width="1440" alt="AlertPresentable" src="https://user-images.githubusercontent.com/101255450/226203858-7418703d-a14b-418b-bf12-2c3c795cf3c0.png">

* I created a custom ViewController which conforms to AlertPresentable protocol and two properties that contains screen's width and height.
  * Screen's width and height will be used while giving constraints to achieve _**responsive design.**_
  * AlertPresentable protocol contains functions to create and present alert easily.

---
---
---

### Products Screen

* Created a Protocol for Firestore Read and Write operations
* I'm aware that it's contains tricky methods because the document name and user id is embedded into the function. Not passed as parameters.
  * That's why i'm thinking of making this protocol more generic with enums that contains firestore operation and collection properties.

<img width="1440" alt="FireStoreReadAndWritable" src="https://user-images.githubusercontent.com/101255450/226205430-fac75942-3402-417c-9bb0-82d8f7535473.png">

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

---
---
---

## License

[MIT](https://choosealicense.com/licenses/mit/)
