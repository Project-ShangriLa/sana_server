@dir = Dir::pwd

worker_processes 2 # CPUのコア数に揃える
working_directory @dir

timeout 120


# unicornは標準出力には何も吐かないのでログ出力を忘れずに
#stderr_path "#{@dir}log/unicorn.stderr.log"
#stdout_path "#{@dir}log/unicorn.stdout.log"

pid "/var/unicorn_sana_api.pid" #pidを保存するファイル
listen 4000

#listen "/var/unicorn_sana_api.sock", :backlog => 1024
