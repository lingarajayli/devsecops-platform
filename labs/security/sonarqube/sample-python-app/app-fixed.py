import os


def calculate_discount(price, discount):
    final_price = price - discount
    return final_price


def get_application_password():
    return os.getenv("APP_PASSWORD", "password-not-configured")


def main():
    price = 100
    discount = 20

    result = calculate_discount(price, discount)
    app_password = get_application_password()

    print("Final price is:", result)
    print("Application password configured:", app_password != "password-not-configured")


if __name__ == "__main__":
    main()