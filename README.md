# Ember Trip View

## About this project
The goal of this project is to create a mobile view that provides useful information about individual bus trips to potential passengers. The new view will include scheduled and estimated times at stops, a live map showing the bus’s current position, and potentially additional features like notifications. The aim is to enhance the passenger experience and provide all the necessary information to make informed decisions about their journey.

## Requirement 
- Swift 5+
- Xcode 15.1+
- iOS 17+

## Views

### Home View

<p>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/0490c0f4-4892-475b-be2c-c790e75f55c0" width="200"/>
</p>


### Trip View
<p>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/c151439b-5898-4786-a2f8-98ab62c61a43" width="200"/>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/263bbbbe-3f14-4a50-9b4e-e7cdaafd92dc" width="200"/>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/0e939c75-4b67-4036-9c89-ebc726672c22" width="200"/>
</p>

## Features

### Offline Mode
Users are able to access bus routes and information even when they lose internet connection during the trip. However, the information provided may not be accurate.

[](https://github.com/ElvisWong213/EmberTrip/assets/40566101/69ff595f-53ed-4dfc-8fd2-b1fc0df9afa5)

### Arrival Notification
The arrival notification feature will remind you when you are nearing your intended destination, ensuring you never miss your stop.
<p>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/614fac16-18dc-48bd-9b14-6c2982c46297" width="200"/>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/7b68a7ec-9c54-424f-9711-1e4c1bf380ca" width="200"/>
</p>

### ETA
It allows users to view the estimated time of arrival at different stops along their route, and they can switch between the actual time and the estimated time.
<p>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/7484f0eb-5a94-4436-a18b-2eee211e8c80" width="200"/>
  <img src="https://github.com/ElvisWong213/EmberTrip/assets/40566101/a6af720c-089e-4fd3-bb97-e8bb301e0218" width="200"/>
</p>

### Restore Previous Section
Users can restore the previous section when they accidentally close the app or if the app crashes.

[](https://github.com/ElvisWong213/EmberTrip/assets/40566101/26032770-c41e-43b4-8cfc-5bf7002a9210)

## Need To Improve 
1. Map Camera
   - Adjust camera position when user resize the sheet view.
2. Arrival Notification
   - Create an animation to demonstrate the feature.
   - Or change the swip gesture to a button.
3. Bus Stops List View
   - Simplify the user interface to ensure it is not overwhelming.
4. Unit test in NotificationService
