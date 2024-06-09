## Traffic Signal Controller

This project implements a Traffic Signal Controller as a finite state machine (FSM) to manage signals at an intersection of Highway and Country Road.

### Key Features

- **Priority System**: Highway has higher priority over Country Road.
- **Sensor-Driven**: A sensor on Country Road detects vehicles:
  - **High**: Car detected.
  - **Low**: No car detected.
 
<p align="center">
  <img src="https://github.com/KeshavBaldeva/Traffic-Signal-Controller/assets/152970391/84ecbaa0-696f-4a19-8c94-f1c02d2f2938" />
</p>

### Signal Behavior

1. **Highway Green**:
   - Stays green for at least 60 seconds.
   - Remains green indefinitely if no car is detected on Country Road.

2. **Car Detected on Country Road**:
   - Highway turns yellow for 10 seconds, then red.
   - Country Road turns green after Highway turns red.

3. **Country Road Green**:
   - Stays green for up to 30 seconds or until no car is detected.
   - Turns yellow for 10 seconds before switching to red.

4. **Cycle Reset**:
   - Highway returns to green after Country Road turns red.

This system ensures smooth traffic flow, prioritizing the Highway while accommodating Country Road vehicles when detected.
