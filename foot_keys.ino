#include <Keyboard.h>

struct Button {
  Button(int pin, int chr) : pin(pin), chr(chr) { }
 
  const int pin;
  
  void MaybeEmit() {
    int reading = digitalRead(pin);
 
    if (reading != last_button_state) {
      last_debounce_time = millis();
    }

    if ((millis() - last_debounce_time) > kDebounceDelay) {
      if (reading != current_button_state) {
        current_button_state = reading;

        if (current_button_state == LOW) {
          Keyboard.write(chr);
        }
      }
    }

    last_button_state = reading;
  }
 
 private:
  const int chr;

  int last_button_state = HIGH;
  int current_button_state = HIGH;
  unsigned long last_debounce_time = 0;
  const unsigned long kDebounceDelay = 50;
};

Button buttons[] {
  {2, '-'},  // Slower.
  {3, '+'},  // Faster and Start.
  {4, KEY_ESC},   // Stop.
  {5, ' '},  // Start/Stop video.
};

void setup() {
  for (const auto& btn : buttons) {
    pinMode(btn.pin, INPUT_PULLUP);
  }

  Keyboard.begin();
}

void loop() {
  // Send the keypresses for each button pressed.
  for (const auto& btn : buttons) {
    btn.MaybeEmit();
  }
}
