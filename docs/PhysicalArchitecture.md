# Physical Architecture

The physical architecture of our project relies on two separate blocks that communicate with each other via HTTPS requests.

![image](https://user-images.githubusercontent.com/93390807/162426228-39af72e9-8896-4e8a-b93e-e263c3732f18.png)

The physical architecture of Smart Calendar relies on two separate blocks that communicate with each other via HTTPS requests:

* The Client Side, that represents both the Smart Calendar (installed on the user's smartphone) and the user's device storage.

* The Server Side, where SIGARRA's calendar and the user's timetable are stored and need to be retrieved from.

The connection is done only when needed in order to reduce the time wasted in HTTP requests, making the app run faster and smoother.
When entering a new screen all data that's needed to build the interface is loaded and in case any of update to such data, another request is sent to the Smart Calendar server, also updating the information present there.
