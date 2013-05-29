#echo `RAILS_ENV=production bundle exec thin stop -d `
#echo `RAILS_ENV=production bundle exec thin start -d `
#./unicorn restart
./unicorn stop
sleep 5
./unicorn start
kill -9 $(cat ./resque.pid)
RAILS_ENV=production rake resque:work QUEUE=* BACKGROUND=yes PIDFILE=./resque.pid
