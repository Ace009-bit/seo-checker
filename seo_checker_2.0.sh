#!/bin/bash

clear
echo " "
echo "@@@@@@ @@@@@@@@  @@@@@@        @@@@@@@ @@@  @@@ @@@@@@@@  @@@@@@@ @@@  @@@ @@@@@@@@ @@@@@@@"
echo "!@@     @@!      @@!  @@@      !@@      @@!  @@@ @@!      !@@      @@!  !@@ @@!      @@!  @@@"
echo " !@@!!  @!!!:!   @!@  !@!      !@!      @!@!@!@! @!!!:!   !@!      @!@@!@!  @!!!:!   @!@!!@!"
echo "    !:! !!:      !!:  !!!      :!!      !!:  !!! !!:      :!!      !!: :!!  !!:      !!: :!!"
echo " ::.: :  : :: :::  : :. :        :: :: :  :   : : : :: :::  :: :: :  :   ::: : :: :::  :   : :"
echo "-------------------------------------------------------------------------------------------"
echo "🔍 Black Hat SEO & Security Tool"
echo "-------------------------------------------------------------------------------------------"

while true; do
    echo "\nMain Menu:"
    echo "1. SEO Analysis"
    echo "2. Website Vulnerability Scan"
    echo "3. Subdomain Enumeration"
    echo "4. CMS Detection"
    echo "5. WHOIS Lookup"
    echo "6. Port Scanning"
    echo "7. DNS Record Lookup"
    echo "8. SSL Certificate Information"
    echo "9. Extract Emails from Website"
    echo "10. Exit"
    read -p "Choose an option: " OPTION

    case $OPTION in
        1)
            read -p "Enter website URL: " URL
            echo "🔍 Running SEO analysis on $URL ..."
            curl -s "$URL" | grep -Eo '<title>.*</title>'
            curl -s "$URL" | grep -Eo '<meta name="description" content=".*">'
            curl -s "$URL" | grep -Eo '<h[1-6]>.*</h[1-6]>'
            lynx -dump "$URL" | awk 'length($0) > 40' | head -n 10
            ;;
        2)
            read -p "Enter website URL: " URL
            echo "🔍 Scanning for vulnerabilities on $URL ..."
            nmap --script vuln "$URL"
            ;;
        3)
            read -p "Enter domain to scan subdomains: " DOMAIN
            echo "🔍 Enumerating subdomains for $DOMAIN ..."
            subfinder -d "$DOMAIN"
            ;;
        4)
            read -p "Enter website URL: " URL
            echo "🔍 Detecting CMS used by $URL ..."
            whatweb "$URL"
            ;;
        5)
            read -p "Enter domain for WHOIS lookup: " DOMAIN
            echo "🔍 Performing WHOIS lookup on $DOMAIN ..."
            whois "$DOMAIN"
            ;;
        6)
            read -p "Enter target for port scanning: " TARGET
            echo "🔍 Running port scan on $TARGET ..."
            nmap -sV "$TARGET"
            ;;
        7)
            read -p "Enter domain for DNS lookup: " DOMAIN
            echo "🔍 Fetching DNS records for $DOMAIN ..."
            dig ANY "$DOMAIN" +noall +answer
            ;;
        8)
            read -p "Enter website URL: " URL
            echo "🔍 Fetching SSL certificate details for $URL ..."
            echo | openssl s_client -connect "$URL":443 2>/dev/null | openssl x509 -noout -issuer -subject -dates
            ;;
        9)
            read -p "Enter website URL: " URL
            echo "🔍 Extracting email addresses from $URL ..."
            curl -s "$URL" | grep -Eo "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
            ;;
        10)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please choose again."
            ;;
    esac
done
