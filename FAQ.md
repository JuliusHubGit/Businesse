# FAQ - Häufig gestellte Fragen

## Allgemein

### Welchen Raspberry Pi brauche ich?

**Empfohlen:**
- **Raspberry Pi Zero 2 W** - Kompakt, günstig (~17€), WLAN integriert
- **Raspberry Pi 3 Model B+** - Mehr Leistung (~35€)
- **Raspberry Pi 4 Model B** - Beste Performance (~45€)

**Hinweis:** Es gibt kein "Raspberry Pi 2 W". Wahrscheinlich ist der Zero 2 W gemeint.

### Welches Betriebssystem?

**Raspberry Pi OS (32-bit) mit Desktop** wird empfohlen.
- Lite-Version funktioniert auch, erfordert aber mehr Konfiguration
- 64-bit Version ist auch möglich

### Wie groß sollte die microSD-Karte sein?

- **Minimum:** 8 GB
- **Empfohlen:** 16-32 GB
- **Mit vielen Bildern:** 64 GB

## Installation & Setup

### Installation schlägt fehl - was tun?

```bash
# System aktualisieren
sudo apt update && sudo apt upgrade -y

# Python3 und pip installieren
sudo apt install python3 python3-pip -y

# Manuell Pillow installieren
pip3 install Pillow --user
```

### Display wird nicht erkannt?

In `/boot/config.txt` anpassen:
```bash
sudo nano /boot/config.txt
```

Hinzufügen:
```
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1024 600 60 6 0 0 0
```

### Programm startet nicht automatisch?

```bash
# Service-Status prüfen
sudo systemctl status photoframe.service

# Logs anzeigen
journalctl -u photoframe.service -n 50

# Service manuell starten
sudo systemctl start photoframe.service

# Autostart aktivieren
sudo systemctl enable photoframe.service
```

## Bildübertragung

### Samba funktioniert nicht?

```bash
# Samba-Status prüfen
sudo systemctl status smbd

# Samba neu starten
sudo systemctl restart smbd

# Firewall-Regel (falls aktiviert)
sudo ufw allow samba

# Samba-Freigaben testen
smbclient -L localhost -U pi
```

### Kann nicht von Windows verbinden?

1. **Hostname funktioniert nicht:**
   - Statt `\\photoframe.local\Pictures`
   - Nutzen Sie IP: `\\192.168.1.XXX\Pictures`
   - IP finden: `hostname -I` auf dem Pi

2. **Passwort wird nicht akzeptiert:**
   - Samba-Passwort neu setzen: `sudo smbpasswd -a pi`
   - SSH-Passwort ist NICHT das Samba-Passwort!

3. **Netzwerkerkennung aktivieren:**
   - Windows → Einstellungen → Netzwerk
   - "Netzwerkerkennung" aktivieren

### Alternative zu Samba?

Ja, mehrere Optionen:
1. **SCP/SFTP** - Mit WinSCP (Windows) oder Cyberduck (Mac)
2. **FTP** - vsftpd installieren
3. **Cloud-Sync** - rclone mit Google Drive/Dropbox
4. **USB-Stick** - microSD direkt am PC

Details: siehe `WIRELESS_TRANSFER.md`

## Bilder & Anzeige

### Welche Bildformate werden unterstützt?

- ✅ JPG/JPEG
- ✅ PNG
- ✅ GIF
- ✅ BMP

Nicht unterstützt:
- ❌ RAW-Formate (CR2, NEF, etc.)
- ❌ TIFF (konvertieren zu JPG)
- ❌ HEIC (iPhone) - konvertieren zu JPG

### Bilder sind zu groß/zu klein?

Das Programm passt Bilder automatisch an. Aber:
- **Zu groß** → Langsames Laden
- **Zu klein** → Pixelig

**Empfohlene Auflösung:**
- 1024x600 für 7" Display
- 1920x1080 für Full HD

**Bilder optimieren:**
```bash
sudo apt install imagemagick
cd /home/pi/Pictures
mogrify -resize 1024x600 -quality 85 *.jpg
```

### Neue Bilder werden nicht angezeigt?

Das Programm scannt den Ordner alle ~10 Bilder neu.

**Lösung:**
- Warten Sie einige Minuten
- Oder Service neu starten: `sudo systemctl restart photoframe.service`

### Bilder werden gedreht/verkehrt angezeigt?

```bash
# Mit ImageMagick automatisch drehen (EXIF-Daten)
sudo apt install imagemagick
cd /home/pi/Pictures
mogrify -auto-orient *.jpg
```

### Intervall zu kurz/lang?

In `config.json` ändern:
```json
{
  "interval_seconds": 60
}
```
- `30` = 30 Sekunden
- `60` = 1 Minute
- `300` = 5 Minuten
- `600` = 10 Minuten

Nach Änderung neu starten!

## Performance

### Bilderrahmen ist langsam?

1. **Bilder optimieren:**
   ```bash
   mogrify -resize 1024x600 -quality 85 *.jpg
   ```

2. **Mehr RAM freigeben:**
   ```bash
   sudo raspi-config
   # → Performance Options → GPU Memory → 128 MB
   ```

3. **Übertakten** (fortgeschritten):
   ```bash
   sudo raspi-config
   # → Performance Options → Overclock
   ```

### Bildschirm wird schwarz?

Bildschirmschoner deaktivieren:

```bash
nano ~/.config/lxsession/LXDE-pi/autostart
```

Hinzufügen:
```
@xset s noblank
@xset s off
@xset -dpms
```

## Stromversorgung

### Welches Netzteil?

- **Raspberry Pi Zero 2 W:** 5V/2.5A
- **Raspberry Pi 3/4:** 5V/3A (offizielles Netzteil empfohlen)
- **Display:** Eigenes USB-Netzteil (meist 5V/2A)

### Pi startet nicht?

- Unterspannungs-Symbol (Blitz) → Netzteil zu schwach
- Nutzen Sie offizielles Raspberry Pi Netzteil
- Kurzes USB-Kabel verwenden (Spannungsabfall)

## Erweiterte Funktionen

### Videos abspielen?

Aktuell nicht unterstützt. Erweiterung möglich mit:
- VLC Python-Bindings
- omxplayer
- mpv

### Wetteranzeige/Uhrzeit einblenden?

Erfordert Code-Anpassung. Beispiel in `photo_frame.py`:

```python
# In show_next_image() hinzufügen:
from datetime import datetime
time_str = datetime.now().strftime("%H:%M")
# Dann mit PIL Text auf Bild zeichnen
```

### Fernsteuerung?

Optionen:
1. **SSH** - Terminal-Zugriff
2. **VNC** - Grafischer Zugriff (RealVNC aktivieren)
3. **Webinterface** - Selbst programmieren

### Energiesparen nachts?

Mit cron automatisch an/aus:

```bash
crontab -e
```

```
# Aus um 22:00
0 22 * * * sudo systemctl stop photoframe.service

# An um 7:00
0 7 * * * sudo systemctl start photoframe.service
```

Oder Display-Stromversorgung per Zeitschaltuhr.

## Fehlersuche

### Programm stürzt ab?

```bash
# Logs anzeigen
journalctl -u photoframe.service -n 100

# Manuell testen
cd /home/pi/Businesse
python3 photo_frame.py
```

### Pillow-Import-Fehler?

```bash
# Neuinstallation
pip3 uninstall Pillow
pip3 install Pillow --user

# Oder systemweit
sudo apt install python3-pil python3-pil.imagetk
```

### tkinter-Fehler?

```bash
sudo apt install python3-tk
```

### "Permission denied" Fehler?

```bash
# Berechtigungen setzen
chmod 755 /home/pi/Businesse/photo_frame.py
chmod 777 /home/pi/Pictures

# Besitzer ändern
sudo chown -R pi:pi /home/pi/Businesse
sudo chown -R pi:pi /home/pi/Pictures
```

## Sicherheit

### Ist das sicher?

Für den Heimgebrauch ja. Empfehlungen:
- Starkes WLAN-Passwort
- Starkes Samba-Passwort
- SSH-Key-Authentifizierung nutzen
- Firewall aktivieren (optional)

### SSH absichern?

```bash
# SSH-Key erstellen (am PC)
ssh-keygen -t rsa -b 4096

# Key auf Pi kopieren
ssh-copy-id pi@photoframe.local

# Passwort-Login deaktivieren
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication no

sudo systemctl restart ssh
```

## Wartung

### Updates?

```bash
# System
sudo apt update && sudo apt upgrade -y

# Python-Pakete
pip3 list --outdated
pip3 install --upgrade Pillow
```

### Backup erstellen?

```bash
# Bilder sichern
rsync -av /home/pi/Pictures/ /pfad/zum/backup/

# Ganzes System (von PC)
sudo dd if=/dev/sdX of=backup.img bs=4M status=progress
```

### Lebensdauer SD-Karte?

- Qualitätskarte nutzen (SanDisk, Samsung)
- Read-Only Modus für maximale Lebensdauer (komplex)
- Regelmäßige Backups

---

**Weitere Fragen?**

Siehe auch:
- [SETUP.md](SETUP.md) - Detaillierte Installation
- [WIRELESS_TRANSFER.md](WIRELESS_TRANSFER.md) - Bildübertragung
- [BENUTZERANLEITUNG.md](BENUTZERANLEITUNG.md) - Für Endnutzer

GitHub Issues: https://github.com/JuliusHubGit/Businesse/issues
