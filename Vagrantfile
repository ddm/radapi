Vagrant.configure("2") do |config|
	config.vm.box = "debian/jessie64"
	config.vm.box_check_update = true

	config.vm.network "forwarded_port", guest: 8082, host: 8082 # CockroachDB
	config.vm.network "forwarded_port", guest: 8080, host: 8080 # RethinkDB
	config.vm.network "forwarded_port", guest: 8529, host: 8529 # ArangoDB
	config.vm.network "forwarded_port", guest: 5432, host: 5432 # PostgreSQL
	config.vm.network "forwarded_port", guest: 5050, host: 5050 # pgadmin
	config.vm.network "forwarded_port", guest: 6379, host: 6379 # Redis
	config.vm.network "forwarded_port", guest: 8081, host: 6379 # Redis Commander
	config.vm.network "forwarded_port", guest: 9200, host: 9200 # Elasticsearch
	config.vm.network "forwarded_port", guest: 8086, host: 8086 # InfluxDB
	config.vm.network "forwarded_port", guest: 8083, host: 8083 # InfluxDB
	config.vm.network "forwarded_port", guest: 9090, host: 9090 # Prometheus
	config.vm.network "forwarded_port", guest: 5601, host: 5601 # Kibana
	config.vm.network "forwarded_port", guest: 3000, host: 3000 # Grafana
	config.vm.network "forwarded_port", guest: 1880, host: 1880 # radapi
	config.vm.network "forwarded_port", guest: 4400, host: 4400 # WeaveScope

	config.vm.synced_folder "./", "/vagrant"

	config.vm.provider "virtualbox" do |v|
		v.name = "dev"
		v.memory = "4096"
		v.cpus = 2
		v.gui = false
	end

	config.vm.provision :docker
	config.vm.provision "shell", inline: "sudo sysctl -w vm.max_map_count=262144" # ES
	config.vm.provision :docker_compose, compose_version: "1.11.1", yml: "/vagrant/docker-compose.yml", run: "always"
end
