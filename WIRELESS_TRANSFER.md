# Drahtlose Bildübertragung

Es gibt mehrere Möglichkeiten, Bilder drahtlos auf den Raspberry Pi zu übertragen:

## Option 1: Samba (Windows-Freigabe) - EMPFOHLEN

Am einfachsten für Windows-Nutzer.

### Installation

```bash
# Samba installieren
sudo apt update
sudo apt install samba samba-common-bin -y

# Bildordner erstellen (falls nicht vorhanden)
mkdir -p /home/pi/Pictures

# Berechtigungen setzen (Benutzer und Gruppe können schreiben)
chmod 775 /home/pi/Pictures
```

### Konfiguration

```bash
# Samba-Konfiguration bearbeiten
sudo nano /etc/samba/smb.conf
```

Am Ende der Datei hinzufügen:

```ini
[Pictures]
   comment = Photo Frame Pictures
   path = /home/pi/Pictures
   browseable = yes
   writeable = yes
   only guest = no
   create mask = 0664
   directory mask = 0775
   public = no
   read only = no
```

### Benutzer einrichten

```bash
# Samba-Passwort für Benutzer 'pi' setzen
sudo smbpasswd -a pi
# Passwort eingeben (kann anders als SSH-Passwort sein)

# Samba neu starten
sudo systemctl restart smbd
```

### Von Windows verbinden

1. Windows Explorer öffnen
2. In Adresszeile eingeben: `\\photoframe.local\Pictures`
   - Oder: `\\IP-ADRESSE\Pictures`
3. Benutzername: `pi`
4. Passwort: Das gesetzte Samba-Passwort
5. Optional: Netzlaufwerk verbinden (Rechtsklick → "Netzlaufwerk verbinden")

Jetzt können Sie Bilder einfach per Drag & Drop übertragen!

## Option 2: SSH/SCP (Für technische Nutzer)

### Von Windows (mit WinSCP)

1. [WinSCP](https://winscp.net/) herunterladen
2. Neue Verbindung:
   - Host: `photoframe.local` oder IP-Adresse
   - Benutzername: `pi`
   - Passwort: SSH-Passwort
3. Verbinden und Dateien per Drag & Drop übertragen

### Von Linux/Mac

```bash
# Einzelne Datei
scp bild.jpg pi@photoframe.local:/home/pi/Pictures/

# Mehrere Dateien
scp *.jpg pi@photoframe.local:/home/pi/Pictures/

# Ganzer Ordner
scp -r urlaubsbilder/ pi@photoframe.local:/home/pi/Pictures/
```

## Option 3: FTP Server

```bash
# vsftpd installieren
sudo apt install vsftpd -y

# Konfiguration
sudo nano /etc/vsftpd.conf
```

Ändern:
```
write_enable=YES
local_enable=YES
```

```bash
# Neustart
sudo systemctl restart vsftpd
```

Mit FTP-Client (z.B. FileZilla) verbinden:
- Host: `photoframe.local` oder IP
- Port: 21
- Benutzername: `pi`
- Passwort: SSH-Passwort

## Option 4: Cloud-Synchronisation (Nextcloud, Dropbox, etc.)

### Nextcloud-Client

```bash
sudo apt install nextcloud-desktop -y
```

Dann Nextcloud-Account konfigurieren.

### rclone (für Google Drive, Dropbox, OneDrive, etc.)

```bash
# rclone installieren
sudo apt install rclone -y

# Konfiguration
rclone config

# Synchronisation einrichten (Beispiel Google Drive)
rclone sync googledrive:Fotos /home/pi/Pictures

# Automatische Synchronisation (crontab)
crontab -e

# Alle 30 Minuten synchronisieren
*/30 * * * * rclone sync googledrive:Fotos /home/pi/Pictures
```

## Option 5: USB-Stick (Nicht drahtlos, aber einfach)

### Automatisches Kopieren von USB

Erstellen Sie ein Script:

```bash
nano /home/pi/usb_copy.sh
```

Inhalt:
```bash
#!/bin/bash
# Wartet auf USB-Stick und kopiert Bilder

USB_MOUNT="/media/pi/*"
DEST="/home/pi/Pictures"

echo "Warte auf USB-Stick..."

while true; do
    for mount_point in $USB_MOUNT; do
        if [ -d "$mount_point" ]; then
            echo "USB gefunden: $mount_point"
            echo "Kopiere Bilder..."
            
            find "$mount_point" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec cp {} "$DEST/" \;
            
            echo "Fertig! ${count} Bilder kopiert."
            break 2
        fi
    done
    sleep 5
done
```

```bash
chmod +x /home/pi/usb_copy.sh
```

## Option 6: Smartphone (Über App)

### Android: Solid Explorer mit SMB
1. Solid Explorer installieren
2. Netzwerkspeicher hinzufügen (SMB)
3. Server: `photoframe.local`
4. Benutzer: `pi`, Passwort eingeben
5. Bilder hochladen

### iOS: Documents by Readdle
1. App installieren
2. Computer hinzufügen (Windows SMB)
3. Mit Raspberry Pi verbinden
4. Bilder übertragen

## Empfehlung für Ihre Mutter

**Samba (Option 1)** ist am benutzerfreundlichsten:

1. Einmal einrichten
2. Netzlaufwerk in Windows einbinden
3. Bilder einfach in den Ordner ziehen wie auf einen USB-Stick
4. Raspberry Pi zeigt neue Bilder automatisch nach max. 30 Sekunden × Anzahl Bilder

## IP-Adresse des Raspberry Pi finden

```bash
# Auf dem Raspberry Pi
hostname -I

# Oder von anderem Computer
ping photoframe.local
```

## Netzwerk-Troubleshooting

```bash
# Samba-Status prüfen
sudo systemctl status smbd

# Samba-Freigaben anzeigen
smbclient -L localhost -U pi

# Firewall (falls aktiviert)
sudo ufw allow samba
```
