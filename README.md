# Valify iOS Task

This project is a Cocoa Touch framework designed to integrate with an iOS application, providing a seamless selfie capture and approval flow for digital onboarding experiences.

## Task Overview

The goal of this project is to create a framework that enables users to detect faces using `Vision` and then capture a selfie, review the captured image, and approve or recapture it. Once approved, the framework dismisses and sends the image back to the host app via delegates.

## Features

- **Selfie Capture Screen**: Utilizes `AVFoundation` to display a camera interface with a capture button, and `Vision` to detect faces on camera and limits capturing photos when there is only one face detected.
- **Image Review Screen**: Allows users to view the captured image and either approve or retake the selfie.
- **Image Approval Flow**: Sends the approved image to the host application through delegate methods.
- **Face Detection (Bonus)**: Prevents the user from capturing an image if no human face is detected, using Google's ML Kit (I've used `Vision`).

