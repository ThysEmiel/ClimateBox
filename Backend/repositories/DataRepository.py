from os import stat
from .Database import Database
import datetime


class DataRepository:
    @staticmethod
    def json_or_formdata(request):
        if request.content_type == 'application/json':
            gegevens = request.get_json()
        else:
            gegevens = request.form.to_dict()
        return gegevens

    @staticmethod
    def add_temperature_record(temperature):
        sql = 'INSERT INTO climatebox.meting VALUES(null, %s, "TEMP", %s)'
        params = [temperature, datetime.datetime.now()]
        return Database.execute_sql(sql, params)

    @staticmethod
    def get_amount_of_measurements_temperature(amount):
        sql = 'SELECT Waarde, DateTaken FROM climatebox.meting WHERE SensorCode = "TEMP" ORDER BY DateTaken DESC LIMIT %s'
        params = [amount]
        return Database.get_rows(sql, params)

    @staticmethod
    def add_humidity_record(humidity):
        sql = 'INSERT INTO climatebox.meting VALUES(null, %s, "HUM", %s)'
        params = [humidity, datetime.datetime.now()]
        return Database.execute_sql(sql, params)

    @staticmethod
    def get_amount_of_measurements_humidity(amount):
        sql = 'SELECT Waarde, DateTaken FROM climatebox.meting WHERE SensorCode = "HUM" ORDER BY DateTaken DESC LIMIT %s'
        params = [amount]
        return Database.get_rows(sql, params)

    @staticmethod
    def add_light_record(light):
        sql = 'INSERT INTO climatebox.meting VALUES(null, %s, "LIGHT", %s)'
        params = [light, datetime.datetime.now()]
        return Database.execute_sql(sql, params)

    @staticmethod
    def get_amount_of_measurements_light(amount):
        sql = 'SELECT Waarde, DateTaken FROM climatebox.meting WHERE SensorCode = "LIGHT" ORDER BY DateTaken DESC LIMIT %s'
        params = [amount]
        return Database.get_rows(sql, params)

    @staticmethod
    def add_gas_record(cm):
        sql = 'INSERT INTO climatebox.meting VALUES(null, %s, "GAS", %s)'
        params = [cm, datetime.datetime.now()]
        return Database.execute_sql(sql, params)

    @staticmethod
    def get_amount_of_measurements_gas(amount):
        sql = 'SELECT Waarde, DateTaken FROM climatebox.meting WHERE SensorCode = "GAS" ORDER BY DateTaken DESC LIMIT %s'
        params = [amount]
        return Database.get_rows(sql, params)

    @staticmethod
    def add_actuator_record(color):
        sql = 'INSERT INTO climatebox.actuatorhistoriek (Color, DateChanged) VALUES(%s, %s)'
        params = [color, datetime.datetime.now()]
        return Database.execute_sql(sql, params)

    @staticmethod
    def get_amount_of_statusses_actuator(amount):
        sql = 'SELECT Color FROM climatebox.actuatorhistoriek ORDER BY DateTaken DESC LIMIT %s'
        params = [amount]
        return Database.get_rows(sql, params)
