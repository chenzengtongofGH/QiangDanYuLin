#!/bin/sh

if [ ! -d "../outputClient" ];
	then
		mkdir "../outputClient"
fi

if [ ! -d "../outputServer" ];
	then
		mkdir "../outputServer"
fi

if [ ! -d "../outputAdminServer" ];
	then
		mkdir "../outputAdminServer"
fi

echo "---common---"
cd common
python start.py $3
cd ..

echo "---chapter---"
cd chapter
python start.py $3
cd ..

echo "---exp---"
cd exp
python start.py $3
cd ..

echo "---error---"
cd error
python start.py $3
cd ..

echo "---map---"
cd map
python start.py $3
cd ..

echo "---role---"
cd role
python start.py $3
cd ..

echo "---Items---"
cd Items
python start.py $3
cd ..

echo "---payment---"
cd payment
python start.py $3
cd ..

echo "---skill---"
cd skill
python start.py $3
cd ..

echo "---valueconfig---"
cd valueconfig
python start.py $3
cd ..

echo "---vip---"
cd vip
python start.py $3
cd ..

echo "---random---"
cd random
python start.py $3
cd ..

echo "---store---"
cd store
python start.py $3
cd ..

echo "---activity---"
cd activity
python start.py $3
cd ..

echo "--translate--"
cd translate
python start.py $2 $3
cd ..
