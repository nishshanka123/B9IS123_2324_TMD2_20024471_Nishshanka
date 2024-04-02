from flask import Flask, render_template, g
from . import db
import secrets
import string
from .db import get_db

def generate_secret_key(length=32):
    alphabet = string.ascii_letters + string.digits + '!@#$%^&*()-=_+'
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = generate_secret_key()

    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'nishshanka'
    app.config['MYSQL_PASSWORD'] = 'malsara'
    app.config['MYSQL_DB'] = 'DIMS'

    # Initialize the database
    #db.init_app(app)

    @app.route('/')
    def index():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM test")
        data = cursor.fetchall()
        cursor.close()
        return render_template('index.html', data=data)
        #return data

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


'''
from flask import Flask, render_template
from . import db

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'your_secret_key_here'

    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'nishshanka'
    app.config['MYSQL_PASSWORD'] = 'malsara'
    app.config['MYSQL_DATABASE'] = 'DIMS'

    @app.teardown_appcontext
    def close_db(error):
        db.close_db()

    # Your routes and other configurations here...

    return app'''
