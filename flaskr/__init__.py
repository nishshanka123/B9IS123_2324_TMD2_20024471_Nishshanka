from flask import Flask, render_template, request, session, redirect, url_for
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)

mysql = mysql.connector.connect(user='root', password='yash@1999',host='127.0.0.1',database='DIMS')

app.secret_key = '12345'

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Authenticate user - Example using MySQL
        cursor = mysql.cursor()
        cursor.execute('SELECT * FROM USER WHERE username=%s AND password=%s', (username, password))
        record = cursor.fetchone()
        cursor.close()  # Close the cursor after using it
        
        if record:
            session['loggedin'] = True
            session['username'] = username
            return redirect(url_for('index'))
        else:
            msg = 'Incorrect Password or username.'
            return render_template('login.html', msg=msg)
    else:
        return render_template("login.html")
    
@app.route('/index', methods=['GET'])
def index():
    if 'loggedin' in session:
        return render_template('index.html', username=session['username'])
    else:
        return redirect(url_for('login'))

@app.route('/manage-devices')
def manageDevices():
    device_data = [
        {'name': 'Device 1', 'type': 'Type 1'},
        {'name': 'Device 2', 'type': 'Type 2'},
    ]
    return render_template('manage-devices.html')

@app.route('/manage-users')
def manageUsers():
    return render_template('manage-users.html')

@app.route('/generate-reports')
def generateReports():
    return render_template('generate-reports.html')

@app.route('/settings')
def settings():
    return render_template('settings.html')

if __name__ == "__main__":
    app.run(host='127.0.0.1', port='8080')
