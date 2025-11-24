# PoC: Local AI Workflow Demo

This example project accompanies the proof‑of‑concept described in [`docs/poc-demo.md`](../../docs/poc-demo.md).  It contains a tiny Flask application that intentionally duplicates logic, lacks tests, and offers opportunities for improvement.

## Running the app

You can run the service manually to understand its current behaviour:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

The API will listen on `http://127.0.0.1:5000/`.  Available endpoints:

| Route | Description |
| ----- | ----------- |
| `/hello` | Returns a simple greeting. |
| `/items` | Returns a list of items with duplicated formatting logic. |

## Suggested improvements

As you work through the PoC with Continue and the MCP servers, you might:

* Extract the duplicated formatting code into a helper function in `utils.py`.
* Add unit tests under a new `tests/` directory.
* Add structured logging with the `logging` module.
* Improve error handling for invalid input.
* Scan dependencies with Snyk and address any vulnerabilities.
* Instrument the app with Sentry for error reporting.

Use the example prompts in the PoC documentation to guide the AI.