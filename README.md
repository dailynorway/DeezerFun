# Deezer Fun 👨‍💻

This iOS App is a showcase using Deezer APIs. Deezer is a French online music streaming service.
To learn more about its API, head over to [https://developers.deezer.com/api](url).

This App uses no 3rd party libraries and it relies 100% on iOS frameworks. 🍎
The initial screen allows you to search for artists with an autocomplete search bar. From there you can see all the albums available on Deezer for the selected artist and its tracks. Deezer allow us to stream 30 seconds of any selected title. You can do so by clicking on the tracks. 
It has support for 3 languages: English, Norwegian Bokmål and Brazilian Portuguese.


## 🔎 Search Controller

- UITableView.
- Modern large titles from iOS11 revamp. 📱
- Search bar has autocomplete feature to help you find your favourite artist.👩‍🎤
- This screen has an empty state view image.
- Once you clear the search field, all results will be removed.

## 💿 Albums Controller

- UICollectionView
- It loads and displays all the available albums of your selected artist
- It show the cover of the albums with the title, sorted by date of release
- By tapping an album you will be take to another controller that will display all the tracks for the selected album 🚰

## 🗒 Data

- All the data in the app is fetched from Deezer and not persisted
- There is a memory cache for the images 🔌

## 📡 Network monitor

There is a network monitor that will let the user know if the internet connection was lost.

## 🔦 Features
- ~~Written in Swift~~ ✅
- ~~No 3rd party libraries were used~~ ✅
- ~~All history is available on the repo~~ ✅
- ~~Localization available~~ ✅

## 🔨 Unit Tests
There are unit test for the network layer and for the 3 presenters in the App.

## 🌎 Localization
The App is available in 🇦🇺 English, 🇳🇴 Norwegian Bokmål and 🇧🇷 Brazilian Portuguese.

## 🕵️‍♂️ The Review

I normally create `feature branches` during development and merge then into `develop` once they are ready. That is what I've done in this showcase as well.
It is good when the VCS history can tell a story on its own, which is pretty much how I like to work. You will notice it.

I opt to use MVP with protocols communication back to the viewController.
View Controllers are inside a folder called Module. I tend to group View Controllers in separated modules with their own files and Storyboard for easy maintenance when a large team is working in the same project.

---
### 🙋‍♂️ Erick Vavretchek // erickva@gmail.com // +47 461 25 030 // 🇧🇷🇦🇺🇳🇴
