# Product List App

A Flutter application showcasing:

- Clean architecture using BLoC and Freezed
- Local data caching with SQLite (`sqflite`)
- API pagination using `limit` and `skip`
- Deep linking with Firebase Dynamic Links
- Reactive UI with local DB listening

---

##  Features

### 📄 Product List Page
- Fetches product data from:  
  `https://dummyjson.com/products?limit=10&skip=0`
- Uses `flutter_bloc` and `freezed` for state management
- Caches data locally in **SQLite**
- Displays data using `StreamBuilder`
- Supports **lazy loading** with pagination

### 🔍 Product Detail Page
- Opens on product tap or deep link
- Reads product from local SQLite DB
- Shows: `Product not found in local storage` if unavailable

---

## 🔗 Deep Linking

The app supports deep links like:

-----Test on Android using ADB:------

adb shell am start -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://productlist-asharudheen.web.app/product/5" \
  -n com.example.product_list/.MainActivity
