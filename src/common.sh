source $HOME/.devtools

function check_last_command
{
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
        exit
    fi
}

function request_sudo
{
    echo "Need to use SUDO..."
    sudo echo "OK"
    check_last_command
}

function set_default_ip
{
    if [ -z $IP ]
    then
        IP=$1
    fi
}
