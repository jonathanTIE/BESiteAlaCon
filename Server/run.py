from Server.views import app


if __name__ == '__main__':
    app.secret_key = "secret_key"  # Default secret key to use the session mechanisms.
    app.run(debug=True)