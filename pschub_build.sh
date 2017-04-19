docker build -t pschub -f ./Dockerfile .
docker create --name pschub -p 80:80 -v pschub-data:/data pschub
