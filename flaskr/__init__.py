from flask import Flask, render_template, g, jsonify
from . import db
from flask import request, session, redirect, url_for
import secrets
import json
import string
import logging
from .db import get_db
from datetime import date
from collections import OrderedDict

def generate_secret_key(length=32):
    alphabet = string.ascii_letters + string.digits + '!@#$%^&*()-=_+'
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = generate_secret_key()

    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'dbs'
    app.config['MYSQL_PASSWORD'] = 'password'
    app.config['MYSQL_DB'] = 'DIMS'

    # Initialize the database
    #db.init_app(app)

    @app.route('/', methods=['GET', 'POST'])
    def login():
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']

            db = get_db()
            cursor = db.cursor()
            cursor.execute('SELECT username, DIMSRole FROM User WHERE username=%s AND password=%s', (username, password))
            user = cursor.fetchone()
            cursor.close()

            if user:
                session['username'] = user[0]
                session['DIMSRole'] = user[1]

                if session['DIMSRole'] == 'admin':
                    return redirect(url_for('index'))
                else:
                    return redirect(url_for('index'))
            else:
                msg = 'Incorrect Username or Password'
                return render_template('login.html', msg=msg)
        else:
            return render_template('login.html')

    @app.route('/index')
    def index():
        if 'username' not in session:
            return redirect(url_for('login'))
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Device")
        data = cursor.fetchall()
        cursor.close()
        return render_template('index.html', data=data)
        #return data
    
    @app.route('/manage-devices')
    def manageDevices():
        if 'username' not in session:
            return redirect(url_for('login'))
        return render_template('manage-devices.html')
    
    def username_exists(username):
        db = get_db()
        cursor = db.cursor()
        cursor.execute('SELECT * FROM User WHERE username=%s', (username,))
        record = cursor.fetchone()
        cursor.close()
        return record is not None
    
    @app.route('/users', methods=['GET', 'POST'])
    def manageUsers():
        if 'username' not in session:
            return redirect(url_for('login'))
        if request.method == 'POST':
            username = request.form['create_username']
            password = request.form['create_password']

            if username_exists(username):
                error_msg = 'Username already exists. Please use another Username.'
                return render_template('manage-users.html', error_msg=error_msg)

            if len(password) < 4:
                error_msg = 'Password must be atleast 4 characters'
                return render_template('manage-users.html', error_msg=error_msg)

            db = get_db()
            cursor = db.cursor()
            try:
                cursor.execute('INSERT INTO User (username, password) VALUES (%s, %s)', (username, password))
                db.commit()
                msg = 'User registered successfully!'
                return render_template('manage-users.html', msg=msg)
            except Exception as e:
                db.rollback()
                error_msg = f'Error inserting user: {e}'
                return render_template('manage-users.html', error_msg=error_msg, username=username, password=password)
            finally:
                cursor.close()
        else:
            return render_template('manage-users.html')
    
    @app.route('/generateReports', methods=['GET', 'POST'])
    def generateReports():
        if 'username' not in session:
            return redirect(url_for('login'))
        if request.method == 'GET':
            device_catagory = fetch_device_catagory()
            device_name = fetch_device_name()
            countries = fetch_countries()
            departments = fetch_departments()
        return render_template('generate-reports.html', device_catagory=device_catagory, device_name=device_name, countries=countries, departments=departments)
        if request.method == 'POST':
            data = request.json
            #print("data------> ", data)

            catagory = data['device_catagory']
            type = data['device_type']
            country = data['country']
            department = data['department']
            
            select_q = ""
            where_c = "WHERE "

            if catagory == "mfactured":
                select_q = "SELECT cm.SerialNo, cm.FirmwareVersion, cm.ModelNumber \
                            , cm.ManufactureDate, d.assetNo, d.device_name, \
                            d.device_condition, d.device_type FROM CompanyManufacturedDevice as cm, \
                            Device as d "
                where_c += "cm.AssetNo = d.AssetNo"

            elif catagory == '3rd_party':
                select_q = "SELECT tp.SerialNo, tp.OS, tp.Manufacturer, tp.PurchasedDate, d.AssetNo, \
                    d.device_name, d.device_condition, d.device_type, tp.Description FROM \
                        ThirdpartyDevice as tp, Device as d "
                where_c += "tp.AssetNo = d.AssetNo"
                # implement the rest
            else:
                select_q = "SELECT cm.SerialNo, cm.FirmwareVersion, cm.ModelNumber \
                            , cm.ManufactureDate, d.assetNo, d.device_name, \
                            d.device_condition, d.device_type FROM CompanyManufacturedDevice as cm, \
                            Device as d "
                where_c += "cm.AssetNo = d.AssetNo"
                # implement the rest
                
            
            select_q = select_q + where_c
            #print("Select Q: ", select_q)
            records = QueryDataFromDb(select_q)
            # store data in a JSON array and set to response

            JsonData = []
            for record_data in records:
                FormattedRecord = {
                    "Serial No" : record_data[0] if len(record_data) > 0 else None,
                    "Asset No" : record_data[4] if len(record_data) > 4 else None,
                    "Firmware or OS" : record_data[1] if len(record_data) > 1 else None,
                    "Manufacturer or Model" : record_data[2] if len(record_data) > 2 else None,
                    "Manufactured-purchased date" : record_data[3] if len(record_data) > 3 else None,
                    "Name" : record_data[5] if len(record_data) > 5 else None,
                    "Condition" : record_data[6] if len(record_data) > 6 else None,
                    "Type" : record_data[7] if len(record_data) > 7 else None,
                    "Description" : record_data[8] if len(record_data) > 8 else "NA"
                }
                JsonData.append(FormattedRecord);
            # prepare the response
            response = {'JsonData':JsonData, 'count':len(JsonData)}
            
            # Return a JSON response            
            return jsonify(response)

            '''JsonData = []
            for record_data in records:
                # Use OrderedDict to preserve insertion order
                FormattedRecord = [
                    ("value9", record_data[0] if len(record_data) > 0 else None),
                    ("value2", record_data[1] if len(record_data) > 1 else None),
                    ("value3", record_data[2] if len(record_data) > 2 else None),
                    ("value4", record_data[3] if len(record_data) > 3 else None),
                    ("value5", record_data[4] if len(record_data) > 4 else None),
                    ("value6", record_data[5] if len(record_data) > 5 else None),
                    ("value7", record_data[6] if len(record_data) > 6 else None),
                    ("value8", record_data[7] if len(record_data) > 7 else None),
                    ("value1", record_data[8] if len(record_data) > 8 else None)
                ]
                JsonData.append(FormattedRecord)

            # Convert OrderedDict to regular dictionary
            formatted_data = [dict(record) for record in JsonData]

            # prepare the response
            response = {'JsonData': formatted_data, 'count': len(JsonData)}

            # Return a JSON response with preserved insertion order
            return jsonify(response)'''
    
        elif request.method == 'GET':
            return render_template('generate-reports.html')
        else:
            return render_template('generate-reports.html')
        #response_message = f"Data received: {records}"

    def fetch_device_catagory():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT DISTINCT device_type FROM Device")
        device_catagory = [row[0] for row in cursor.fetchall()]
        cursor.close()
        return device_catagory

    def fetch_device_name():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT DISTINCT device_name FROM Device")
        device_name = [row[0] for row in cursor.fetchall()]
        cursor.close()
        return device_name

    def fetch_countries():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT DISTINCT Name FROM Country")
        countries = [row[0] for row in cursor.fetchall()]
        cursor.close()
        return countries

    def fetch_departments():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT DISTINCT device_type FROM Device")
        departments = [row[0] for row in cursor.fetchall()]
        cursor.close()
        return departments
        
    def QueryDataFromDb(db_query):
        records = None
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute(db_query)
            records = cursor.fetchall()
            cursor.close()
        except Exception as ex:
            records = ex;
        return records;

    
    @app.route('/settings')
    def settings():
        if 'username' not in session:
            return redirect(url_for('login'))
        return render_template('settings.html')

    @app.route('/logout')
    def logout():
        session.clear()
        return render_template('login.html')
    
    @app.route('/api/get_devices')
    def get_devices():
        device_data = fetch_home_device_data()
        Results = []
        for row in device_data:
            Result = {
                'AssertNo': row[0],
                'DeviceName': row[1],
                'DeviceCondition': row[2],
                'DeviceType': row[3],
                'DeviceSerial': row[4],
                'DeviceFirmware': row[5],
                'ManufacturedDate': row[6].strftime('%Y-%m-%d'),
                'ModelNumber': row[7]
            }
            Results.append(Result)
        response = {'Results': Results, 'count': len(Results)}
        return jsonify(response)  # Use jsonify to convert response to JSON
    
    def fetch_home_device_data():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT d.assetNo, d.device_name, d.device_condition, d.device_type, cm.SerialNo, cm.FirmwareVersion, cm.ManufactureDate, cm.ModelNumber FROM CompanyManufacturedDevice as cm, Device as d where cm.AssetNo = d.AssetNo")
        data = cursor.fetchall()
        cursor.close()

        return data
    
    @app.route("/api/add_device", methods=['GET', 'POST']) #Add Student
    def add_device():
        
        try: 
            if request.method == 'POST':
                device_addert_no = request.form['assert_no']
                device_name = request.form['device_name']
                device_condition = request.form['device_condition']
                device_type = request.form['device_type']
                device_serial = request.form['device_serial']
                device_firmware = request.form['device_firmware']
                device_MD = request.form['device_MD']
                device_model_no = request.form['model_no']
                print(device_name,device_condition)

                db = get_db()
                cursor = db.cursor()
                cursor.execute("INSERT INTO Device (assetNo, device_name, device_condition, device_type) VALUES (%s, %s, %s, %s)",(device_addert_no, device_name, device_condition, device_type))
                cursor.execute("INSERT INTO CompanyManufacturedDevice (SerialNo, FirmwareVersion, ManufactureDate, ModelNumber, assetNo) VALUES (%s, %s, %s, %s, %s)",(device_serial, device_firmware, device_MD, device_model_no, device_addert_no))
                cursor.close()
                return jsonify({"message": "Add Device details successfully"}), 200
        except Exception as e:
            return jsonify({"error": "Failed to ad device", "details": str(e)}), 500


    @app.route('/api/update_device/<string:assert_no>/<string:serial_no>', methods=['POST'])
    def update_device(assert_no, serial_no):
        try:
            if request.method == 'POST':
                #device_assert_no = request.form['assert_no']
                device_name = request.form['device_name']
                device_condition = request.form['device_condition']
                device_type = request.form['device_type']
                #device_serial = request.form['device_serial']
                device_firmware = request.form['device_firmware']
                device_MD = request.form['device_MD']
                device_model_no = request.form['model_no']
                #print(device_assert_no, device_name,device_condition, device_type)
                # print(device_id)
                #logging.info(f"Received update request for device ID: {device_id}")

                db = get_db()
                cursor = db.cursor()
                #UPDATE Device SET device_name = 'DS2250', device_condition = 'New', device_type = 'New' WHERE assetNo = '1';
                #UPDATE CompanyManufacturedDevice SET FirmwareVersion = 'REV2', ManufactureDate = '2024-10-10', ModelNumber = 'DS1100' WHERE SerialNo = '11111111';
                # 
                cursor.execute("UPDATE Device SET device_name = %s, device_condition = %s, device_type = %s WHERE assetNo = %s", (device_name, device_condition, device_type, assert_no))
                cursor.execute("UPDATE CompanyManufacturedDevice SET FirmwareVersion = %s, ManufactureDate = %s, ModelNumber = %s WHERE SerialNo = %s", (device_firmware, device_MD, device_model_no, serial_no))
                db.commit()  # Commit transaction

                cursor.close()

                return jsonify({"message": "Update device details successfully"}), 200
        except Exception as e:
            logging.error(f"Failed to update device details: {str(e)}")
            return jsonify({"error": "Failed to update device details", "details": str(e)}), 500
    
    @app.route('/api/delete_device/<string:assert_no>/<string:serial_no>', methods=['DELETE'])
    def delete_device(assert_no, serial_no): 
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute("DELETE FROM CompanyManufacturedDevice WHERE SerialNo = %s", (serial_no,))
            cursor.execute("DELETE FROM Device WHERE assetNo = %s", (assert_no,))
            cursor.close()  # Close the cursor after use
            return jsonify({"message": "Device deleted successfully"}), 200
        except Exception as e:
            return jsonify({"error": "Failed to delete Device record", "details": str(e)}), 500
        
    @app.route('/api/search/<string:search_value>')
    def search_device(search_value): 
        
        try:
            db = get_db()
            with db.cursor() as cursor:
                # Parameterized query to avoid SQL injection
                #cursor.execute("SELECT * FROM Device WHERE device_name = %s", (search_value,))
                cursor.execute("SELECT * FROM Device WHERE device_name = %s OR device_condition = %s OR device_serial_no = %s OR device_type = %s", (search_value, search_value, search_value, search_value))
                device_data = cursor.fetchall()  # Fetch the results before closing the cursor
            
            Results = []
            print(device_data)
            
            Results = []
            for row in device_data:
                print(row[0])
                Result = {
                    'ID': row[0],
                    'Name': row[1],
                    'Condition': row[2],
                    'Serial': row[3],
                    'Date': row[4].strftime('%Y-%m-%d'),
                    'Type': row[5]
                }
                Results.append(Result)
            response = {'Results': Results, 'count': len(Results)}
            print(response)
            return jsonify(response)  # Use jsonify to convert response to JSON
        
        except Exception as e:
            return jsonify({"error": "Failed to search for devices", "details": str(e)}), 500


    @app.teardown_appcontext
    def close_db(error):
        db.close_db()

    return app

if __name__ == "__main__":
    app.run(host='127.0.0.1', port='8080')
