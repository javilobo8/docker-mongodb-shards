docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
rm -rf data
mkdir data