# Jenkins SSH Access to Hyper-V Ubuntu VM

This guide explains how to configure **SSH access** from Jenkins to a Hyper-V Ubuntu VM using **Password Authentication** or **Key Authentication**.

---

## 1️⃣ Prerequisites
- Ubuntu VM running in **Hyper-V**
- Jenkins installed (on host or another server)
- Network connectivity between Jenkins and VM
- User account on the VM with sudo privileges

---

## 2️⃣ Enable SSH on Ubuntu VM
```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh
```

---

## 3️⃣ Option 1 — Password Authentication (Not Recommended)

### 3.1 Enable Password Authentication
Edit the SSH configuration:

```bash
sudo nano /etc/ssh/sshd_config
```

Change or add:

```nginx
PasswordAuthentication yes
PermitRootLogin yes   # Only if you need root SSH (not recommended for production)
```

Restart SSH:

```bash
sudo systemctl restart ssh
```

### 3.2 Test Password SSH
From Jenkins server or host:

```bash
ssh username@VM_IP
```
Enter the password when prompted.


### 3.3 Add Jenkins Credentials
Go to Manage Jenkins → Credentials → Add Credentials

Kind: Username with password

Scope: Global (or as required)

Username: VM user

Password: VM password

ID: vm-ssh-password

---

## 4️⃣ Option 2 — Key Authentication (Recommended)

### 4.1 Generate SSH Keys on Jenkins Server
```bash
ssh-keygen -t rsa -b 4096 -C "jenkins@vm"
```
Press Enter for defaults.

### 4.2 Copy Public Key to VM
From Jenkins server:
```bash
ssh-copy-id username@VM_IP
```

If ssh-copy-id is unavailable:
```bash
cat ~/.ssh/id_rsa.pub | ssh username@VM_IP "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

### 4.3 Test Key SSH
```bash
ssh username@VM_IP
```
You should connect without a password prompt.

### 4.4 Add Jenkins Key Credentials
Go to Manage Jenkins → Credentials → Add Credentials

Kind: SSH Username with private key

Scope: Global

Username: VM user

Private Key: Paste contents of ~/.ssh/id_rsa

ID: vm-ssh-key

---

## 5️⃣ Using SSH in Jenkins Jobs
Example pipeline snippet:

```groovy
pipeline {
    agent any
    stages {
        stage('SSH to VM') {
            steps {
                sshagent(['vm-ssh-password']) {  // or 'vm-ssh-key'
                    sh 'ssh -o StrictHostKeyChecking=no username@VM_IP "echo Connected to VM"'
                }
            }
        }
    }
}
```

---

## 6️⃣ Security Notes
Key authentication is more secure and should be preferred.

If you enable password authentication for testing, disable it afterward:

```bash
sudo nano /etc/ssh/sshd_config
# Set PasswordAuthentication no
sudo systemctl restart ssh
```