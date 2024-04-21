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
from flask_bcrypt import Bcrypt
from flask_bcrypt import check_password_hash
from flask import Flask, after_this_request

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
            cursor.execute('SELECT username, password, DIMSRole FROM User WHERE username=%s', (username,))
            user = cursor.fetchone()
            cursor.close()

            
            if user:
                hashed_password = user[1]
                if check_password_hash(hashed_password, password):
                    session['username'] = user[0]
                    session['DIMSRole'] = user[2]

                    if session['DIMSRole'] == 'admin':
                        return redirect(url_for('index'))
                    else:
                        return redirect(url_for('index'))
                else:
                    msg = 'Incorrect Password'
                    return render_template('login.html', msg=msg)
            else:
                msg = 'Incorrect Username'
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

    bcrypt = Bcrypt(app)
    
    @app.route('/users', methods=['GET', 'POST'])
    def manageUsers():
        if 'username' not in session:
            return redirect(url_for('login'))
        if request.method == 'POST':
            username = request.form['create_username']
            password = request.form['create_password']
            role = request.form['user_role']

            if username_exists(username):
                error_msg = 'Username already exists. Please use another Username.'
                return render_template('manage-users.html', error_msg=error_msg)

            if len(password) < 4:
                error_msg = 'Password must be atleast 4 characters'
                return render_template('manage-users.html', error_msg=error_msg)

            hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

            db = get_db()
            cursor = db.cursor()
            try:
                cursor.execute('INSERT INTO User (username, password, DIMSRole) VALUES (%s, %s, %s)', (username, hashed_password, role))
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
            device_name = fetch_device_name(device_catagory[0])  # Pass the first device category to fetch device names
            employee = fetch_employees()
            projects = fetch_projects()
            return render_template('generate-reports.html', device_catagory=device_catagory, device_name=device_name, employee=employee, projects=projects)
        if request.method == 'POST':
            data = request.json
            #print("data------> ", data)

            catagory = data['device_catagory']
            device_name = data['device_name']
            employee_id = data['employee']
            project_id = data['project']
            query_sp = "getAllDevices"
            args = (catagory, device_name, employee_id, project_id)

            records, rowCount = ExecuteStoredProcedure(query_sp, args)

            if rowCount < 1:
                print("generate-report: No record found")

            JsonData = []
            for record_data in records:
                FormattedRecord = {
                    "Serial No" : record_data[0] if len(record_data) > 0 else None,
                    "Asset No" : record_data[4] if len(record_data) > 4 else None,
                    "Firmware or OS" : record_data[1] if len(record_data) > 1 else None,
                    "Manufacturer or Model" : record_data[2] if len(record_data) > 2 else None,
                    "Manufactured-purchased date" : record_data[3].strftime('%Y-%m-%d') if len(record_data) > 3 else None,
                    "Name" : record_data[5] if len(record_data) > 5 else None,
                    "Condition" : record_data[6] if len(record_data) > 6 else None,
                    "Type" : record_data[7] if len(record_data) > 7 else None,
                    "Description" : record_data[8] if len(record_data) > 8 else "NA",
                    "Owner" : record_data[9] if len(record_data) > 9 else "Unallocated",
                    "Project" : record_data[10] if len(record_data) > 10 else "Not Assigned"
                }
                JsonData.append(FormattedRecord);
            # prepare the response
            #response = {'JsonData':JsonData, 'count':len(JsonData)}
            response = {'JsonData':JsonData, 'count':rowCount}
            
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

    @app.route('/api/get_device_types')
    def get_device_types():
        category = request.args.get('device_catagory')
        db = get_db()
        cursor = db.cursor()
        if category == 'all':
            cursor.execute("SELECT DISTINCT device_name, device_type FROM Device")
        else:
            cursor.execute("SELECT DISTINCT device_name, device_type FROM Device WHERE device_type = %s", (category,))

        device_types = []
        for row in cursor.fetchall():
            if len(row) == 2:
                device_types.append({'name': row[0], 'type': row[1]})
            else:
                # Handle the case where the row has an unexpected number of columns
                print(f"Unexpected row format: {row}")

        cursor.close()
        return jsonify(device_types)
    @app.route('/api/get_employees')
    def get_employees():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT EmployeeID, Name FROM Employee")
        employees = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        cursor.close()
        return jsonify(employees)
    
    @app.route('/api/get_projects')
    def get_projects():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT ProjectID, ProjectName FROM Project")
        projects = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        cursor.close()
        return jsonify(projects)
    
    @app.route('/api/get_device_names')
    def get_device_names():
        category = request.args.get('category')
        device_names = fetch_device_name(category)
        return jsonify(device_names)

    def fetch_device_catagory():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT DISTINCT device_type FROM Device")
        device_catagory = [row[0] for row in cursor.fetchall()]
        cursor.close()
        return device_catagory

    def fetch_device_name(device_type):
        db = get_db()
        cursor = db.cursor()
        if device_type == 'all':
            cursor.execute("SELECT DISTINCT device_name FROM Device")
        else:
            cursor.execute("SELECT DISTINCT device_name FROM Device WHERE device_type = %s", (device_type,))
        device_name = [row[0] for row in cursor.fetchall()]
        cursor.close()
        return device_name

    def fetch_employees():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT EmployeeID, Name FROM Employee")
        employees = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        cursor.close()
        return employees

    def fetch_projects():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT ProjectID, ProjectName FROM Project")
        projects = [{'id': row[0], 'name': row[1]} for row in cursor.fetchall()]
        cursor.close()
        return projects
        
    def QueryDataFromDb(db_query):
        records = None
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute(db_query)
            records = cursor.fetchall()
            #print("SELECT result-------------: ", records)
            cursor.close()
        except Exception as ex:
            #print("Exception occurred: ", ex)
            records = ex;
        return records;

    def ExecuteStoredProcedure(query_sp, args):
        records = []
        rowCount = 0
        #args = None
        try:
            db = get_db()
            cursor = db.cursor()
            #print("Calling SP...")
            # call the stored procedure
            cursor.callproc(query_sp, args)
            # fetch the result
            #records = cursor.stored_results()
            for record in cursor.stored_results():
                #print("record--------------: ", record)
                #print("record data---------:", record.fetchall())
                records.append(record.fetchall())
                #print("record row count: ", record.rowcount)
                rowCount = record.rowcount;
            
            #print("records 1: ", records[0])
            #print("record size: ", cursor.rowcount)
            cursor.close()
        except Exception as ex:
            print("Exception occurred: ", ex)
            records = ex
        # return the result set only
        return records[0], rowCount
    
    @app.route('/settings')
    def settings():
        if 'username' not in session:
            return redirect(url_for('login'))
        return render_template('settings.html')

    @app.route('/logout')
    def logout():
        session.clear()
        return render_template('login.html')

    @app.after_request
    def add_no_cache_headers(response):
        response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "0"
        return response
    
    # Get company manufactured device list
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
                'DeviceUser': row[6],
                'ManufacturedDate': row[7].strftime('%Y-%m-%d'),
                'ModelNumber': row[8]
            }
            Results.append(Result)
        response = {'Results': Results, 'count': len(Results)}
        return jsonify(response)  # Use jsonify to convert response to JSON
    
    # Fetch all data from Device and CompanyManufacturedDevice tables.
    def fetch_home_device_data():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT d.assetNo, d.device_name, d.device_condition, d.device_type, cm.SerialNo, cm.FirmwareVersion, em.Name, cm.ManufactureDate, cm.ModelNumber FROM CompanyManufacturedDevice as cm, Employee as em, Device as d where cm.AssetNo = d.AssetNo AND em.EmployeeID = cm.EmployeeID")
        data = cursor.fetchall()
        cursor.close()

        return data
    
    # Add device to Device and CompanyManufacturedDevice tables.
    @app.route("/api/add_device", methods=['GET', 'POST']) 
    def add_device():
        
        try: 
            if request.method == 'POST':
                device_addert_no = request.form['assert_no']
                device_name = request.form['device_name']
                device_condition = request.form['device_condition']
                device_type = request.form['device_type']
                device_serial = request.form['device_serial']
                device_firmware = request.form['device_firmware']
                device_user = request.form['employee_name']
                device_MD = request.form['device_MD']
                device_model_no = request.form['model_no']
                print(device_name,device_condition)

                if device_addert_no is None:
                    return jsonify({"message": "Assert number cannot be empty"}), 200
                elif device_serial is None:
                    return jsonify({"message": "Serial number cannot be empty"}), 200


                db = get_db()
                cursor = db.cursor()
                cursor.execute("INSERT INTO Device (assetNo, device_name, device_condition, device_type) VALUES (%s, %s, %s, %s)",(device_addert_no, device_name, device_condition, device_type))
                cursor.execute("INSERT INTO CompanyManufacturedDevice (SerialNo, FirmwareVersion, EmployeeID, ManufactureDate, ModelNumber, assetNo) VALUES (%s, %s, %s, %s, %s, %s)",(device_serial, device_firmware, device_user, device_MD, device_model_no, device_addert_no))
                cursor.close()
                return jsonify({"message": "Add Device details successfully"}), 200
        except Exception as e:
            return jsonify({"error": "Failed to ad device", "details": str(e)}), 500
        


    # Update device data in Device and CompanyManufacturedDevice tables.
    @app.route('/api/update_device/<string:assert_no>/<string:serial_no>', methods=['POST'])
    def update_device(assert_no, serial_no):
        try:
            if request.method == 'POST':
                device_name = request.form['device_name']
                device_condition = request.form['device_condition']
                device_type = request.form['device_type']
                device_firmware = request.form['device_firmware']
                device_user = request.form['employee_name']
                device_MD = request.form['device_MD']
                device_model_no = request.form['model_no']

                db = get_db()
                cursor = db.cursor()
                cursor.execute("UPDATE Device SET device_name = %s, device_condition = %s, device_type = %s WHERE assetNo = %s", (device_name, device_condition, device_type, assert_no))
                cursor.execute("UPDATE CompanyManufacturedDevice SET FirmwareVersion = %s, EmployeeID= %s, ManufactureDate = %s, ModelNumber = %s WHERE SerialNo = %s", (device_firmware, device_user, device_MD, device_model_no, serial_no))
                db.commit() 

                cursor.close()

                return jsonify({"message": "Update device details successfully"}), 200
        except Exception as e:
            logging.error(f"Failed to update device details: {str(e)}")
            return jsonify({"error": "Failed to update device details", "details": str(e)}), 500
    
    # FDelete device from Device and CompanyManufacturedDevice tables.
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
        
    # Search device data from Device and CompanyManufacturedDevice tables.
    @app.route('/api/search/<string:search_value>')
    def search_device(search_value): 
        
        try:
            db = get_db()
            with db.cursor() as cursor:
                cursor.execute("SELECT * FROM Device WHERE device_name = %s OR device_condition = %s OR device_serial_no = %s OR device_type = %s", (search_value, search_value, search_value, search_value))
                device_data = cursor.fetchall() 
            
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

    # Get current employee details.
    @app.route('/api/getEmployeeDetails')
    def get_employee(): 
        
        try:
            db = get_db()
            with db.cursor() as cursor:
                cursor.execute("SELECT  EmployeeID, Name FROM Employee")
                employee_data = cursor.fetchall() 

            print(employee_data)
            Results = []
            for row in employee_data:    
                Result = {
                    'ID': row[0],
                    'Name': row[1]
                }
                Results.append(Result)
            response = {'Results': Results, 'count': len(Results)}
            return jsonify(response) 
        
        except Exception as e:
            return jsonify({"error": "Failed to get employee details", "details": str(e)}), 500

    @app.teardown_appcontext
    def close_db(error):
        db.close_db()

    return app

if __name__ == "__main__":
    app.run(host='0.0.0.0', port='8080')

# if __name__ == "__main__":
#  app.run(host='0.0.0.0', port='8080') # indent this line
