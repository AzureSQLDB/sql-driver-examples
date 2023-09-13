sudo cp ./scripts/ms-repo.pref /etc/apt/preferences.d/
sudo apt-get update
sudo apt install dotnet-sdk-6.0 -y
dotnet tool install -g microsoft.sqlpackage
sudo apt-get update
sudo apt-get install sqlcmd
