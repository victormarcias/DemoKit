
# MARVEL's Demo
Here's a quick demo of my DemoKit in action using different configurations for the main view controller using data from Marvel's API.

> :warning: Not visible images don't exist in Marvel's API.

<br />

---

## List View

> ViewModel fetches from API

```swift
configuration.isPaginated = true
configuration.isSearchable = true
configuration.itemsPerRow = 1
configuration.itemsPerPage = 50 // per fetch request
```

![ListView](Files/ListView.gif)

---
<br />

### Grid View

> ViewModel fetches from API

```swift
configuration.isPaginated = true
configuration.isSearchable = true
configuration.itemsPerRow = 3
configuration.itemsPerPage = 39 // per fetch request
```

!["GridView"](Files/GridView.gif)

---
<br />

### Grouped List

> ViewModel fetches from local json file

```swift
configuration.isGrouped = true
configuration.isSearchable = true
configuration.itemsPerRow = 1
```
> :warning: Grouped List doesn't support pagination

!["GroupedList"](Files/GroupedList.gif)

<br />

---
<br />

## More Parameters

- Shows a loading view when fetching items

```swift
shouldShowLoading: Bool = true
```
<br />

- Shows/Hides headers for empty sections
```swift
shouldShowEmptySectionHeaders: Bool = false
```
<br />

- Distance to bottom to fetch more items
```swift
contentLoadOffset: CGFloat = 0
```
<br />
