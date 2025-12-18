#!/bin/bash
# Installationsskript für Photo Frame

echo "======================================"
echo "Photo Frame Installation"
echo "======================================"
echo ""

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ]; then
    echo "⚠️  Warnung: Dies scheint kein Raspberry Pi zu sein."
    read -p "Trotzdem fortfahren? (j/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Jj]$ ]]; then
        exit 1
    fi
fi

# Update system
echo "📦 System aktualisieren..."
sudo apt update

# Install Python dependencies
echo "🐍 Python-Abhängigkeiten installieren..."
pip3 install -r requirements.txt

# Create pictures directory
PICTURES_DIR="/home/pi/Pictures"
if [ ! -d "$PICTURES_DIR" ]; then
    echo "📁 Bildordner erstellen: $PICTURES_DIR"
    mkdir -p "$PICTURES_DIR"
fi

# Ask about Samba installation
echo ""
echo "======================================"
echo "Drahtlose Bildübertragung"
echo "======================================"
read -p "Möchten Sie Samba für einfache Bildübertragung installieren? (j/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Jj]$ ]]; then
    echo "📡 Samba installieren..."
    sudo apt install -y samba samba-common-bin
    
    # Configure Samba
    echo "⚙️  Samba konfigurieren..."
    
    # Backup existing config
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
    
    # Add Pictures share if not exists
    if ! grep -q "\[Pictures\]" /etc/samba/smb.conf; then
        echo "" | sudo tee -a /etc/samba/smb.conf
        echo "[Pictures]" | sudo tee -a /etc/samba/smb.conf
        echo "   comment = Photo Frame Pictures" | sudo tee -a /etc/samba/smb.conf
        echo "   path = $PICTURES_DIR" | sudo tee -a /etc/samba/smb.conf
        echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf
        echo "   writeable = yes" | sudo tee -a /etc/samba/smb.conf
        echo "   create mask = 0664" | sudo tee -a /etc/samba/smb.conf
        echo "   directory mask = 0775" | sudo tee -a /etc/samba/smb.conf
        echo "   public = no" | sudo tee -a /etc/samba/smb.conf
    fi
    
    # Set permissions (allow user and group to write)
    chmod 775 "$PICTURES_DIR"
    
    # Set Samba password
    echo ""
    echo "🔑 Samba-Passwort für Benutzer 'pi' setzen:"
    sudo smbpasswd -a pi
    
    # Restart Samba
    sudo systemctl restart smbd
    
    echo "✅ Samba installiert und konfiguriert!"
    echo ""
    echo "Verbinden Sie sich von Windows:"
    echo "  \\\\$(hostname).local\\Pictures"
    echo "  oder"
    echo "  \\\\$(hostname -I | awk '{print $1}')\\Pictures"
fi

# Ask about autostart
echo ""
echo "======================================"
echo "Automatischer Start"
echo "======================================"
read -p "Soll Photo Frame automatisch beim Systemstart starten? (j/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Jj]$ ]]; then
    echo "⚙️  Autostart einrichten..."
    
    sudo cp photoframe.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable photoframe.service
    
    echo "✅ Autostart aktiviert!"
    echo ""
    read -p "Jetzt starten? (j/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Jj]$ ]]; then
        sudo systemctl start photoframe.service
        echo "▶️  Photo Frame gestartet!"
    fi
fi

# Disable screensaver
echo ""
echo "======================================"
echo "Bildschirmschoner"
echo "======================================"
read -p "Bildschirmschoner deaktivieren? (empfohlen) (j/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Jj]$ ]]; then
    AUTOSTART_DIR="/home/pi/.config/lxsession/LXDE-pi"
    mkdir -p "$AUTOSTART_DIR"
    
    if ! grep -q "xset s off" "$AUTOSTART_DIR/autostart" 2>/dev/null; then
        echo "@xset s noblank" >> "$AUTOSTART_DIR/autostart"
        echo "@xset s off" >> "$AUTOSTART_DIR/autostart"
        echo "@xset -dpms" >> "$AUTOSTART_DIR/autostart"
    fi
    
    echo "✅ Bildschirmschoner deaktiviert!"
fi

echo ""
echo "======================================"
echo "✅ Installation abgeschlossen!"
echo "======================================"
echo ""
echo "Nächste Schritte:"
echo "1. Bilder nach $PICTURES_DIR kopieren"
echo "2. Konfiguration anpassen: nano config.json"
echo "3. Manuell starten: python3 photo_frame.py"
echo ""
echo "Weitere Informationen:"
echo "  - Hardware: cat HARDWARE.md"
echo "  - Setup: cat SETUP.md"
echo "  - Bildübertragung: cat WIRELESS_TRANSFER.md"
echo ""
