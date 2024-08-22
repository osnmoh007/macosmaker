Here's a README for your `macosmaker` project:

---

# 🍏 macOS Docker Container Setup Script 🚀

Welcome to the macOS Docker Container Setup Script! This project provides a Bash script to create and run a Docker container with various macOS versions. Customize your container's RAM size, CPU cores, disk size, machine name, and ports effortlessly.

## ✨ Features

- 🎨 Choose from a variety of macOS versions (e.g., macOS Sonoma, macOS Ventura, macOS Monterey, etc.).
- 🛠 Customize RAM size, CPU cores, and disk size for your container.
- 🔐 Specify web VNC and VNC ports, with automatic checks to ensure availability.
- 📂 Auto-create storage volume directories.
- 🐳 Automatically installs Docker if it's not already installed.
- 📁 Includes necessary volume mappings.

## 📋 Prerequisites

- **Operating System:** Ubuntu.
- **Docker:** The script will check for Docker and install it if necessary.
> **Note:** This script is designed to run on Ubuntu. Other Linux distributions may require modifications.

## 🏃 Usage

1. **Clone the repository:**

   ```bash
   git clone https://github.com/osnmoh007/macosmaker.git
   cd macosmaker
   ```

2. **Make the script executable:**

   ```bash
   chmod +x run.sh
   ```

3. **Run the script with or without options:**

   You can either use flags to specify the options directly or let the script prompt you interactively.

   **Using Flags:**

   ```bash
   ./run.sh [-r RAM_SIZE] [-c CPU_CORES] [-d DISK_SIZE] [-m MACHINE_NAME] [-p VNC_PORT] [-w WEB_VNC_PORT] [-h]
   ```

   **Without Flags:**

   If you run the script without flags, you'll be prompted to enter the options interactively.

## 🛠 Command-Line Options

- `-r RAM_SIZE`: Set the RAM size (e.g., `4` for `4G`).
- `-c CPU_CORES`: Set the number of CPU cores (e.g., `2`).
- `-d DISK_SIZE`: Set the disk size (e.g., `64` for `64G`).
- `-m MACHINE_NAME`: Set the machine name.
- `-p VNC_PORT`: Set the VNC port (default: `5900`).
- `-w WEB_VNC_PORT`: Set the web VNC port (default: `8006`).
- `-h`: Display help message.

## 📑 Example

```bash
./run.sh -r 8 -c 4 -d 64 -m MyMachine -p 5901 -w 8007
```

This command will set up a Docker container running macOS Ventura (`ventura`), with 8GB of RAM, 4 CPU cores, a 64GB disk, and use VNC port `5901` and web VNC port `8007`.

## 🖥 Available macOS Versions

- `sonoma`: macOS Sonoma
- `ventura`: macOS Ventura
- `monterey`: macOS Monterey
- `big-sur`: macOS Big Sur

## 🙌 Acknowledgments

This project is based on [dockur/macos](https://github.com/dockur/macos.git). Huge thanks to the original creator for their work!

Special thanks to ChatGPT for the support and assistance throughout this project.

## 📄 License

This project is licensed under the MIT License.

## 📞 Contact

Feel free to reach out if you have any questions or need assistance:
- Telegram: [@mohfreestyl](https://t.me/mohfreestyl)
- Website Contact Form: [mohamedmaamir.com](https://mohamedmaamir.com)
