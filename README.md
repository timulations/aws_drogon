# aws_drogon
Running drogon server on Amazon Linux (suitable for t2.micro free tier EC2 instances) while minimizing cost.

## "Cross compile" by building your Drogon application on an Amazon Linux Docker image
Clone this repo for a modified `Dockerfile` built on the `amazonlinux:latest`

Setting up Docker container for compiling Drogon applications
```
git clone https://github.com/timulations/aws_drogon.git
cd aws_drogon

# build docker image
# here I used linux/amd64 for the t2.micro Amazon-Linux free tier EC2 instance, replace with your desired architecture
docker build -t amazonlinux_drogon_amd64:latest --platform linux/amd64 .

# run docker container from image
# replace HOST_PORT:CONTAINER_PORT with port mapping of desire for testing your
# drogon server
docker run -td -p HOST_PORT:CONTAINER_PORT amazonlinux_drogon_amd64 --platform linux/amd64

# find out the container name
docker ps

docker cp your/drogon/project/folder YOUR_CONTAINER_ID:/desired/location/in/container
```

Then simply build/compile your Drogon project inside the Docker container!

## Transferring built server binary onto AWS EC2 instance
Once the compilation is complete you can just `scp` the binary directly to the EC2 instance for deployment, without wasting EC2 computation time/power and storage space for compiling the Drogon server binary. Save some money 💰
```
scp -i path/to/your/rsa/key.pem your/built/drogon/binary ec2-user@<address>.<geo>.compute.amazonaws.com:/desired/location/on/ec2/instance
```

## Runtime dependencies
Drogon will depend on `libjsoncpp.so` at runtime. So you can either `scp` that as well into a location within `$PATH` on your EC2 instance, or build from scratch in there.
```
dnf install -y git
dnf install -y gcc
dnf install -y gcc-c++
dnf install -y cmake

git clone https://github.com/open-source-parsers/jsoncpp
df jsoncpp
mkdir build && cd build
cmake ..
make && make install
```

