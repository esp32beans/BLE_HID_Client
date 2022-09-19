# ESP32 NimBLE HID Client

This demo configures ESP32 NimBLE as a BLE client/central which connects to BLE
HID servers/peripherals such as BLE mice. It has been tested with
[ESP32-NimBLE-Mouse](https://github.com/wakwak-koba/ESP32-NimBLE-Mouse) and
a real BLE trackball mouse.

The mouse input parameters (for example, x, y, buttons) can be used to control
motors, servos, and LEDs.

## Libraries

Install the following use the Arduino IDE Library Manager.

* "NimBLE-Arduino" by h2zero

## Examples

The sketch code has been moved to the examples directory.

### BLE_HID_Joystick

Arduino library for a BLE Gamepad/Joystick. The BLE HID code is moved
into BLE_Client_Joystick.cpp/.h. The example sketch is now very short
with callback functions for stick movement and button presses.

### BLE_HID_Client

The original BLE HID client demo.

The following HID devices work.

* ESP32 running ESP32-NimBLE-Mouse
* BLE Trackball mouse https://www.amazon.com/dp/B09HHHDZZG/
* Microsoft Bluetooth Mouse https://www.amazon.com/dp/B07Y41YMMJ/
* BLE Gamepad/Joystick https://www.amazon.com/dp/B09QJLV6JJ/

### BLE_HID_Mouse_USB

This demo converts BLE mouse movements and button clicks to USB mouse.
Works with a real trackball mouse. Must use an ESP32 S3 to get BLE and
USB on the same board. ESP32 S2 has USB but not BLE. ESP32 original has
BLE but not USB.

WARNING: sendReport.patch is required to add USBHIDMouse::sendReport.

Works with the following.
* ESP32 running ESP32-NimBLE-Mouse
* BLE Trackball mouse https://www.amazon.com/dp/B09HHHDZZG/

## Sample output from BLE_HID_Client

The BLE mouse is actually another ESP32 running ESP32-NimBLE-Mouse.

```
Starting scan
Advertised Device found: Name: ESP32-Mouse, Address: 4c:75:25:xx:yy:zz, appearance: 962, serviceUUID: 0x1812
Found HID device
Scan Ended
Connected
Reconnected client
Connected to: 4c:75:25:xx:yy:zz
RSSI: -39
0x2a4d Value: 
HID_REPORT_MAP 0x2a4b Value: 5,1,9,2,A1,1,9,1,A1,0,5,9,19,1,29,5,15,0,25,1,75,1,95,5,81,2,75,3,95,1,81,3,5,1,9,30,9,31,9,38,15,81,25,7F,75,8,95,3,81,6,5,C,A,38,2,15,81,25,7F,75,8,95,1,81,6,C0,C0,
Done with this device!
Success! we should now be getting notifications!
Notification from 4c:75:25:xx:yy:zz: Service = 0x1812, Characteristic = 0x2a4d, Value = 1,0,0,0,0, buttons: 0x01 x: 0 y: 0 wheel: 0 hwheel:0
Notification from 4c:75:25:xx:yy:zz: Service = 0x1812, Characteristic = 0x2a4d, Value = 0,0,0,0,0, buttons: 0x00 x: 0 y: 0 wheel: 0 hwheel:0
```

The HID_REPORT_MAP is a HID report descriptor. Pasting the hex digits into
http://eleccelerator.com/usbdescreqparser/ produces the following.
```
0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
0x09, 0x02,        // Usage (Mouse)
0xA1, 0x01,        // Collection (Application)
0x09, 0x01,        //   Usage (Pointer)
0xA1, 0x00,        //   Collection (Physical)
0x05, 0x09,        //     Usage Page (Button)
0x19, 0x01,        //     Usage Minimum (0x01)
0x29, 0x05,        //     Usage Maximum (0x05)
0x15, 0x00,        //     Logical Minimum (0)
0x25, 0x01,        //     Logical Maximum (1)
0x75, 0x01,        //     Report Size (1)
0x95, 0x05,        //     Report Count (5)
0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
0x75, 0x03,        //     Report Size (3)
0x95, 0x01,        //     Report Count (1)
0x81, 0x03,        //     Input (Const,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
0x09, 0x30,        //     Usage (X)
0x09, 0x31,        //     Usage (Y)
0x09, 0x38,        //     Usage (Wheel)
0x15, 0x81,        //     Logical Minimum (-127)
0x25, 0x7F,        //     Logical Maximum (127)
0x75, 0x08,        //     Report Size (8)
0x95, 0x03,        //     Report Count (3)
0x81, 0x06,        //     Input (Data,Var,Rel,No Wrap,Linear,Preferred State,No Null Position)
0x05, 0x0C,        //     Usage Page (Consumer)
0x0A, 0x38, 0x02,  //     Usage (AC Pan)
0x15, 0x81,        //     Logical Minimum (-127)
0x25, 0x7F,        //     Logical Maximum (127)
0x75, 0x08,        //     Report Size (8)
0x95, 0x01,        //     Report Count (1)
0x81, 0x06,        //     Input (Data,Var,Rel,No Wrap,Linear,Preferred State,No Null Position)
0xC0,              //   End Collection
0xC0,              // End Collection

// 67 bytes

// best guess: USB HID Report Descriptor
```

The Notification lines appear when a button is pressed and released on the
ESP32 mouse or trackball mouse.

## Warning if using ESP32 S3

Arduino-esp32 2.0.4 works fine except for a few problems with ESP32 S3.
If you are not planning to use ESP32 S3, just use the latest stable
release. If you have problems with ESP32 S3, try the previous release,
2.0.3.

Arduino-esp32 2.0.5 seems to work fine on ESP32 S3 when using
BLE_HID_Mouse_USB.
