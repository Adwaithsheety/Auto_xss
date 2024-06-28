# Auto_xss
auto_xss is a Bash script designed to automate the process of discovering XSS vulnerabilities in web applications. It integrates various tools to streamline the workflow from subdomain discovery to XSS detection.

Overview

auto_xss automates the process of finding XSS vulnerabilities using a sequence of steps involving popular security tools. It starts from discovering subdomains to filtering endpoints susceptible to XSS, and finally checking them for vulnerabilities using Dalfox.
Tools Integrated

The following tools are utilized by auto_xss:

    subfinder: Used to discover subdomains of a target domain.
    httpx: Checks which of the discovered subdomains are live and accessible over HTTP/HTTPS.
    gau: Retrieves URLs by scraping them from Google using the provided domain.
    katana: Expands the list of endpoints by performing HTTP requests and extracting URLs.
    uro: Removes duplicate URLs from the endpoint list.
    gf: Filters endpoints for potential XSS vulnerabilities using predefined patterns.
    Gxss: Identifies reflected parameters in URLs that could be exploited for XSS attacks.
    dalfox: Scans URLs identified with potential XSS vulnerabilities to confirm and classify them.

Pre-Requisites

Ensure you have the following prerequisites installed:

    Go Programming Language: Required to install and run some of the tools.
    Docker (Optional): For containerized execution of the script.

Installation

Clone the repository and make the script executable:

bash

git clone https://github.com/Adwaithsheety/auto_xss.git
cd auto_xss
chmod +x auto_xss.sh

Usage

Use the script with the -d flag followed by the target domain:

bash

./auto_xss.sh -d example.com

Options

    -d <domain>: Specify the target domain for XSS scanning.
    -dL domains.txt: Specify the domain list for Scanning.

# Basic usage
./auto_xss.sh -d example.com
./auto_Xss.sh -dL domains.txt

# Include Blind XSS payload and specify output file
./auto_xss.sh -d example.com 

Credits

auto_xss leverages the capabilities of several powerful tools and frameworks. I extend our gratitude to the following developers and communities:

    Project Discovery for subfinder
    Project Discovery for httpx
    Corben Leo for gau
    1ndianl33t for Gf-Patterns
    TomNomNom for waybackurls and gf
    hahwul for Dalfox

Their contributions to the cybersecurity community enable efficient and effective web security testing, helping identify and mitigate XSS vulnerabilities.
Support

If auto_xss helped you find XSS vulnerabilities, consider giving it a star or contributing to its development!

Buy Me a Coffee

License

This project is licensed under the MIT License - see the LICENSE file for details.
