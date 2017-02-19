# TheMovieDB #
Dubizzle

Please open the project using TheMovieDB.xcworkspace.

### What is this repository for? ###

* Candidates participating in this round are required to built a simple iOS app using Xcode in Objective-C or Swift that displays movies from TMDb. The UI decisions are at the liberty of the candidates long as the elements of aesthetics, information and attention to detail are not lost.

1. The API for the app should be from http://themoviedb.org.
2. Candidates may familiarize themselves with the documentation available at http://docs.themoviedb.apiary.io and register for an API key before starting live coding to prevent time wastage.
3. App should display a list of movies. Clicking on a movie will display some details of the movie.
4. App should have a simple filter button. Tapping on this button should open a Filter view which has two fields “Min Year” and “Max Year”. 
Customer who use this awesome app will be able to filter movies based on minimum and maximum year range entered.
5. It would be a bonus if the app has paging and infinite scrolling.

* This is by no means a complete solution! But it reflects the patterns that I adopt and should provide an idea regarding my approach and my decision making.

### Functionality ###
** Screen 1: Movie list Page: ** This page will show a list of all the movies. The initial call fetches all movies released between 2010 & 2017. Tapping on a movie will bring the user to a detailed movie view. Tapping on "Filter" will bring the user to Screen 3 which allows them to change the applied filter.

** Screen 2: Movie Detail Page: ** This page will show the details of a selected movie.

** Screen 3: Filter Page: **
This page will allow the user to change the applied filter. The filter sets the range of movies in terms of their release years

### Endpoints ###

Base URL: https://api.themoviedb.org/3
Images URL: https://image.tmdb.org/t/p/w300

**GET /discover/movie:** Gets a list of movies

### Architecture ###


** NETWORKING **
Networking uses Alamofire. There are 3 layers that distribute the networking workload:

1. **MovieEndpoint:** enum with a separate case for each movie backend call
2. **MovieRouter:** adopts the URLRequestConvertible protocol. This is in charge of building the URLRequest for the movie API calls from the individual components. It holds a reference to the movie endpoint enum
3. **MovieManager:** will make the actual Alamofire network calls and will handle the response
4. **Movie model:** represents a Movie object. Implements the ResponseObjectSerializable protocol.
5. **Generic Response serialisers:** ResponseObjectSerializable and ResponseCollectionSerializable. When adopted, these protocols provide automatic, type-safe response object serialization into corresponding objects and array of objects respectively.
6. **GetMoviesResponse:** Encapsulates the response received from the backend for the get list of movies API call



### Setup ###

* Developed using XCode 8.2.1 

* Written in Swift 3 

* Tested on iPhone 6 running iOS 9.3.5 and iPhone 5S running iOS 10.1.1 

* Runs on iOS 9.0 and higher 

* Uses size classes and auto layout to support all iPhone screen sizes



### Dependencies ###

1. Alamofire 4.0

2. AlamofireImage 3.2

3. Commons (https://github.com/mdermejian/Commons.git

4. TTRangeSlider 1.0
