/*
 * MIT License
 *
 * Copyright (c) 2022 esp32beans@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

// The button offsets and HID report struct are for the
// "Fortune Key/Game" BLE joystick. Other similar looking devices may use
// different values or not support analog.
//
// Note: This code is for the more expensive upgrade version.
// The device supports analog thumbstick in Game mode. I do not know if the
// cheaper version does or not.
// https://www.amazon.com/dp/B09QJLV6JJ

#include "BLE_Client_Joystick.h"

BLE_Client_Joystick BLE_Joystick;

void movement(int x, int y)
{
  Serial.printf("move(%d, %d)\r\n", x, y);
}

void button_A(bool pressed)
{
  Serial.print("Button A ");
  if (pressed) {
    Serial.println("pressed");
  }
  else {
    Serial.println("released");
  }
}

void connection(bool connected)
{
  Serial.print("Joystick is ");
  if (!connected) {
    Serial.println("not ");
  }
  Serial.println("connected");
}

void setup ()
{
  Serial.begin(115200);

  Serial.println("Starting BLE HID Joystick client");
  BLE_Joystick.set_connect_callback(connection);
  BLE_Joystick.set_movement_callback(movement);
  BLE_Joystick.set_button_A_callback(button_A);
  BLE_Joystick.begin();
}


void loop ()
{
  BLE_Joystick.loop();
}
