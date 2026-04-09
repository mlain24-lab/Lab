# Phase 2: Virtualization & Lab Environment Setup
## Cybersecurity Master's Program - April Block

This repository documents the deployment of a specialized penetration testing environment on a portable host (ROG Ally). The goal was to establish a stable, English-language UI environment while maintaining a localized input method (Spanish QWERTY).

---

### 🛠️ Hardware & Virtualization Specs
The virtual machine (Kali Linux 2024.1) was optimized with the following parameters to balance performance and host stability:

* **RAM:** 4096 MB (4GB)
* **CPU:** 2 Cores
* **Video Memory:** 128 MB (VRAM)
* **Additional Features:** Oracle VirtualBox Extension Pack installed for USB 3.0 and enhanced driver support.

![Hardware Specifications](/img/01-vm-hardware-specs.png)

---

### ⌨️ Localized Configuration (The "Keyboard Challenge")
One critical requirement was maintaining an **English UI** for technical immersion while using a **Spanish Keyboard**. 

I encountered a synchronization issue between the system-level keyboard configuration and the XFCE desktop environment. I resolved this using the terminal:
1.  Used `xfconf-query` to initialize and force the XkbLayout to 'es'.
2.  Applied a persistent system-wide fix by editing `/etc/default/keyboard`.

> **Verification:** `cat /etc/default/keyboard | grep XKBLAYOUT` successfully returned `"es"`.

![Keyboard Persistence Fix](/img/02-keyboard-persistence-fix.png)

---

### 🌐 Network & System Verification
To ensure the lab was fully operational, I executed a series of connectivity and identification tests:

1.  **Internal Networking:** Obtained IP `10.0.2.15` via NAT protocol.
2.  **Internet Connectivity:** Verified via `ping -c 4 8.8.8.8` (0% packet loss).

![Network Connectivity Test](/img/03-network-connectivity-ping.png)

3.  **System Identity:** Logged kernel version and user identity using `uname -a` and `whoami`.

![System Identity Verification](/img/04-system-identity-verification.png)

---

### 🛡️ Resilience & Rollback
A system snapshot titled **"LAB_READY_APRIL"** was created immediately after verification to ensure a clean rollback point for future modules.

**Status:** Environment Verified & Ready for Network Scanning.
