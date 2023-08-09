import os
import requests
from atlassian import Confluence


ENDPOINTS = (os.environ["ENDPOINTS"]).split(",")
CONFLUENCE_SPACE = os.environ["CONFLUENCE_SPACE"]
CONFLUENCE_PARENT_PAGE_ID = os.environ["CONFLUENCE_PARENT_PAGE_ID"]


def ping_endpoint(endpoint: str):
    """Pings certain HTTP(s) endpoint.

    Args:
        endpoint (str): HTTP(s) endpoint

    Returns:
        int: returns HTTP status code or -1 in case of an error
    """
    try:
        with requests.Session() as session:
            request = session.get(endpoint, timeout=2)
        return request.status_code
    except requests.exceptions.RequestException as err:
        print(f"An error occurred while pinging {endpoint}: {err}")
        return "Connection Error"


def create_confluence_table(table_data):
    """Creates table in Confluence

    Args:
        table_data: data to generate HTML table

    Returns:
        str: returns HTML table
    """
    html_table = "<table><tr><th>URL</th><th>HTTP Status Code</th></tr>"
    for row in table_data:
        html_table += f"<tr><td>{row[0]}</td><td>{row[1]}</td></tr>"
    html_table += "</table>"
    return html_table


def handler(event, context):
    confluence = Confluence(
        url=os.environ["CONFLUENCE_URL"],
        api_version="cloud",
        username=os.environ["CONFLUENCE_MAIL_ADDRESS"],
        password=os.environ["CONFLUENCE_API_KEY"],
    )

    table_data = []
    for endpoint in ENDPOINTS:
        status_code = ping_endpoint(endpoint)
        table_data.append([endpoint, status_code])

    table = create_confluence_table(table_data)

    try:
        page_response = confluence.create_page(
            space=CONFLUENCE_SPACE,
            title="Pre-Transition Network Validation",
            body=table,
            parent_id=None
            if CONFLUENCE_PARENT_PAGE_ID == ""
            else CONFLUENCE_PARENT_PAGE_ID,
        )
        print(page_response)
    except Exception as e:
        print(f"An error occurred while creating the Confluence page: {e}")
