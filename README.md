# ansible-rundeck

Scripts and Dockerfile for creation of an ansible host with rundeck as a GUI and vscode for editing

There is a **bash script** for Debian and there is a **Dockerfile** and a **Docker-compose** File if you want to try it out or run it in a Docker Container. Both versions install the following:

- rundeck
- ansible
- mariadb for rundeck
- Visual Studio Code (vscode) server

The Visual Studio Code server is available on port 8080
Rundeck answers on port 4440

For security you would want to hide things behind an NGINX or the like.

## default logins

The default logins/passwords are as follows:

- admin/admin for the rundeck GUI
- onemarcfifty for the vscode server


## Script install version

If you want to run it in a Proxmox Container, then create a container with the following specs:

- Debian 11
- 2, better 4 GB of RAM
- one or two cores
- 10 or better 12 GB of disk.

Run the installation script (install_ansible_rundeck.sh) and it will take care of everything. 

The rundeck user's home directory in the script version is **/var/lib/rundeck**

## Docker Version

If you want to use the Docker version then just grab the files from the ansible-rundeck-docker directory and run the **pre-install.sh** script. This script will in fact create a hidden .env file which contains all the parameters for the containers. After that, just do a docker-compose up and that will spawn two containers – one with rundeck and ansible and a second one with a mariadb.The Dockerfile is built on the official rundeck container and just adds Ansible to it really. 

The rundeck user's home directory in the docker version is **/home/rundeck**

## vscode server

My scripts also install a server version of vscode on the rundeck server. So with this you can use a web browser version of Visual Studio code directly in a browser from your workstation. The advantage of this is that you run the editor on the rundeck / ansible server and you can add all the nice vscode plugins here. Furthermore, the web version of vscode can be used to create, move, copy and delete files on the server without any need for ssh, FileZilla, Winscp or the like. If you need a shell then you can also open that directly in the browser in the Terminal menu. Just be advised that this has not been optimized for security in any way. You might want to hide it behind an NGINx for example.

## Creating an ansible inventory

There are a couple of examples in the **examples** subdirectory. I suggest you create an `ansible` subdirectory under the user's home (there is already a hidden `.ansible` folder which we can ignore). In the Docker version, the ~/ansible directory is mapped to a named volume. The ansible config file should reside in `~/.ansible.cfg` ("~" stands for the rundeck user's home directory). In the docker version there is a symlink from `~/.ansible.cfg` to `~/ansible/ansible.cfg` in order to have the config file in the persistent volume if ever you need to recreate the container.

### inventory defaults

I suggest pointing the inventory to a subdirectory rather than a file. This way you may use multiple plugins for inventories. So at a minimum you would create the following subdirectories:

- ~/ansible/inventory
- ~/ansible/playbooks

and then create the following minimum ~/.ansible.cfg:

    [defaults]
    inventory=~/ansible/inventory


### inventory examples

Now you can use the example inventory files by just copying them over to to ~/ansible/inventory. The following files are included in the examples:

| file                     | description                                         |
| ------------------------ | --------------------------------------------------- |
| 10-static.yaml           | static definition of hosts and groups               |
| 20-nmap.yaml             | scans network for nodes and adds them to inventory  |
| 30-pve-proxmox.yaml      | uses the Proxmox API to add containers and vms      |
| 50-zabbix_inventory.yaml | uses the zabbix inventory for ansible               |
| 99-construct.yaml        | dispatches nodes to groups                          |

### adding the inventory to rundeck

Rundeck can use the Ansible inventory. When you first log into rundeck and you create a new project then rundeck wants to know is where to get the nodes from. Click on “add a new node source” and use the Ansible Resource Model Source. Under “Jobs” – “create a new job” you can now create a job. Under the Workflow section specify the Refresh Project Nodes Type under Workflow steps. When you now run this job then rundeck will query the ansible inventory and update the nodes accordingly. If you use nmap to create the inventory then this may take a while as the network will need to be scanned. You can now verify if the nodes have been added by checking in to the nodes section.

