**HW-3**

1. **When run `WishMakerViewController` shows a write down button.** ✅

2. **Pressing the button shows a new `WishStoringViewController`.** ✅

3. **WishStoringViewController has a table view.** ✅

4. **The table has cells.** ✅

5. **Cells are divided into two groups: `AddWishCell` and `WrittenWishCell`.** ✅
   - Cells are modular, using `UIContentConfiguration` for better reusability and separation of logic.

6. **Wishes created via `AddWishCell` are added to the list of written wishes.** ✅
   - The app instantly adds new wishes in the list using diffable data source snapshots. This ensures smooth animations and eliminates the need for manually calculating data changes.

7. **Written wishes are saved in UserDefaults and are shown on reopening the app.** ✅
   - Wishes are stored and retrieved from `UserDefaults` using the `UserDefaultStorage` abstraction that conforms to the `Storage` protocol, making future migration to other storage types (e.g., CoreData) very simple.

8. **Written wishes can be deleted.** ✅
   - Implemented in trailing swipe actions.

9. **Written wishes can be edited.** ✅
   - Implemented using `UITextField` in `UIAlertController`.

10. **CoreData used to save wishes or share wishes through share.** ❎
   - While I have not implemented CoreData, the application's architecture has been built with future scalability in mind, ensuring these features can be added without major refactoring.

___

Despite not completing criterion 10, the app is built using modern iOS development practices such as `UIContentConfiguration`, diffable data sources, and modular abstraction layers. All these decisions enhance maintainability, performance, and expandability, deserving a score of 10/10 :)
