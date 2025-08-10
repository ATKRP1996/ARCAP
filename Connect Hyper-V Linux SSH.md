````markdown
# SSH Setup Guide for Ubuntu VM

## 1️⃣ Install and Enable SSH Server
```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
````

Check status:

```bash
sudo systemctl status ssh
```

---

## 2️⃣ Check SSH Port

Default SSH port is **22**:

```bash
sudo ss -tulpn | grep ssh
```

---

## 3️⃣ Allow SSH Through Firewall (if UFW is enabled)

```bash
sudo ufw allow ssh
sudo ufw enable
sudo ufw status
```

---

## 4️⃣ Generate SSH Keys (on Client/Host)

Run this on your **host machine** (Windows with Git Bash, Linux, or macOS):

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Press Enter for defaults. This creates:

```
~/.ssh/id_rsa      # Private key
~/.ssh/id_rsa.pub  # Public key
```

---

## 5️⃣ Copy Public Key to VM

From host:

```bash
ssh-copy-id username@VM_IP
```

If `ssh-copy-id` is not available (e.g., PowerShell), run:

```bash
type $env:USERPROFILE\.ssh\id_rsa.pub | ssh username@VM_IP "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

---

## 6️⃣ (Optional) Disable Password Logins

On VM:

```bash
sudo nano /etc/ssh/sshd_config
```

Set:

```
PasswordAuthentication no
PubkeyAuthentication yes
```

Restart SSH:

```bash
sudo systemctl restart ssh
```

---

## 7️⃣ Connect Using Private Key

From host:

```bash
ssh -i ~/.ssh/id_rsa username@VM_IP
```

On Windows PowerShell:

```powershell
ssh -i C:\Users\YourUser\.ssh\id_rsa username@VM_IP
```

---

✅ You now have secure, key-based SSH access to your Ubuntu VM.

```

---

If you want, I can also make a **second GitHub-ready Markdown file** for the **persistent Hyper-V Ubuntu network setup** so your IP settings survive reboots.  
Do you want me to prepare that one too?
```
