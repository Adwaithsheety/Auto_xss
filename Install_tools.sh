#!/bin/bash

# Ensure you have Go installed and set up correctly before running this script

# Install Go tools
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install
github.com/ameenmaali/urldedupe@latest
github.com/hakluke/hakrawler@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest

# Move the binaries to a directory in your PATH
# Assuming Go binaries are installed in ~/go/bin
export PATH=$PATH:~/go/bin

# Make sure the tools are accessible
echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
source ~/.bashrc