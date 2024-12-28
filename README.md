# docker debian12 Xfce4 vnc

This Docker image provides a Debian 12 environment with XFCE4 desktop accessible via VNC or noVNC. Here's how to set it up and use it

## Prerequisites

- **Docker:** Ensure Docker is installed on your system. If not, install it from the [official Docker website](https://docs.docker.com/get-docker/).

## Installation

**Clone the repository and run**

   ```sh
   git clone https://github.com/leechunyen/docker_debian12_-Xfce4_vnc.git
   cd docker_debian12_-Xfce4_vnc
   chmod +x install.sh
   ./install.sh
   ```

**Usage**

   After running install.sh, you'll receive instructions on how to access the VNC server:

  - Access via noVNC: Open your browser and navigate to `http://<your-host-ip>:<noVNC-port>/vnc.html`.
  - Access via VNC client: Connect your VNC client to `<your-host-ip>` on port `<VNC-port>`.
  
   Note: Replace `<your-host-ip>`, `<noVNC-port>`, and `<VNC-port>` with the values provided by the script or your system's actual configuration.

**Manage the container**
  - Start: Use `docker start <container_name>` to start the container.
  - Stop: Use `docker stop <container_name>` to stop the container.
  - Restart: Use `docker restart <container_name>` to restart the container.
   
    Note: Replace `<container_name>` with the actual name given to your container during installation.


**Additional Docker Commands**
  - View Logs: Use `docker logs <container_name>` to see container logs.
  - Enter Container: Use `docker exec -it <container_name> /bin/bash` for interactive shell access.
   
    Note: Replace `<container_name>` with the actual name given to your container during installation.

**Troubleshooting**
  - Port Conflicts: If you encounter port issues, ensure no other services are using the ports you've chosen.
  - VNC Connection Issues: Check your VNC password and try restarting the container if connectivity persists.
  
## License
  This project is licensed under the MIT License, see the [LICENSE](LICENSE) file for details.

## Supporting me
  [Donate Link](https://gogetfunding.com/open-source-project-and-library/)\
  Thank you for your support!
