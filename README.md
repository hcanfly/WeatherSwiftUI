# WeatherSwiftUI

WeatherSwiftUI is an iOS weather app whose UI is similar to parts of the Yahoo! Weather app. It gets weather info from AccuWeather which requires that you get an API key, but it is free for low-use apps (50 calls per day). There are links for this in ViewModel+Network.swift. Good example of using Combine to download the weather data. The fetch function checks for and returns errors. The calling function has to make two async calls to get the current and forecast weather, and uses the Zip operator to wait until both calls finish before updating the data so that the UI is only refreshed once.


|![Screenshot](Screenshot.png)





## License

WeatherSwiftUI is licensed under the MIT License. See the LICENSE file for more information, but basically this is sample code and you can do whatever you want with it.