Vagrant.configure("2") do |config|
  # K8s için stabil olan Ubuntu 22.04 (Jammy) kullanıyoruz
  config.vm.box = "ubuntu/jammy64"
  # Her makinede ortak ön koşul betiğini root yetkisiyle çalıştır
  config.vm.provision "shell", path: "setup.sh", privileged: true

  # Control Plane (Master Node)
  config.vm.define "master" do |master|
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.network "forwarded_port", guest: 32364, host: 8080
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
    end
  end

  # Worker Node 1
  config.vm.define "worker1" do |worker1|
    worker1.vm.hostname = "k8s-worker1"
    worker1.vm.network "private_network", ip: "192.168.56.11"
    worker1.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end

  # Worker Node 2
  config.vm.define "worker2" do |worker2|
    worker2.vm.hostname = "k8s-worker2"
    worker2.vm.network "private_network", ip: "192.168.56.12"
    worker2.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end
end
