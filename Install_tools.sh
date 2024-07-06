
#!/bin/bash

# Ensure you have Go installed and set up correctly before running this script

# Install Go tools
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/dwisiswant0/gf@latest
go install github.com/Emoe/kxss@latest
go install github.com/hahwul/dalfox/v2@latest

# Ensure the Go bin directory is in your PATH
export PATH=$PATH:~/go/bin
echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
source ~/.bashrc

# Install system-based tools
sudo apt update
sudo apt install -y jq

# Verify installation
echo "Installed tools versions:"
subfinder -version
httpx -version
hakrawler -version
waybackurls -version
katana -version
gf -version
kxss -version
dalfox -version

echo "Installation complete. Make sure to restart your terminal or source your bash profile."