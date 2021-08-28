import time
from RPi import GPIO
import threading
import board
import busio
import datetime
#Sensor: Temp and Hum
import adafruit_dht
#Sensor: Light
import adafruit_tsl2591
#Sensor: Gas
import serial
import re
#LCD
import I2C_LCD_driver
from subprocess import check_output
#Led ring
import neopixel

from flask_cors import CORS
from flask_socketio import SocketIO, emit, send
from flask import Flask, jsonify
from repositories.DataRepository import DataRepository

# Custom endpoint
endpoint = '/api/v1'

# Code voor Hardware
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

#DHT22
dhtDevice = adafruit_dht.DHT22(board.D4)

#TSL2591
# Initialize the I2C bus.
i2c = busio.I2C(board.D3, board.D2)
# Initialize the sensor.
sensor = adafruit_tsl2591.TSL2591(i2c)
# LCD
lcd = I2C_LCD_driver.lcd()

# LEDRING
usercontrol = False #Will be using this to stop backend color changes by sensor values.
currentColor = None
RED = (255, 0, 0)
ORANGE = (255, 83, 7)
GREEN = (0, 255, 0)
pixels = neopixel.NeoPixel(board.D18, 24, brightness=0.2, auto_write=False, pixel_order=neopixel.GRB)

def read_temperature():
    time.sleep(10)
    print("temperature reading started!")
    while True:
        try:
            print(str(datetime.datetime.now()) + " - Sensor Read: TEMP (" + str(dhtDevice.temperature) + ")")
            DataRepository.add_temperature_record(dhtDevice.temperature)
        except Exception as ex:
            # Errors happen fairly often, DHT's are hard to read, just keep going
            print(ex)
        time.sleep(120)

def read_humdity():
    time.sleep(10)
    print("humidity reading started!")
    while True:
        try:
            print(str(datetime.datetime.now()) + " - Sensor Read: HUM (" + str(dhtDevice.humidity) + ")")
            DataRepository.add_humidity_record(dhtDevice.humidity)
        except Exception as ex:
            # Errors happen fairly often, DHT's are hard to read, just keep going
            print(ex)
        time.sleep(120)

def read_light():
    time.sleep(10)
    print("Light reading started!")
    while True:
        try:
            print(str(datetime.datetime.now()) + " - Sensor Read: LIGHT (" + str(round(sensor.lux, 2)) + ")")
            DataRepository.add_light_record(round(sensor.lux, 2)) 
        except Exception as ex:
            print(ex)
        time.sleep(120)

def read_gas():
    ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
    ser.flush()
    counter = 0
    while True:
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').rstrip()
            if(re.search('sensor_value:\d+.+', line)):
                counter += 1
                if(counter == 30):
                    counter = 0
                    arr = line.split(' ')
                    cm = arr[0][13:]
                    try:
                        print(str(datetime.datetime.now()) + " - Sensor Read: GAS (" + str(cm.rstrip()) + ")")
                        DataRepository.add_gas_record(cm.rstrip())
                    except Exception as ex:
                        print(ex)

def update_lcd():
    lcd.lcd_clear()
    time.sleep(30)
    while True:
        try:
            lcd.lcd_clear() 
            print("IP weergeven op lcd")
            ips = check_output(['hostname', '--all-ip-addresses']).split()
            print(ips)
            lcd.lcd_display_string(ips[0].decode()) 
        except Exception as ex:
            print(ex)
        time.sleep(60)

def evaluate():
    # Air Quality < 200 is safe
    # Humidity [30,60]%
    # Perfect temperatuur [20, 25.5]
    # light >50
    global usercontrol
    global currentColor
    while True:
        aq = DataRepository.get_amount_of_measurements_gas(1)
        hum = DataRepository.get_amount_of_measurements_humidity(1)
        temp = DataRepository.get_amount_of_measurements_temperature(1)
        light = DataRepository.get_amount_of_measurements_light(1)
        copyColor = currentColor

        print("BOOLEAN CHECKING")
        aqbool = aq[0]['Waarde'] > 200
        tempbool = (temp[0]['Waarde'] < 20) or (temp[0]['Waarde'] > 25)
        humbool = (hum[0]['Waarde'] < 30) or (hum[0]['Waarde'] > 60)
        lightbool = light[0]['Waarde'] < 500
        print(f"Air Quality: {aqbool}")
        print(f"Temperature: {tempbool}")
        print(f"Humidity: {humbool}")
        print(f"Light: {lightbool}")

        if(aqbool > 200): #Air Quality HIGHEST PRIO - COULD BE EVEN BE FIRE
            currentColor = RED
            print("Sensors: GAS")
        elif(tempbool and humbool and lightbool):
            currentColor = RED
            print("Sensors: Temp, Hum, Light")
        elif(humbool and tempbool):
            currentColor = ORANGE
            print("Sensors: Hum, Temp")
        elif(lightbool and humbool):
            currentColor = ORANGE
            print("Sensors: Light, Hum")
        elif(lightbool and tempbool):
            currentColor = ORANGE
            print("Sensors: Light, Temp")
        
        else:
            currentColor = GREEN

        if(copyColor != currentColor):
            #Send update to db
            if(currentColor == RED and usercontrol == False):
                DataRepository.add_actuator_record('red')
                print("\nChanging color to: RED!\n")
                pixels.fill(RED)
                pixels.show()
            elif(currentColor == ORANGE and usercontrol == False):
                DataRepository.add_actuator_record('orange')
                print("\nChanging color to: ORANGE!\n")
                pixels.fill(ORANGE)
                pixels.show()
            elif(currentColor == GREEN and usercontrol == False):
                DataRepository.add_actuator_record('green')
                print("\nChanging color to: GREEN!\n")
                pixels.fill(GREEN)
                pixels.show()
            else:
                print("\nUser is currently controlling color\n")
        time.sleep(30)

# Code voor Flask
app = Flask(__name__)
app.config['SECRET_KEY'] = 'geheim!'
socketio = SocketIO(app, cors_allowed_origins="*", logger=False, engineio_logger=False, ping_timeout=1)
CORS(app)

# Handles the default namespace
@socketio.on_error()
def error_handler(e):
    print(e)

print("**** Program started ****")

# API ENDPOINTS
@app.route('/')
def hallo():
    return "Welcome To The ClimateBox API V1"

@app.route(endpoint + '/temperature/<amount>', methods=['GET'])
def temperature(amount):
    return jsonify(DataRepository.get_amount_of_measurements_temperature(int(amount))), 200

@app.route(endpoint + '/humidity/<amount>', methods=['GET'])
def humidity(amount):
    return jsonify(DataRepository.get_amount_of_measurements_humidity(int(amount))), 200

@app.route(endpoint + '/light/<amount>', methods=['GET'])
def light(amount):
    return jsonify(DataRepository.get_amount_of_measurements_light(int(amount))), 200

@app.route(endpoint + '/gas/<amount>', methods=['GET'])
def gas(amount):
    return jsonify(DataRepository.get_amount_of_measurements_gas(int(amount))), 200

@app.route(endpoint + '/leds/<red>/<green>/<blue>', methods=['GET'])
def changeLedringColor(red, green, blue):
    print("User started controlling!")
    global usercontrol
    global currentColor
    usercontrol = True
    pixels.fill((int(red), int(green), int(blue)))
    pixels.show()
    print(f"Setting Color To: ({int(red)}, {int(green)}, {int(blue)})")
    return jsonify("Successfully set color!"), 200

@app.route(endpoint + '/leds/reset', methods=['GET'])
def changeUsercontrol():
    print("User stopped controlling!")
    global usercontrol
    usercontrol = False
    print(f"Setting Color To: {currentColor}")
    pixels.fill(currentColor)
    pixels.show()
    return jsonify("Successfully reset!"), 200

# ANDERE FUNCTIES
if __name__ == '__main__':
    #LCD
    lcduodater = threading.Thread(target=update_lcd)
    lcduodater.start()

    #SENSORS
    temp = threading.Thread(target=read_temperature)
    hum = threading.Thread(target=read_humdity)
    light = threading.Thread(target=read_light)
    gas = threading.Thread(target=read_gas)
    temp.start()
    hum.start()
    light.start()
    gas.start()

    #Now this is the hardest part - disabled actuator (due to sudo issue)
    
    eval = threading.Thread(target=evaluate)
    eval.start()
    
    socketio.run(app, debug=False, host='0.0.0.0')