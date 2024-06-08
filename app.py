from flask import Flask, request, render_template, jsonify
from flask import Flask, request, render_template, redirect, url_for,flash,session
from pymongo import MongoClient
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

app.secret_key = 'your_secret_key'

# Connect to MongoDB

#while running docker uncomment
# client = MongoClient('mongodb://localhost:27017/')

#while running docker
# client = MongoClient('mongodb://libra-db-1:27017/')

# this is for kubernetes 
client = MongoClient('mongodb://mongodb:27017/')


db = client['libra_ecommerce']

users_collection = db['users']
products_collection = db['products']
cart_collection = db["cart"]

 

@app.route('/', methods=['GET'])
def render_customer_signup_new():
    return render_template('login.html')

@app.route('/signup', methods=['GET'])
def render_customer_signup():
    return render_template('signup.html')

@app.route('/login', methods=['GET'])
def render_customer_login():
    return render_template('login.html')


@app.route('/signup', methods=['POST'])
def customer_signup():
    data = request.form
    username = data.get('username')
    password = data.get('password')
    role = data.get('role')
    if not username or not password:
        flash('Username and password are required')
        return redirect(url_for('customer_login'))
    if users_collection.find_one({'username': username}):
        flash('Username already exists')
        return redirect(url_for('customer_signup'))
    hashed_password = generate_password_hash(password)
    users_collection.insert_one({'username': username, 'password': hashed_password, 'role': role})
    if role == "customer":
        products = list(products_collection.find())
        session['username'] = username
        session['role'] = role
        return render_template('customer_dashboard.html', products=products)
    if role == "seller":
        products = list(products_collection.find())
        return render_template('seller_add_product.html', products=products)


@app.route('/login', methods=['POST'])
def customer_login():
    data = request.form
    username = data.get('username')
    password = data.get('password')
    role = data.get('role')
    user = users_collection.find_one({'username': username})
    
    if not user or not check_password_hash(user['password'], password) :
        flash('Invalid username or password')
        return redirect(url_for('customer_login'))
    if role == "customer":
        products = list(products_collection.find())
        session['username'] = username
        session['role'] = role
        return render_template('customer_dashboard.html', products=products)
    if role == "seller":
        products = list(products_collection.find())
        return render_template('seller_add_product.html', products=products)


@app.route('/seller/add_product')
def seller_add_product():
    return render_template('seller_add_product.html')


@app.route('/seller/add_product', methods=['POST'])
def add_product():
    data = request.form
    name = data.get('name')
    description = data.get('description')
    price = float(data.get('price'))
    category = data.get('category')
    product = {
        'name': name,
        'description': description,
        'price': price,
        'category': category
    }
    products_collection.insert_one(product)
    flash('Product Added successfully', 'success')
    return redirect(url_for('seller_add_product'))


@app.route('/seller/update_product')
def seller_update_product():
    return render_template('update_product.html')

@app.route('/seller/update_product', methods=['GET', 'POST'])
def update_product():
    if request.method == 'POST':
        name = request.form['name']
        description = request.form['description']
        price = float(request.form['price'])
        category = request.form['category']
        product = products_collection.find_one({'name': name})
        if product:
            products_collection.update_one(
                {'name': name},
                {'$set': {
                    'description': description,
                    'price': price,
                    'category': category
                }}
            )
            flash('Product updated successfully', 'success')
            return redirect(url_for('update_product'))
        else:
            flash('Product does not exist', 'error')
            return redirect(url_for('update_product'))
    else:
        return render_template('update_product.html')
@app.route('/customer/dashboard')
def customer_dashboard():
    products = products_collection.find()
    return render_template('customer_dashboard.html', products=products)

@app.route('/cart', methods=['GET'])
def get_cart():
    username = session.get('username')
    if not username:
        return redirect(url_for('customer_login'))
    cart_items = cart_collection.find({'username': username})
    cart_items = list(cart_collection.find({'username': username}))
    total_price = sum(item['price'] * item['quantity'] for item in cart_items)
    return render_template('cart.html', cart_items=cart_items,total_price="{:.2f}".format(total_price))

@app.route('/cart/add', methods=['POST'])
def add_to_cart():
    username = session.get('username')
    if not username:
        return jsonify({'error': 'Unauthorized'}), 401
    data = request.form
    product_name = data.get('name')
    product = products_collection.find_one({'name': product_name})
    if not product:
        return jsonify({'error': 'Product not found'}), 404
    
    existing_cart_item = cart_collection.find_one({'username': username, 'name': product_name})
    
    if existing_cart_item:
        cart_collection.update_one(
            {'username': username, 'name': product_name},
            {'$inc': {'quantity': 1}}
        )
    else:
        cart_collection.insert_one({
            'username': username,
            'name': product_name,
            'description': product['description'],
            'price': product['price'],
            'category': product['category'],
            'quantity': 1
        })
    flash('Item has been added to your cart.', 'success')
    return redirect(url_for('customer_dashboard'))


@app.route('/cart/remove', methods=['POST'])
def remove_from_cart():
    username = session.get('username')
    if not username:
        return jsonify({'error': 'Unauthorized'}), 401
    data = request.json
    product_name = data.get('name')
    cart_collection.delete_one({'username': username, 'name': product_name})
    return jsonify({'message': 'Product removed from cart'}), 200

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0', port=5000)