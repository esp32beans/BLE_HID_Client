#include <Arduino.h>
#include <NimBLEDevice.h>

enum JOY_BUTTONS {
  JOY_A = 11,
  JOY_B = 7,
  JOY_X = 3,
  JOY_Y = 4,
  JOY_MENU = 10,
  JOY_BACK = 1,
  JOY_OK = 0
};

typedef void (*button_callback_t)(bool);
typedef void (*movement_callback_t)(int, int);
typedef void (*connect_callback_t)(bool);

class BLE_Client_Joystick {
 public:
    BLE_Client_Joystick() {
      movement_function = NULL;
      connection_function = NULL;
      memset(button_functions, 0, sizeof(button_functions));
    }

    ~BLE_Client_Joystick() {}
    void begin();
    void end() {}
    void loop();
    void set_connect_callback(connect_callback_t f) { connection_function = f; }
    connect_callback_t get_connect_callback() { return connection_function; }
    void set_button_A_callback(button_callback_t f) {
      button_functions[JOY_A] = f;
    }
    void set_button_B_callback(button_callback_t f) {
      button_functions[JOY_B] = f;
    }
    void set_button_X_callback(button_callback_t f) {
      button_functions[JOY_X] = f;
    }
    void set_button_Y_callback(button_callback_t f) {
      button_functions[JOY_Y] = f;
    }
    void set_button_menu_callback(button_callback_t f) {
      button_functions[JOY_MENU] = f;
    }
    void set_button_back_callback(button_callback_t f) {
      button_functions[JOY_BACK] = f;
    }
    void set_button_OK_callback(button_callback_t f) {
      button_functions[JOY_OK] = f;
    }
    button_callback_t get_button_callback(size_t button) {
        if (button > JOY_A) return NULL;
        return button_functions[button];
    }
    void set_movement_callback(movement_callback_t f) { movement_function = f; }
    movement_callback_t get_movement_callback() { return movement_function; }

 private:
    button_callback_t button_functions[16];
    movement_callback_t movement_function;
    connect_callback_t connection_function;
};

