service_start ()
{
    date > /tmp/${project}_${module}_startup
    cd ${bin_dir}; nohup ./startup.sh &
}

service_stop ()
{
    date > /tmp/${project}_${module}_shutdown
    cd ${bin_dir}/shutdown.sh &
}

project=$1
shift
module=$1
shift

dir_base='/opt/tomcat'
bin_dir=${dir_base}/${module}/bin

touch /tmp/control_service

source /etc/profile

case $1 in
    start)
    touch /tmp/control_start
    service_start
    ;;
    stop)
    touch /tmp/control_stop
    service_stop
    ;;
    restart)
    touch /tmp/control_restart
    service_stop
    sleep 1
    service_start
    ;;
    *)
    echo "Usage: $0 start|stop|restart"
    exit 1
    ;;
esac

