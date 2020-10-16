# MARVEL's Demo
Here's a quick demo of my DemoKit in action using different configurations for the main view controller using data from Marvel's API.


<br />

## Configurations

|   List View    |   Grid View    |   Grouped List     |
|   --------    |   --------    |   -------     |
|               |               |               |
| ![ListView](Files/ListView.gif) | !["GridView"](Files/GridView.gif) |  !["GroupedList"](Files/GroupedList.gif) |

---

<br />

List View
```swift
configuration.isPaginated = true
configuration.isSearchable = true
configuration.itemsPerRow = 1
configuration.itemsPerPage = 50 // per fetch request
```


Grid View
```swift
configuration.isPaginated = true
configuration.isSearchable = true
configuration.itemsPerRow = 3
configuration.itemsPerPage = 39 // per fetch request
```


Grouped List
> :warning: Grouped List doesn't support pagination
```swift
configuration.isGrouped = true
configuration.isSearchable = true
configuration.itemsPerRow = 1
```

<br />

## More Parameters

> Shows a loading view when fetching items

```swift
shouldShowLoading: Bool = true
```

> Shows/Hides headers for empty sections
```swift
shouldShowEmptySectionHeaders: Bool = false
```

> Distance to bottom to fetch more items
```swift
contentLoadOffset: CGFloat = 0
```
