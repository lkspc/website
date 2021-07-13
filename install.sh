# utils
sudo apt-get install git wget curl unzip -y

# nvs
export NVS_HOME="$HOME/.nvs"
git clone https://github.com/jasongin/nvs "$NVS_HOME"
. "$NVS_HOME/nvs.sh" install
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

# node
NODE_VERSION=12
nvs add $NODE_VERSION
nvs use $NODE_VERSION

# nginx
sudo apt-get update
sudo apt-get install nginx -y
systemctl enable nginx

# docker
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# docker-compose
DC_VERSION=1.29.2
sudo curl -L "https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# gitea config
echo -e \
"version: \"3\"\n\n\
networks:\n\
  gitea:\n\
    external: false\n\n\
services:\n\
  server:\n\
    image: gitea/gitea:latest\n\
    container_name: gitea\n\
    environment:\n\
      - USER_UID=1000\n\
      - USER_GID=1000\n\
    restart: always\n\
    networks:\n\
      - gitea\n\
    volumes:\n\
      - ./gitea:/data\n\
      - /etc/timezone:/etc/timezone:ro\n\
      - /etc/localtime:/etc/localtime:ro\n\
    ports:\n\
      - \"3000:3000\"\n\
      - \"222:22\"" > gitea.yml

# start gitea
sudo docker-compose -f gitea.yml up -d

# destroy gitea
# sudo docker-compose -f gitea.yml down       