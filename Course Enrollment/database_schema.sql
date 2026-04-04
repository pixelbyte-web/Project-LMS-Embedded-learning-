-- Course Enrollment System Database Schema
-- MySQL Implementation

CREATE DATABASE IF NOT EXISTS course_enrollment_system;
USE course_enrollment_system;

-- Courses Table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    level VARCHAR(50) DEFAULT 'Beginner',
    duration_hours INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_title (title)
);

-- Course Content / Lessons Table
CREATE TABLE course_content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    section_title VARCHAR(200) NOT NULL,
    lesson_order INT NOT NULL DEFAULT 1,
    lesson_title VARCHAR(200) NOT NULL,
    lesson_body TEXT,
    lesson_type VARCHAR(50) DEFAULT 'reading',
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    INDEX idx_course_order (course_id, lesson_order)
);

-- Students Table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enrollments Table
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id),
    INDEX idx_student (student_id),
    INDEX idx_course (course_id)
);

-- Lesson Progress Table
CREATE TABLE lesson_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES course_content(id) ON DELETE CASCADE,
    UNIQUE KEY unique_progress (student_id, lesson_id)
);

-- ─────────────────────────────────────────────
-- Sample Students
-- ─────────────────────────────────────────────
INSERT INTO students (first_name, last_name, email) VALUES
('Alice', 'Johnson', 'alice.j@student.edu'),
('Bob', 'Miller', 'bob.m@student.edu'),
('Carol', 'White', 'carol.w@student.edu'),
('David', 'Taylor', 'david.t@student.edu'),
('Emma', 'Brown', 'emma.b@student.edu');

-- ─────────────────────────────────────────────
-- IoT Learning Path Courses (6 courses)
-- ─────────────────────────────────────────────
INSERT INTO courses (title, description, category, level, duration_hours) VALUES
('Electronics & Circuits',
 'Master the building blocks of all electronic systems. Learn voltage, current, resistance, Ohms Law, and how to build and read basic circuits on a breadboard.',
 'IoT', 'Beginner', 8),
('Introduction to MCUs',
 'Understand what microcontrollers are, how they differ from general-purpose computers, and how they power embedded systems. Covers architecture, memory, GPIO, and timing.',
 'IoT', 'Beginner', 10),
('Arduino Programming',
 'Hands-on embedded programming using the Arduino platform and C/C++. Build real projects: LED control, button input, serial communication, PWM, and I2C/SPI peripherals.',
 'IoT', 'Intermediate', 14),
('Raspberry Pi Fundamentals',
 'Set up and use a Raspberry Pi running Linux. Learn GPIO programming with Python, run services, connect peripherals, and use the Pi as an IoT gateway.',
 'IoT', 'Intermediate', 12),
('ESP32 / ESP8266 IoT Applications',
 'Program the ESP32 and ESP8266 Wi-Fi modules to build connected IoT devices. Covers Wi-Fi, Bluetooth, MQTT, deep-sleep, and cloud integration.',
 'IoT', 'Advanced', 16),
('Sensors & Actuators',
 'Integrate the physical world into your IoT projects. Learn to wire and program temperature, humidity, motion, ultrasonic, and gas sensors, plus control motors and relays.',
 'IoT', 'Advanced', 12);

-- ─────────────────────────────────────────────
-- Lessons: Electronics & Circuits (course_id=1)
-- ─────────────────────────────────────────────
INSERT INTO course_content (course_id, section_title, lesson_order, lesson_title, lesson_body, lesson_type) VALUES
(1,'Foundations',1,'What is Electricity?',
'Electricity is the flow of electric charge through a conductor.\n\nKey Concepts:\n- Charge (Q): Measured in Coulombs.\n- Current (I): Rate of charge flow, measured in Amperes (A). 1A = 1 Coulomb/second.\n- Voltage (V): Electrical potential difference that drives current.\n- Resistance (R): Opposition to current flow, measured in Ohms.\n\nOhms Law: V = I x R\n\nThis equation governs most basic circuit analysis. Know any two values and you can calculate the third.','reading'),

(1,'Foundations',2,'Basic Circuit Components',
'Every circuit is built from a small set of fundamental components.\n\nResistors limit current flow. A 220 ohm resistor is commonly used with LEDs.\n\nCapacitors store energy in an electric field. Used for filtering and timing circuits.\n\nDiodes allow current to flow in only one direction. LEDs emit light when forward biased.\n\nTransistors act as electronic switches or amplifiers. The BJT and MOSFET are the two main types.\n\nPractical Tip: Always check component polarity before connecting to power. Reversed polarity can destroy components instantly.','reading'),

(1,'Foundations',3,'Reading Schematics',
'A schematic is a diagram that uses standard symbols to represent electronic circuits.\n\nCommon Symbols:\n- Battery: Two parallel lines (long = positive, short = negative)\n- Resistor: Zigzag line (US) or rectangle (EU)\n- Capacitor: Two parallel lines\n- Ground (GND): Triangle pointing down\n- LED: Diode symbol with arrows pointing away\n\nReading a circuit: Follow the path from the positive terminal of the power supply, through components, back to GND. Current flows in a complete loop.','reading'),

(1,'Breadboards & Prototyping',4,'Using a Breadboard',
'A breadboard lets you build circuits without soldering.\n\nHow Breadboards Work:\n- The long rows (+ and -) are power rails -- all holes in each rail are connected.\n- Inner columns are connected in groups of 5 holes.\n- Insert component legs into the same row to connect them.\n\nYour First Circuit: LED with Resistor\n1. Connect 5V to + rail, GND to - rail.\n2. Place a 220 ohm resistor from + rail to row 10.\n3. Place LED with longer leg (anode) in row 10, shorter leg (cathode) in row 11.\n4. Connect row 11 to - rail.\n5. Apply power -- LED lights up.','lab'),

(1,'Breadboards & Prototyping',5,'Measuring with a Multimeter',
'A multimeter is your primary diagnostic tool.\n\nKey Modes:\n- DC Voltage: Red probe to positive, black to GND.\n- Resistance: Measure with power OFF.\n- Continuity: Beep = connected.\n- DC Current: Meter placed IN SERIES with circuit.\n\nSafety Rules:\n1. Never measure resistance in a powered circuit.\n2. Start on the highest range and work down.\n3. Check probe connections before switching modes.','lab');

-- ─────────────────────────────────────────────
-- Lessons: Introduction to MCUs (course_id=2)
-- ─────────────────────────────────────────────
INSERT INTO course_content (course_id, section_title, lesson_order, lesson_title, lesson_body, lesson_type) VALUES
(2,'MCU Basics',1,'What is a Microcontroller?',
'A microcontroller (MCU) is a compact integrated circuit containing a processor, memory, and I/O peripherals on a single chip.\n\nMCU vs Microprocessor vs Computer:\n- MCU: On-chip RAM (KB), on-chip Flash, GPIO/PWM/ADC built in, no OS required.\n- Microprocessor: External GB RAM, limited I/O, usually needs an OS.\n- Computer: Full OS, external storage, general purpose.\n\nMCUs run one dedicated program (firmware) that controls a specific device.\n\nPopular MCU Families: AVR (Arduino), ARM Cortex-M (STM32), Xtensa (ESP32), PIC (Microchip)','reading'),

(2,'MCU Basics',2,'GPIO -- General Purpose Input/Output',
'GPIO pins are the MCUs connection to the physical world.\n\nOutput Mode: Drive pin HIGH (3.3V or 5V) or LOW (0V) to control LEDs, relays.\n\nInput Mode: Read HIGH or LOW voltage applied to pin.\n- Pull-up resistor: Pin reads HIGH by default, LOW when connected to GND.\n- Pull-down resistor: Pin reads LOW by default.\n\nKey Parameters:\n- Logic Level: Most modern MCUs use 3.3V. Arduino Uno uses 5V. Never connect 5V to 3.3V MCU pins without a level shifter.\n- Drive Current: Each GPIO typically sources/sinks 8-40mA. Check the datasheet.','reading'),

(2,'MCU Basics',3,'Memory Types in MCUs',
'MCUs have several types of memory, each with a different purpose.\n\nFlash (Program Memory): Non-volatile. Stores your firmware. Survives power loss. Typical size: 32KB-4MB.\n\nSRAM (Data Memory): Volatile RAM for variables and call stack. Lost on power off. Typical size: 2KB-512KB.\n\nEEPROM: Non-volatile, for configuration data that changes occasionally. Slower to write than SRAM.\n\nTip: A common mistake is running out of SRAM, not Flash. Large String literals consume SRAM quickly. On AVR Arduinos, store constants in Flash using the F() macro: Serial.println(F("Hello"));','reading'),

(2,'Peripherals',4,'Timers and PWM',
'Timers are hardware counters inside the MCU that run independently of the CPU.\n\nUsed for:\n- Generating precise delays without blocking the CPU\n- Measuring time between events\n- Generating PWM signals\n\nPWM -- Pulse Width Modulation:\nPWM rapidly switches a digital pin ON and OFF. The ratio of ON time to total period is the duty cycle.\n- 0% duty cycle: pin always LOW, LED fully off\n- 50% duty cycle: LED at half brightness\n- 100% duty cycle: LED fully on\n\nSwitching faster than eye can perceive (490Hz-20kHz) creates an average brightness. PWM also controls motor speed.','reading'),

(2,'Peripherals',5,'ADC -- Reading Analog Signals',
'The ADC converts a continuous analog voltage into a digital number.\n\nResolution: A 10-bit ADC produces 0-1023. A 12-bit ADC produces 0-4095.\n\nReference Voltage (VREF): The voltage that corresponds to the maximum ADC reading.\nExample with VREF=3.3V, 12-bit:\n- 0V input -> ADC reads 0\n- 3.3V input -> ADC reads 4095\n- 1.65V input -> ADC reads ~2047\n\nFormula: Voltage = (ADC_value / max_value) x VREF\n\nPractical Notes:\n- ADC pins cannot tolerate voltages above VREF.\n- Average multiple readings for better accuracy.','reading');

-- ─────────────────────────────────────────────
-- Lessons: Arduino Programming (course_id=3)
-- ─────────────────────────────────────────────
INSERT INTO course_content (course_id, section_title, lesson_order, lesson_title, lesson_body, lesson_type) VALUES
(3,'Getting Started',1,'The Arduino Ecosystem',
'Arduino is an open-source electronics platform combining easy-to-use hardware and software.\n\nKey Arduino Boards:\n- Uno R3: ATmega328P, 5V, 14 digital pins, 6 analog inputs, 32KB Flash, 2KB SRAM.\n- Nano: Compact Uno-compatible.\n- Mega 2560: More pins and memory.\n- Leonardo: Built-in USB HID.\n\nSketch Structure:\nvoid setup() {\n  // Runs once at startup\n}\nvoid loop() {\n  // Runs forever after setup\n}','reading'),

(3,'Getting Started',2,'Digital I/O and Blink',
'Your first Arduino program: blink an LED.\n\nPin Modes:\n  pinMode(13, OUTPUT);\n  pinMode(2, INPUT_PULLUP);\n\nWriting and Reading:\n  digitalWrite(13, HIGH); // LED on\n  delay(1000);\n  digitalWrite(13, LOW);  // LED off\n  delay(1000);\n  int state = digitalRead(2); // Read button\n\nChallenge: Modify the sketch so the LED blinks faster when a button is held down.','lab'),

(3,'Communication',3,'Serial Communication',
'Serial lets your Arduino send and receive data over USB.\n\n  Serial.begin(9600);\n  Serial.println("Arduino ready!");\n\n  int val = analogRead(A0);\n  Serial.print("Sensor: ");\n  Serial.println(val);\n\n  if (Serial.available() > 0) {\n    char cmd = Serial.read();\n    if (cmd == H) digitalWrite(13, HIGH);\n    if (cmd == L) digitalWrite(13, LOW);\n  }\n\nOpen the Serial Monitor (Ctrl+Shift+M) in the Arduino IDE, set baud to 9600.','lab'),

(3,'Communication',4,'I2C Protocol',
'I2C is a two-wire protocol (SDA + SCL) for connecting multiple devices to one MCU.\n\nKey Facts:\n- Up to 127 devices on the same two wires\n- Each device has a unique 7-bit address\n- Arduino Uno: SDA = A4, SCL = A5\n\nExample: BMP280 pressure sensor\n  #include <Wire.h>\n  #include <Adafruit_BMP280.h>\n  Adafruit_BMP280 bmp;\n  bmp.begin(0x76);\n  Serial.println(bmp.readTemperature());','lab'),

(3,'Projects',5,'Capstone: Weather Station',
'Build a weather station that reads temperature and humidity, displays on LCD, and logs over Serial.\n\nComponents:\n- Arduino Uno\n- DHT22 temperature/humidity sensor\n- 16x2 I2C LCD display\n- 10k ohm resistor, breadboard, wires\n\nWiring:\n- DHT22: VCC->5V, GND->GND, DATA->pin 7, 10k pull-up on DATA\n- LCD: SDA->A4, SCL->A5, VCC->5V, GND->GND\n\nProject Goals:\n1. Display temperature on LCD line 1\n2. Display humidity on LCD line 2\n3. Log values over Serial every 5 seconds\n4. Extension: Flash LED if temperature exceeds 30 degrees','project');

-- ─────────────────────────────────────────────
-- Lessons: Raspberry Pi Fundamentals (course_id=4)
-- ─────────────────────────────────────────────
INSERT INTO course_content (course_id, section_title, lesson_order, lesson_title, lesson_body, lesson_type) VALUES
(4,'Setup & Linux',1,'Setting Up Your Raspberry Pi',
'The Raspberry Pi is a full Linux computer on a credit-card-sized board.\n\nSetup Steps:\n1. Download Raspberry Pi Imager from raspberrypi.com\n2. Flash Raspberry Pi OS (64-bit) to a microSD card (16GB+)\n3. In Imager settings: set hostname, username, password, enable SSH, configure Wi-Fi\n4. Insert SD card, connect HDMI and power\n5. SSH in: ssh pi@raspberrypi.local\n\nFirst Commands:\n  sudo apt update && sudo apt upgrade -y\n  raspi-config\n  df -h\n  free -h','lab'),

(4,'Setup & Linux',2,'Essential Linux Commands',
'The Raspberry Pi runs Linux. You control it through the terminal.\n\nNavigation:\n  pwd           -- Print current directory\n  ls -la        -- List files\n  cd /home/pi   -- Change directory\n  mkdir myproject\n\nFiles:\n  cp file.txt backup.txt\n  mv file.txt new_name.txt\n  rm file.txt\n  nano file.txt\n  cat file.txt\n\nSystem:\n  sudo command\n  ps aux\n  kill PID\n  systemctl status ssh\n  reboot','reading'),

(4,'GPIO with Python',3,'GPIO Control with Python',
'Use Python and the RPi.GPIO library to control the 40-pin GPIO header.\n\n  import RPi.GPIO as GPIO\n  import time\n\n  LED_PIN = 18\n  GPIO.setmode(GPIO.BCM)\n  GPIO.setup(LED_PIN, GPIO.OUT)\n\n  try:\n    while True:\n      GPIO.output(LED_PIN, GPIO.HIGH)\n      time.sleep(1)\n      GPIO.output(LED_PIN, GPIO.LOW)\n      time.sleep(1)\n  except KeyboardInterrupt:\n    pass\n  finally:\n    GPIO.cleanup()\n\nWarning: Raspberry Pi GPIO pins are 3.3V only. Never connect 5V signals directly.','lab'),

(4,'Services & Networking',4,'Running Scripts as Services',
'A systemd service starts your Python script automatically on boot.\n\nCreate service file at /etc/systemd/system/myapp.service:\n\n  [Unit]\n  Description=My IoT App\n  After=network.target\n\n  [Service]\n  ExecStart=/usr/bin/python3 /home/pi/myapp/main.py\n  WorkingDirectory=/home/pi/myapp\n  Restart=always\n  User=pi\n\n  [Install]\n  WantedBy=multi-user.target\n\nEnable and start:\n  sudo systemctl daemon-reload\n  sudo systemctl enable myapp\n  sudo systemctl start myapp\n  sudo systemctl status myapp','lab');

-- ─────────────────────────────────────────────
-- Lessons: ESP32 / ESP8266 IoT (course_id=5)
-- ─────────────────────────────────────────────
INSERT INTO course_content (course_id, section_title, lesson_order, lesson_title, lesson_body, lesson_type) VALUES
(5,'ESP32 Basics',1,'Introduction to ESP32',
'The ESP32 is a powerful, low-cost Wi-Fi + Bluetooth microcontroller by Espressif Systems.\n\nKey Features:\n- Dual-core 240MHz Xtensa LX6 processor\n- 520KB SRAM, up to 4MB Flash\n- Wi-Fi 802.11 b/g/n (2.4GHz)\n- Bluetooth 4.2 + BLE\n- 34 GPIO pins, 18x ADC, 2x DAC\n- Hardware encryption\n- Ultra-low-power deep-sleep\n\nvs ESP8266: Single core, less RAM, no Bluetooth, fewer GPIOs. Still useful for simple Wi-Fi projects.\n\nDevelopment Options: Arduino IDE, MicroPython, ESP-IDF, PlatformIO','reading'),

(5,'Wi-Fi & Networking',2,'Connecting to Wi-Fi',
'Connecting the ESP32 to Wi-Fi:\n\n  #include <WiFi.h>\n  const char* ssid = "YourNetwork";\n  const char* password = "YourPassword";\n\n  WiFi.begin(ssid, password);\n  while (WiFi.status() != WL_CONNECTED) {\n    delay(500);\n  }\n  Serial.println(WiFi.localIP());\n\n  // Reconnect if lost\n  if (WiFi.status() != WL_CONNECTED) {\n    WiFi.reconnect();\n  }\n\nTip: Store credentials in config.h and add to .gitignore -- never commit Wi-Fi passwords to version control.','lab'),

(5,'MQTT & Cloud',3,'MQTT Protocol for IoT',
'MQTT is the standard lightweight publish/subscribe messaging protocol for IoT.\n\nConcepts:\n- Broker: Central server (e.g., Mosquitto, HiveMQ, AWS IoT Core)\n- Topic: Hierarchical channel e.g. home/livingroom/temperature\n- Publish: Device sends data to a topic\n- Subscribe: Device listens for messages on a topic\n\nESP32 with PubSubClient:\n  #include <PubSubClient.h>\n  client.setServer("broker.hivemq.com", 1883);\n  client.connect("ESP32_Device");\n  client.subscribe("home/commands");\n  client.publish("home/temperature", "24.5");\n  client.loop(); // Call in loop()','reading'),

(5,'Power & Sleep',4,'Deep Sleep and Power Optimisation',
'Deep sleep reduces ESP32 current from ~240mA to as low as 10 microamps.\n\nDeep Sleep Pattern:\n  #include <esp_sleep.h>\n\n  void setup() {\n    // Do work (read sensor, send data)\n    doWork();\n\n    // Sleep for 30 seconds\n    esp_sleep_enable_timer_wakeup(30 * 1000000ULL);\n    Serial.flush();\n    esp_deep_sleep_start();\n    // Code below never runs -- chip resets on wake\n  }\n\nPower Tips:\n- Disable Wi-Fi when not needed: WiFi.mode(WIFI_OFF)\n- Reduce CPU frequency: setCpuFrequencyMhz(80)\n- Use low-power sensors','lab');

-- ─────────────────────────────────────────────
-- Lessons: Sensors & Actuators (course_id=6)
-- ─────────────────────────────────────────────
INSERT INTO course_content (course_id, section_title, lesson_order, lesson_title, lesson_body, lesson_type) VALUES
(6,'Environmental Sensors',1,'Temperature & Humidity: DHT22',
'The DHT22 is a popular digital temperature and humidity sensor.\n\nSpecifications:\n- Temperature: -40C to +80C, accuracy +-0.5C\n- Humidity: 0-100% RH, accuracy +-2-5%\n- Sampling rate: Once every 2 seconds\n\nWiring:\n  Pin 1 (VCC) -> 3.3V or 5V\n  Pin 2 (DATA) -> MCU GPIO + 10k pull-up to VCC\n  Pin 4 (GND) -> GND\n\nArduino code:\n  #include <DHT.h>\n  DHT dht(7, DHT22);\n  dht.begin();\n  float t = dht.readTemperature();\n  float h = dht.readHumidity();','lab'),

(6,'Environmental Sensors',2,'Distance: HC-SR04 Ultrasonic',
'The HC-SR04 measures distance by emitting a 40kHz ultrasonic pulse and measuring echo return time.\n\nSpecifications:\n- Range: 2cm - 400cm, Accuracy: +-3mm\n- Voltage: 5V, Interface: TRIG and ECHO pins\n\nPhysics: Distance = (time x 343 m/s) / 2\n\nArduino code:\n  pinMode(TRIG_PIN, OUTPUT);\n  pinMode(ECHO_PIN, INPUT);\n  digitalWrite(TRIG_PIN, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(TRIG_PIN, LOW);\n  long duration = pulseIn(ECHO_PIN, HIGH);\n  float distance = (duration * 0.0343) / 2.0;\n  Serial.println(distance);','lab'),

(6,'Motion & Presence',3,'PIR Motion Sensor',
'A PIR (Passive InfraRed) sensor detects changes in IR radiation caused by a warm moving body.\n\nHC-SR501 Features:\n- Adjustable sensitivity and hold time\n- Jumper for single or repeated trigger mode\n- Voltage: 5V-20V, Output: 3.3V or 5V digital\n- Needs ~30 seconds of calibration time on power-up\n\nArduino code:\n  pinMode(PIR_PIN, INPUT);\n  delay(30000); // warm-up\n\n  void loop() {\n    if (digitalRead(PIR_PIN) == HIGH) {\n      Serial.println("Motion detected!");\n    }\n  }','lab'),

(6,'Actuators',4,'Controlling DC Motors with L298N',
'The L298N dual H-bridge motor driver lets an MCU safely control DC motors.\n\nWhy a driver? DC motors draw 200mA-2A+, far more than any GPIO pin (max ~40mA). The L298N buffers power using a separate motor supply.\n\nConnections:\n  IN1, IN2 -> Arduino digital pins (direction)\n  ENA -> Arduino PWM pin (speed)\n  OUT1, OUT2 -> Motor terminals\n  12V -> Motor power supply\n  GND -> Common ground\n\nCode:\n  void setMotor(int speed, bool forward) {\n    analogWrite(ENA, speed); // 0-255\n    digitalWrite(IN1, forward ? HIGH : LOW);\n    digitalWrite(IN2, forward ? LOW : HIGH);\n  }','lab'),

(6,'Actuators',5,'Relay Module for Mains Control',
'A relay is an electrically operated switch. A low-power MCU signal switches high-power AC circuits.\n\nSafety Warning: Mains voltage (110V/230V AC) is lethal. Only work with mains wiring if qualified.\n\n5V Relay Module:\n- Control: VCC (5V), GND, IN (signal from MCU)\n- Switched: COM, NO (Normally Open), NC (Normally Closed)\n- Optocoupler isolates MCU from high-voltage side\n- Most modules are active-LOW (relay ON when IN = LOW)\n\nCode:\n  pinMode(RELAY_PIN, OUTPUT);\n  digitalWrite(RELAY_PIN, HIGH); // OFF (active-LOW)\n  delay(5000);\n  digitalWrite(RELAY_PIN, LOW);  // ON\n  delay(5000);','lab');

-- ─────────────────────────────────────────────
-- Sample Enrollments
-- ─────────────────────────────────────────────
INSERT INTO enrollments (student_id, course_id) VALUES
(1,1),(1,2),(2,1),(2,3),(3,2),(3,4),(4,1),(5,5);
