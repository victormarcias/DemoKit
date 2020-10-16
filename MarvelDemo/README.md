
# MARVEL's Demo
Here's a quick demo of my DemoKit in action using different configurations for the main view controller using data from Marvel's API.

> :warning: &nbsp; Not visible images don't exist in Marvel's API.

<br />

---

<br />

## Configuration Examples

|               | List View | Grid View | Grouped View  |
| :-:           | :-:       | :-:       | :-:           |
| Preview       | ![](Files/ListView.gif)| ![](Files/GridView.gif) | ![](Files/GroupedList.gif) |
| View Model    | API       | API       | Local Json file |
| isPaginated   | true      | true      | false         |
| isSearchable  | true      | true      | true          |
| isGrouped     | false     | false     | true          |
| itemsPerRow   | 1         | 3         | 1             |
| itemsPerPage  | 50        | 39        | All*          |


> :warning: &nbsp; *Pagination is not supported when items are grouped.

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
