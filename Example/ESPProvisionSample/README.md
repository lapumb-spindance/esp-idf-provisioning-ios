
# ESP-IDF Provisioning - iOS

  

ESP-IDF consists of a provisioning mechanism, which is used to provide network credentials and/or custom data to an ESP32, ESP32-S2 or ESP8266 device.

This repository contains the source code for the companion iOS app for this provisioning mechanism.

  

This is licensed under Apache 2.0. The complete license for the same can be found in the LICENSE file.

  

## Setup

  

To build this app, you will need a macOS development machines, with XCode installed. Make sure you have a developer account with Apple setup. More about the same can be found [here](https://developer.apple.com/support/compare-memberships/)

  

### Install Dependencies

  

#### Cocoapods

Make sure you have Cocoapods installed. Installation steps can be found on [cocoapods.org](https://cocoapods.org)

Now navigate to `ESPProvisionSample` directory from the root directory, and run -

  

```

pod install

```

  

This ensures that you have the following dependencies installed -

- ESPProvision

>Note: Update the `podfile` to use the path pointing to the ESPProvision directory from this fork. This fork directory contains logic to send custom data via a newly defined proto file.

  

## Build

  

There are multiple app variants that you can build using this repository. You can configure the right one by changing the key values of `ESP Application Setting` in Info.plist :

|Key  |Accepted Values  |Default  |Description   |
|:----:|:-------:|:------------:|:-------------:|
|`ESP Device Type`|`Both`, `BLE`, `SoftAP`|`Both`|Defines the transport mechanism app will use for provisioning|
|`ESP Securtiy Mode`|`secure`, `unsecure`|`secure`|Defines whether the communication with device is encrypted or unsecure |
|`ESP Enable Setting`|`true`, `false`|`true`|Set this as false if you want device type and security mode does not change while running the app|
|`ESP Allow QR Code Scan`|`true`, `false`|`true`|Set false when QR code is not available or supported for device|
|`ESP Allow Prefix Search`|`true`, `false`|`true`|Set false when search by prefix is not required for BLE devices|




## Building for SpinDance

- Make sure you are part of the SpinDance development team
- Ensure the signing capabilities are up to date
>Note: Because of changes made in order to customize and lack of time, images will not load.

### Navigate to Custom Data

- Connect to your ESP device as normal
- Enter the POP and choose the "Send Custom Data" after selecting `Next`
- Enter a key, string data, and/or integer data and press send
>Note: The custom data handler expects a response to be returned. If a response is not returned, `Cancel` must be pressed to disconnect from the peripheral device.
  

# Resources

  

* Documentation for the latest version: https://docs.espressif.com/projects/esp-idf/. This documentation is built from the [docs directory](docs) of this repository.

  

* The [esp32.com forum](https://esp32.com/) is a place to ask questions and find community resources.

  

* [Check the Issues section on github](https://github.com/espressif/esp-idf/issues) if you find a bug or have a feature request. Please check existing Issues before opening a new one.

  

* If you're interested in contributing to ESP-IDF, please check the [Contributions Guide](https://docs.espressif.com/projects/esp-idf/en/latest/contribute/index.html).
