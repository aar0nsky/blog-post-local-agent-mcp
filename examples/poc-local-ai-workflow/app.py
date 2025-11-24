from flask import Flask, jsonify

app = Flask(__name__)

# In-memory store; intentionally simple and duplicative for the demo.
ITEMS = [
    {"id": 1, "name": "Item 1", "price": 9.99},
    {"id": 2, "name": "Item 2", "price": 14.99},
    {"id": 3, "name": "Item 3", "price": 4.99},
]

def format_item(item):
    """Format an item dict into a JSON-friendly structure.

    Note: This function is intentionally trivial and duplicated across endpoints
    to show how the AI can refactor it into utils.py.
    """
    return {
        "id": item["id"],
        "name": item["name"],
        "price": item["price"],
    }

@app.route("/hello")
def hello() -> str:
    """Return a greeting."""
    return "Hello, world!"

@app.route("/items")
def get_items():
    """Return a list of items."""
    # Duplicate formatting logic; this will be extracted by the PoC.
    formatted = []
    for item in ITEMS:
        formatted.append(
            {
                "id": item["id"],
                "name": item["name"],
                "price": item["price"],
            }
        )
    return jsonify(formatted)


if __name__ == "__main__":
    # Intentionally no logging or error handling to give the AI something to fix.
    app.run(debug=True)