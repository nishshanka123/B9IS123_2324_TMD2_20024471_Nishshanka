from flask import Flask, render_template, g, jsonify
from . import db
from flask import request, session, redirect, url_for
import secrets
import json
import string
import logging
from .db import get_db
from datetime import date

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
            cursor.execute('SELECT username, role FROM User WHERE username=%s AND password=%s', (username, password))
            user = cursor.fetchone()
            cursor.close()

            if user:
                session['username'] = user[0]
                session['role'] = user[1]

                if session['role'] == 'admin':
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
        return render_template('index.html')
        #return data
    
    @app.route('/manage-devices')
    def manageDevices():
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
        if request.method == 'POST':
            return QueryReport()
        elif request.method == 'GET':
            return render_template('generate-reports.html')
        else:
            return render_template('generate-reports.html')
        #response_message = f"Data received: {records}"
    

    def QueryReport():
        catagory = request.form['device_catagory']
        type = request.form['device_type']
        country = request.form['country']
        department = request.form['department']
        # write database queries and data retrival here
        select_q = ""
        where_c = "WHERE "
        if catagory == 'mfactured':
            # SerialNo | FirmwareVersion | ManufactureDate | ModelNumber
            select_q = "SELECT * FROM CompanyManufacturedDevice"
            if country != 'c_all' and department != 'd_all':
                where_c = "WHERE Country = '" + country + "' AND Department = '" + department + "'"
            else:
                if country != 'c_all' and department == 'd_all':
                    where_c = "WHERE Country = '" + country + "'"
                elif country != 'c_all' and department == 'd_all':
                    where_c = "WHERE Department = '" + department + "'"

        elif catagory == '3rd_party':
            select_q = "SELECT tp.SerialNo, tp.Manufacturer, tp.PurchasedDate, d.AssetNo, \
                    d.device_name, d.device_condition, d.device_type, tp.Description \
                    FROM ThirdpartyDevice as tp, Device as d"
            where_c += "tp.AssetNo = d.AssetNo"
            # implement the rest
        else:
            select_q = "SELECT cm.SerialNo, cm.FirmwareVersion, cm.ManufactureDate, \
                        cm.ModelNumber, cm.ManufactureDate, d.assetNo, d.device_name, \
                        d.device_condition, d.device_type FROM CompanyManufacturedDevice as cm, \
                        Device as d "
            where_c += "cm.AssetNo = d.AssetNo"
            # implement the rest
            
            
        select_q = select_q + where_c
        records = QueryDataFromDb(select_q)
        # store data in a JSON array and set to response
        JsonData = []
        for record_data in records:
            FormattedRecord = {
                'value1' : record_data[0],
                'value2' : record_data[1],
                'value3' : record_data[2],
                'value4' : record_data[3],
                'value5' : record_data[4],
                'value6' : record_data[5],
                'value7' : record_data[6]
            }
            JsonData.append(FormattedRecord);
        # prepare the response
        response = {'JsonData':JsonData, 'count':len(JsonData)}
        
        # Return a JSON response
        return jsonify(response)

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
        return render_template('settings.html')

    @app.route('/logout')
    def logout():
        session.clear()
        return render_template('login.html')
    
    @app.route('/api/data')
    def get_data():
        device_data = fetch_device_data()
        Results = []
        for row in device_data:
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
        return jsonify(response)  # Use jsonify to convert response to JSON    

    def fetch_device_data():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Device")
        data = cursor.fetchall()
        cursor.close()

        return data
    
    @app.route("/api/add", methods=['GET', 'POST']) #Add Student
    def add_student():
        
        try: 
            if request.method == 'POST':
                device_name = request.form['device_name']
                device_condition = request.form['device_condition']
                device_serial = request.form['device_serial']
                device_MD = request.form['device_MD']
                device_type = request.form['device_type']
                print(device_name,device_condition)

                db = get_db()
                cursor = db.cursor()
                cursor.execute("INSERT INTO Device (device_name, device_condition, device_serial_no, device_manufactured_date, device_type) VALUES (%s, %s, %s, %s, %s)",(device_name, device_condition, device_serial, device_MD, device_type))
                cursor.close()
                return jsonify({"message": "Add Device details successfully"}), 200
        except Exception as e:
            return jsonify({"error": "Failed to ad device", "details": str(e)}), 500


    @app.route('/api/update', methods=['POST'])
    def update_device():
        try:
            if request.method == 'POST':
                device_id = request.form['device_id']
                device_name = request.form['device_name']
                device_condition = request.form['device_condition']
                device_serial = request.form['device_serial']
                device_MD = request.form['device_MD']
                device_type = request.form['device_type']
                print(device_name,device_condition)
                print(device_id)
                logging.info(f"Received update request for device ID: {device_id}")

                db = get_db()
                cursor = db.cursor()
                cursor.execute("UPDATE Device SET device_name = %s, device_condition = %s, device_serial_no = %s, device_manufactured_date = %s, device_type = %s WHERE device_id = %s", (device_name, device_condition, device_serial, device_MD, device_type, device_id))
                db.commit()  # Commit transaction

                cursor.close()

                return jsonify({"message": "Update device details successfully"}), 200
        except Exception as e:
            logging.error(f"Failed to update device details: {str(e)}")
            return jsonify({"error": "Failed to update device details", "details": str(e)}), 500
    
    @app.route('/api/delete_device/<int:device_id>', methods=['DELETE'])
    def delete_device(device_id): 
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute("DELETE FROM Device WHERE device_id = %s", (device_id,))
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


    '''@app.route('/insert', methods=['POST'])
    def insert():
        db = get_db()
        cursor = db.cursor()
        # Retrieve data from the request and insert into the database
        cursor.close()
        db.commit()
        return redirect(url_for('index'))'''

    '''@app.route('/select')
    def select():
        db = get_db()
        cursor = db.cursor()
        # Execute select query and fetch data
        cursor.execute("SELECT * FROM test")
        data = cursor.fetchall()
        cursor.close()
        return render_template('select.html', data=data)'''

    @app.teardown_appcontext
    def close_db(error):
        db.close_db()

    return app

if __name__ == "__main__":
    app.run(host='127.0.0.1', port='8080')
