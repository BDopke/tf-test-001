import os
import requests
from atlassian import Confluence


ENDPOINTS = os.environ["ENDPOINTS"]
CONFLUENCE_SPACE = os.environ["CONFLUENCE_SPACE"]
CONFLUENCE_PARENT_PAGE_ID = os.environ["CONFLUENCE_PARENT_PAGE_ID"]


def ping_endpoint(endpoint: str) -> int:
    """Pings certain HTTP(s) endpoint.

    Args:
        endpoint (str): HTTP(s) endpoint

    Returns:
        int: returns HTTP status code
    """
    with requests.Session() as session:
        request = session.get(endpoint, timeout=5)

    return request.status_code


def create_confluence_table(table_data):
    """Creates table in Confluence

    Args:
        table_data: data to generate HTML table

    Returns:
        _type_: returns HTML table
    """
    html_table = "<table><tr><th>URL</th><th>HTTP Status Code</th></tr>"
    for row in table_data:
        html_table += f"<tr><td>{row[0]}</td><td>{row[1]}</td></tr>"
    html_table += "</table>"
    return html_table


def handler():
    confluence = Confluence(
        url=os.environ["CONFLUENCE_URL"],
        api_version="cloud",
        username=os.environ["CONFLUENCE_MAIL_ADDRESS"],
        password=os.environ["CONFLUENCE_API_KEY"],
    )

    table_data = []
    for endpoint in ENDPOINTS:
        try:
            status = ping_endpoint(endpoint)
        except requests.exceptions.RequestException as exception:
            print(exception)
            continue
        table_data.append([endpoint, status])

    table = create_confluence_table(table_data)

    confluence.create_page(
        space=CONFLUENCE_SPACE,
        title="Pre-Transition Network Validation",
        body=table,
        parent_id=None
        if CONFLUENCE_PARENT_PAGE_ID == ""
        else CONFLUENCE_PARENT_PAGE_ID,
    )
