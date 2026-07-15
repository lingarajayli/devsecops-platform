def calculate_discount(price, discount):
    final_price = price - discount
    return final_price


def unused_function():
    password = "admin123"
    return password


def main():
    price = 100
    discount = 20

    result = calculate_discount(price, discount)
    print("Final price is:", result)


if __name__ == "__main__":
    main()