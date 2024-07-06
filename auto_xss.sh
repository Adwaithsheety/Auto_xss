#!/bin/bash

set -e

bold="\e[1m"
version="1.2.0"
red="\e[1;31m"
green="\e[32m"
blue="\e[34m"
cyan="\e[0;36m"
end="\e[0m"

printf "$bold$blue ** Developed by Adwaith Shetty <3 ** \n\n$end"

construct_mode(){
    local domain=$1
    if [ -d "results" ]; then
        cd results
    else
        mkdir results
        cd results
    fi

    echo -e "${green}Creating Directory for $domain ....$end"

    if [ -d "$domain" ]; then
        printf "$red$domain Directory already exists. Checking existing results and skipping completed steps.$end\n\n"
        cd $domain
    else
        mkdir $domain
        cd $domain
    fi

    # Check if subdomains file already exists
    if [ -f "${domain}_subdomains.txt" ]; then
        echo "Subdomains file already exists. Skipping subdomain discovery."
    else
        echo -e "\nFinding subdomains for $domain using subfinder ...."
        subfinder -d "$domain" -o "${domain}_subdomains.txt"
        printf "Subdomains stored in $blue${domain}_subdomains.txt$end\n\n"
    fi

    # Check if live subdomains file already exists
    if [ -f "${domain}_httpx.txt" ]; then
        echo "Live subdomains file already exists. Skipping live subdomain checking."
    else
        echo -e "\nFinding live subdomains using httpx ...."
        httpx -l "${domain}_subdomains.txt" -o "${domain}_httpx.txt"
        printf "Live subdomains stored in $blue${domain}_httpx.txt$end\n\n"
    fi

    # Check if endpoints file already exists
    if [ -f "${domain}_endpoints_hakrawler.txt" ] && [ -f "${domain}_endpoints_waybackurls.txt" ] && [ -f "${domain}_endpoints_katana.txt" ]; then
        echo "Endpoints file already exists. Skipping endpoint discovery."
    else
        echo -e "\nFinding endpoints for $domain using hakrawler, waybackurls, and katana ...."

        # Adjusted hakrawler command
        cat "${domain}_httpx.txt" | hakrawler -d 2 -subs -insecure -t 20 > "${domain}_endpoints_hakrawler.txt"
        cat "${domain}_httpx.txt" | waybackurls > "${domain}_endpoints_waybackurls.txt"
        cat "${domain}_httpx.txt" | katana -jc -jsl -resume -silent -o "${domain}_endpoints_katana.txt"
        cat "${domain}_endpoints_hakrawler.txt" "${domain}_endpoints_waybackurls.txt" "${domain}_endpoints_katana.txt" | sort -u > "${domain}_endpoints.txt"

        printf "Endpoints stored in $blue${domain}_endpoints.txt$end\n\n"
    fi

    # Check if filtered endpoints file already exists
    if [ -f "${domain}_endpoints_filtered.txt" ]; then
        echo "Filtered endpoints file already exists. Skipping duplicate removal."
    else
        echo -e "\nRemoving duplicates from endpoints ...."
        cat "${domain}_endpoints.txt" | urldedupe > "${domain}_endpoints_filtered.txt"
        printf "Filtered endpoints stored in $blue${domain}_endpoints_filtered.txt$end\n\n"
    fi

    # Check if XSS endpoints file already exists
    if [ -f "${domain}_xss.txt" ]; then
        echo "XSS endpoints file already exists. Skipping GF pattern filtering."
    else
        echo -e "\nFiltering endpoints for XSS using GF patterns ...."
        cat "${domain}_endpoints_filtered.txt" | gf xss > "${domain}_xss.txt"
        printf "Potential XSS endpoints stored in $blue${domain}_xss.txt$end\n\n"
    fi

    # Check if reflected parameters file already exists
    if [ -f "${domain}_xss_reflected.txt" ]; then
        echo "Reflected parameters file already exists. Skipping Gxss."
    else
        echo -e "\nFinding reflected parameters using Gxss ...."
        cat "${domain}_xss.txt" | Gxss -p khXSS -o "${domain}_xss_reflected.txt"
        printf "Reflected parameters stored in $blue${domain}_xss_reflected.txt$end\n\n"
    fi

    # Check if vulnerable XSS file already exists
    if [ -f "${domain}_vulnerable_xss.txt" ]; then
        echo "Vulnerable XSS file already exists. Skipping Dalfox."
    else
        echo -e "\nFinding XSS vulnerabilities using Dalfox ...."
        dalfox file "${domain}_xss_reflected.txt" -o "${domain}_vulnerable_xss.txt"
        printf "Vulnerable XSS endpoints stored in $blue${domain}_vulnerable_xss.txt$end\n\n"
    fi
}

usage(){
    printf "Usage:\n\n"
    printf "./Auto_xss.sh -u <target.com>\n"
    printf "./Auto_xss.sh -dL <domains.txt>\n"
    exit 1
}

missing_arg(){
    echo -e "${red}${bold}Missing Argument $1$end\n"
    usage
}

# Handling user arguments
while getopts ":u:dL:" opt; do
    case $opt in
        u) DOMAIN="$OPTARG";;
        dL) DOMAINS_FILE="$OPTARG";;
        \?) echo "Invalid option -$OPTARG"; usage;;
    esac
done

# Creating Dir and fetch URLs for a domain
if [ -n "$DOMAIN" ]; then
    construct_mode "$DOMAIN"
elif [ -n "$DOMAINS_FILE" ]; then
    while IFS= read -r domain; do
        construct_mode "$domain"
    done < "$DOMAINS_FILE"
else
    missing_arg "-u or -dL"
fi

# Final result
echo -e "Reconnaissance completed. Results stored in$blue results/ ${end}directory."
