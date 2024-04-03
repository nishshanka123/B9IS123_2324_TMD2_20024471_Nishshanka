from flask import Flask, render_template, g, jsonify
from . import db
from flask import request, session, redirect, url_for
import secrets
import json
import string
from .db import get_db
from datetime import date

def generate_secret_key(length=32):
    alphabet = string.ascii_letters + string.digits + '!@#$%^&*()-=_+'
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = generate_secret_key()

    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = 'yash@1999'
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
            cursor.execute('SELECT * FROM USER WHERE username=%s AND password=%s', (username, password))
            record = cursor.fetchone()
            cursor.close()

            if record:
                session['loggedin'] = True
                session['username'] = username
                return redirect(url_for('index'))
            else:
                msg = 'Incorrect Username or Password'
                return render_template('login.html', msg=msg)
        else:
            return render_template('login.html')


    @app.route('/index')
    def index():
        if 'loggedin' in session:
            db = get_db()
            cursor = db.cursor()
            cursor.execute("SELECT * FROM Scanners")
            data = cursor.fetchall()
            cursor.close()
            return render_template('index.html', data=data, username=session['username'])
        else:
            return redirect(url_for('login'))
        #return data
    
    @app.route('/manage-devices')
    def manageDevices():
        return render_template('manage-devices.html')
    
    @app.route('/users')
    def manageUsers():
        return render_template('manage-users.html')
    
    @app.route('/generateReports')
    def generateReports():
        return render_template('generate-reports.html')
    
    @app.route('/settings')
    def settings():
        return render_template('settings.html')

    @app.route('/logout')
    def logout():
        return render_template('login.html')
    
    @app.route('/api/data')
    def get_data():
        student_data = fetch_scanner_data()
        Results = []
        for row in student_data:
            Result = {
                'ID': row[0],
                'Name': row[1].replace('\n', ' '),
                'Condition': row[2],
                'Serial': row[3],
                'Date': row[4],
                'Type': row[5]
            }
            Results.append(Result)
        response = {'Results': Results, 'count': len(Results)}
        return jsonify(response)  # Use jsonify to convert response to JSON
    
    def fetch_scanner_data():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Device")
        data = cursor.fetchall()
        cursor.close()

        return data
    
    @app.route("/add", methods=['GET', 'POST']) #Add Student
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
                return jsonify({"message": "Add scanner details successfully"}), 200
            else:
                return render_template('add.html')
        except Exception as e:
            return jsonify({"error": "Failed to ad device", "details": str(e)}), 500


    @app.route('/api/update', methods=['POST'])
    def update_student():

        try:
            if request.method == 'POST':
                student_id = request.form['studentId']
                first_name = request.form['name']
                email = request.form['email']
                print(first_name,email,student_id)

                db = get_db()
                cursor = db.cursor()
                cursor.execute("UPDATE Scanners SET student_name = %s, student_email= %s WHERE student_id = %s",(first_name, email, student_id))
                cursor.close()
                return jsonify({"message": "Update scanner details successfully"}), 200
            else:
                return render_template('add.html')
        except Exception as e:
            return jsonify({"error": "Failed to update scanner details", "details": str(e)}), 500
        
        student_data = fetch_student_data()
        return  render_template('index.html', students = student_data)
    
    @app.route('/delete_device/<int:device_id>', methods=['DELETE'])
    def delete_device(device_id): 
        try:
            db = get_db()
            cursor = db.cursor()
            cursor.execute("DELETE FROM Device WHERE device_id = %s", (device_id,))
            cursor.close()  # Close the cursor after use
            return jsonify({"message": "Device deleted successfully"}), 200
        except Exception as e:
            return jsonify({"error": "Failed to delete Device record", "details": str(e)}), 500

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
