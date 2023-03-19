# eCommerceApp
An e-commerce App

* I gotta say that i didn't have aesthetic concerns while doing this App. Focused more on the Logic and Clean Code.
* Minimum Deployment Version: iOS 12.0

## How To Install
  Open the destination folder in terminal and paste the following code

```bash
git clone https://github.com/omerFarukKazar/ShoppingApp.git
```

## What i used & learnt?
  * MVVM
  
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
  
## Screen Recording

Simulator: https://youtu.be/AntzcKpYTDg

## Some explanations about how i thought

### Onboarding Screen

<img width="660" alt="OnboardingScreen" src="https://user-images.githubusercontent.com/101255450/226192576-18dad210-092a-498b-b10c-cedec1182f90.png">
Since i need to use more than one pages with the same components, i create the OnboardingPageView to avoid code repetition.
OnboardingPageView contains the UI Elements in the blue frames.


<img width="1440" alt="Onboarding2" src="https://user-images.githubusercontent.com/101255450/226198212-3bc88a7d-7ad4-40cd-b979-9248a341407e.png">
1. Created a PageModel (it can also be used if properties fetched from server)
2. Created an enum for each page, give them Int RawValues to represent page number
Add 'getPageData()' method to return the Page's Model. 
3. Since OnboardingPage Enum is CaseIterable, get the count of enum while Appending Pages to pagesArray and append them in a for loop. 
That's how, i avoided hard code and also if there are new pages be added or removed from Onboarding page, developer should only change the Onboarding Page Enum and rest of the code will work properly.. 


### Auth Screen


## License

[MIT](https://choosealicense.com/licenses/mit/)
