#/bin/bash

function startDemo()
{

    if [[ -a .env ]]
        then mv -f .env .env.bak
    fi

    echo "Please enter the number next to the name of the database engine in the list you want to use with your WCMS:"
    echo "1) MariaDB"
    echo "2) MySQL 5"
    read dbNumber

# Here comes the logic for filling in the correct value (dockerhub container image name) into 'docker-compose.yml' (by adding a variable to .env)
    case "$dbNumber" in
	    1) echo "dbEngine=mariadb" >> .env
		    ;;
	    2) echo "dbEngine=mysql:5" >> .env
		    ;;
	    *) echo "That is not a valid number from the menu:"
	       rm -f .env
    	       if [[ -a .env.bak ]]
	           then mv -f .env.bak .env
	       fi
	       exit 2
		    ;;
    esac

    echo "Please enter the number next to the name of the Web Content Management System from the list you want to use:"
    echo "1) Joomla!"
    echo "2) WordPress"
    read wcmsNumber

# Here comes the logic for putting the name of the correct WCMS container image into 'docker-compose.yml'
    case "$wcmsNumber" in
	    1) echo "wcmsName=joomla" >> .env
	       echo "wcmsAllCapsName=JOOMLA" >> .env
		    ;;
	    2) echo "wcmsName=wordpress" >> .env
	       echo "wcmsAllCapsName=WORDPRESS" >> .env
		    ;;
	    *) echo "That is not a valid number from the menu"
	       rm -f .env
    	       if [[ -a .env.bak ]]
	           then mv -f .env.bak .env
	       fi
	       exit 3
		    ;;
    esac

    echo "Which TCP port of 'localhost' do you wish to run your demo WCMS on? Please enter a number between 1024 and 65535:"
    read portNumber

# Here comes the logic for checking the entered number and putting it into the right variable:
    if [[ $portNumber -ge 1024 && $portNumber -le 65535 ]]
        then echo "wcmsPort=$portNumber" >> .env
    else
        echo "That is not a number in the valid range"
	rm -f .env
	if [[ -a .env.bak ]]
	    then mv -f .env.bak .env
	fi
	exit 4
    fi

    echo $dbEngine $wcmsName $wcmsPort
    docker-compose up -d
}

function stopDemo()
{
    docker-compose down
}

case "$1" in 
	start) startDemo
		;;
	stop)  stopDemo
		;;
	*) echo "Usage: $0 start|stop"
	   exit 1
		;;
esac

exit 0
