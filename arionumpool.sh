#!/bin/sh
echo "Please enter your wallet's address:"5WuRMXGM7Pf8NqEArVz1NxgSBptkimSpvuSaYC79g1yo3RDQc8TjVtGH5chQWQV7CHbJEuq9DmW5fbm CEW4AghQr
read input_variable
echo "############################"
echo "After installing, your system will start mining on ArionumPool.com"
echo "Your wallet should populate on ArionumPool.com/stats.php after 10 - 15 minutes."
echo "############################"
sleep 15
sudo apt-get update
sudo apt-get install screen maven git openjdk-8-jdk build-essential -y
git clone git://github.com/ProgrammerDan/arionum-java
cd arionum-java/arionum-miner/
mvn clean package
sudo chmod +x build-argon.sh
./build-argon.sh
touch config.cfg
chmod 755 config.cfg
echo "pool
http://mine.arionumpool.com
$input_variable
`nproc`
standard
false
`hostname`
null
false" > config.cfg
sudo chmod +x run.sh
screen -d -m nice -n 19 ./run.sh
echo "############################"
echo "Thank you for mining with ArionumPool.com. If you have any questions, please contact me at admin@hashpi.com."
echo "############################"

