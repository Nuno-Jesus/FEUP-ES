# Logical Architecture

In this project, we decided to mainly use two architectural patterns:

- Client-Server Pattern
- MVC(Model, View, Controller)

The first architectural patterns is easily spotted, because every action we take and data we see or input is most likely stored in our database. The second one is obtanded thanks to the separation between the modules screens, models and components. 

Long-term maintenance must be provided and with these 4 sections are of great importance for it's achievement:

- `View`: Module responsible for drawing the app and widgets
- `Model`: Computes the data that will be used in both user and server side
- `Controller`: The controller will be used as a listener to click events
- `Database`: Database will used to retrieve data or to be updated
- `Sigarra's API`: API used to get sigarra's information
- `Maps's API`: API used to get the location of the event

## Packages diagram

![image](/images/Logical_Architecture.png)
