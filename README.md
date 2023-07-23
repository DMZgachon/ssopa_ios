
# SSOPA - A Comfortable Space for High School Students

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Overview

SSOPA (Korean: 쏘파) is a mobile application built with Swift that aims to create a comfortable space for high school students to share their ideas, post articles, and engage in open anonymous chatting with others. The name "SSOPA" derives from the Korean word for "couch," symbolizing the comfort and ease with which students can interact within the app.

## Features

- **Share Ideas:** High school students can post articles to share their thoughts, experiences, or knowledge with others within the SSOPA community.

- **Leave Comments:** Users have the ability to leave comments on the articles posted, encouraging discussions and interactions among the student community.

- **Open Chatting:** SSOPA offers an open chatting feature that allows students to join chat rooms anonymously and engage in real-time conversations with peers. This feature is implemented using WebSocket technology, providing fast and efficient communication.

- **Push Notifications:** SSOPA leverages the power of Apple Push Notification Service (APNS) to deliver timely and important updates to users. Users will receive notifications for new article postings, replies to their comments, and other relevant events to stay engaged with the SSOPA community.

- **SMS Verification:** During the user registration process, users will be asked to provide their cell phone numbers. To ensure a secure and trustworthy user base, SSOPA implements SMS verification. A verification code will be sent to the provided phone number, and users will need to enter the code in the app to complete the registration process successfully.

## Communication with Server

SSOPA communicates with the server using the secure HTTPS protocol and follows RESTful API principles for data exchange. The use of HTTPS ensures that all data transmitted between the SSOPA app and the server is encrypted, providing a secure and private communication channel.

The RESTful API design in SSOPA ensures a standardized and efficient way of accessing and manipulating resources on the server. This approach allows for consistent and predictable interactions with the backend, making it easier to develop and maintain the app.

## Screenshots

_Insert some attractive screenshots or GIFs showcasing your app's user interface and features._

## Installation

1. Clone this repository to your local machine.
   ```
   git clone https://github.com/your-username/SSOPA.git
   ```

2. Open the project in Xcode by double-clicking the `.xcodeproj` file.

3. Build and run the app on a simulator or physical device.

## Requirements

- iOS 13.0+
- Xcode 12.0+

## Dependencies

- [StompClientLib](https://github.com/WrathChaos/StompClientLib): SSOPA uses the StompClientLib as a WebSocket client library to handle the communication with the WebSocket server. This library simplifies the process of sending and receiving WebSocket messages, making it easier to implement real-time features in the app.

## WebSocket Server (Spring Boot)

SSOPA's open chatting feature is powered by a WebSocket server built using Spring Boot. The WebSocket technology enables real-time bidirectional communication between the mobile app and the server, allowing seamless and efficient chatting experiences for users.

To run the WebSocket server:

1. Clone the [WebSocket server repository](https://github.com/your-username/ssopa-websocket-server).
   ```
   git clone https://github.com/your-username/ssopa-websocket-server.git
   ```

2. Open the project in your preferred Java IDE.

3. Build and run the Spring Boot application.

## Push Notification

SSOPA utilizes Apple Push Notification Service (APNS) to send push notifications to users. To enable push notifications in your development and production environments, follow these steps:

1. Set up your Apple Developer account and create a new App ID for SSOPA.

2. Configure APNS certificates for both development and production environments.

3. In Xcode, configure the necessary capabilities and upload the appropriate certificates to enable push notifications for your app.

4. Update the server-side code to trigger push notifications when specific events occur (e.g., new article postings, comment replies).

## Contributions and Achievements

- Describe any major contributions you made to the project, such as implementing specific features or optimizing performance.

- Highlight your ability to work with a diverse team and your communication skills in collaborating on this project.

- Mention any awards, recognition, or positive feedback you received during the development process.

## Usage

_Explain how to use your app, the user flow, and the various features. Provide examples if necessary._

## Demonstration

_Link to a video or live demo of your app (if available) to allow potential employers to see the application in action._

## Future Improvements

_Provide insights into possible future improvements and features you plan to add to the SSOPA app. Show your ambition and dedication to enhancing the project._

## Contact

_For any inquiries or feedback, you can reach me at ksdk6145@gachon.ac.kr._

## Acknowledgments

_Optionally, you can acknowledge any contributors, libraries, or sources of inspiration here._

