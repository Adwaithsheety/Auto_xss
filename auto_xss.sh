#!/bin/bash

set -e

bold="\e[1m"
version="1.2.0"
red="\e[1;31m"
green="\e[32m"
blue="\e[34m"
cyan="\e[0;36m"
end="\e[0m"

printf "$bold$blue ** Developed by Adwaithshetty <3 ** \n\n$end"

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
        printf "$red$domain Directory already exists. Skipping to next domain.\n\n$end"
        return
    fi

    mkdir $domain
    cd $domain

    # Check if subdomains file already exists
    if [ -f "${domain}_subdomains.txt" ]; then
        echo "Subdomains file already exists. Skipping subdomain discovery."
    else
        echo -e "\nFinding subdomains for $domain using subfinder ...."
        subfinder -d "$domain" -o "${domain}_subdomains.txt"
        printf "Subdomains stored in $blue${domain}_subdomains.txt$end\n\n"
    fi

    echo -e "\nFinding live subdomains using httpx ...."
    httpx -l "${domain}_subdomains.txt" -o "${domain}_httpx.txt"
    printf "Live subdomains stored in $blue${domain}_httpx.txt$end\n\n"

    echo -e "\nFinding endpoints for $domain using gau and katana ...."
    echo "$domain" | gau --threads 5 >> "${domain}_endpoints.txt"
    cat "${domain}_httpx.txt" | katana -jc >> "${domain}_endpoints.txt"
    printf "Endpoints stored in $blue${domain}_endpoints.txt$end\n\n"

    echo -e "\nRemoving duplicates from endpoints ...."
    cat "${domain}_endpoints.txt" | uro >> "${domain}_endpoints_filtered.txt"
    printf "Filtered endpoints stored in $blue${domain}_endpoints_filtered.txt$end\n\n"

    echo -e "\nFiltering endpoints for XSS using GF patterns ...."
    cat "${domain}_endpoints_filtered.txt" | gf xss >> "${domain}_xss.txt"
    printf "Potential XSS endpoints stored in $blue${domain}_xss.txt$end\n\n"

    echo -e "\nFinding reflected parameters using Gxss ...."
    cat "${domain}_xss.txt" | Gxss -p khXSS -o "${domain}_xss_reflected.txt"
    printf "Reflected parameters stored in $blue${domain}_xss_reflected.txt$end\n\n"

    echo -e "\nFinding XSS vulnerabilities using Dalfox ...."
    dalfox file "${domain}_xss_reflected.txt" -o "${domain}_vulnerable_xss.txt"
    printf "Vulnerable XSS endpoints stored in $blue${domain}_vulnerable_xss.txt$end\n\n"
}

usage(){
    printf "Usage:\n\n"
    printf "./recon_script.sh -u <target.com>\n"
    printf "./recon_script.sh -dL <domains.txt>\n"
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
