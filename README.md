# Raspberry Pi Digital Photo Frame

Ein digitaler Bilderrahmen für Raspberry Pi, der automatisch alle 30 Sekunden Bilder von der SD-Karte anzeigt.

## 📸 Projekt-Übersicht

Dieses Projekt verwandelt einen Raspberry Pi mit 7" Touchscreen in einen digitalen Bilderrahmen - das perfekte Geschenk! Der Bilderrahmen:

- ✅ Zeigt Bilder automatisch alle 30 Sekunden
- ✅ Unterstützt drahtlose Bildübertragung
- ✅ Läuft automatisch beim Systemstart
- ✅ Einfache Konfiguration
- ✅ Unterstützt JPG, PNG, GIF, BMP

## 🛠️ Hardware

### Benötigte Komponenten

- **Raspberry Pi Zero 2 W** (~17€) oder Raspberry Pi 3/4
- **7" IPS Display 1024x600** (~45-70€) mit HDMI-Anschluss
- **microSD-Karte** 16GB+ (~10€)
- **Netzteil** 5V/2.5A (~10€)
- **Mini HDMI zu HDMI Kabel** (~5€)

**Gesamtkosten:** ca. 87-112€

➡️ Detaillierte Informationen: [HARDWARE.md](HARDWARE.md)

## 🚀 Schnellstart

### 1. Installation

```bash
# Repository klonen
cd /home/pi
git clone https://github.com/JuliusHubGit/Businesse.git
cd Businesse

# Abhängigkeiten installieren
pip3 install -r requirements.txt

# Bildordner erstellen
mkdir -p /home/pi/Pictures
```

### 2. Bilder hinzufügen

Kopieren Sie Ihre Bilder nach `/home/pi/Pictures`

### 3. Starten

```bash
python3 photo_frame.py
```

**Tastenkombinationen:**
- `ESC` - Vollbildmodus verlassen
- `Q` - Programm beenden

## ⚙️ Konfiguration

Bearbeiten Sie `config.json`:

```json
{
  "image_folder": "/home/pi/Pictures",
  "interval_seconds": 30,
  "shuffle": true,
  "fullscreen": true
}
```

**Parameter:**
- `image_folder` - Pfad zum Bildordner
- `interval_seconds` - Sekunden zwischen Bildwechseln
- `shuffle` - Zufällige Reihenfolge (true/false)
- `fullscreen` - Vollbildmodus (true/false)

## 🔄 Automatischer Start

```bash
# Service installieren
sudo cp photoframe.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable photoframe.service
sudo systemctl start photoframe.service

# Status prüfen
sudo systemctl status photoframe.service
```

## 📡 Drahtlose Bildübertragung

### Empfohlen: Samba (Windows-Freigabe)

```bash
# Samba installieren
sudo apt install samba -y

# Konfiguration
sudo nano /etc/samba/smb.conf
```

Fügen Sie am Ende hinzu:

```ini
[Pictures]
   path = /home/pi/Pictures
   writeable = yes
   create mask = 0777
   directory mask = 0777
```

```bash
# Samba-Benutzer einrichten
sudo smbpasswd -a pi
sudo systemctl restart smbd
```

**Von Windows verbinden:**
- Windows Explorer: `\\photoframe.local\Pictures`
- Benutzername: `pi`
- Bilder per Drag & Drop übertragen!

➡️ Weitere Optionen (SCP, FTP, Cloud): [WIRELESS_TRANSFER.md](WIRELESS_TRANSFER.md)

## 📖 Dokumentation

- **[HARDWARE.md](HARDWARE.md)** - Hardware-Spezifikationen und Einkaufsliste
- **[SETUP.md](SETUP.md)** - Detaillierte Setup-Anleitung
- **[WIRELESS_TRANSFER.md](WIRELESS_TRANSFER.md)** - Bildübertragung-Optionen

## 🎁 Als Geschenk einrichten

### Für Ihre Mutter vorbereiten:

1. ✅ Raspberry Pi OS installieren und konfigurieren
2. ✅ Photo Frame Software installieren
3. ✅ Samba für einfache Bildübertragung einrichten
4. ✅ Automatischen Start aktivieren
5. ✅ Erste Bilder hinzufügen
6. ✅ In schönem Gehäuse montieren (optional)
7. ✅ Anleitung ausdrucken:
   - Wie man den Bilderrahmen ein-/ausschaltet
   - Wie man neue Bilder hinzufügt (Windows-Freigabe)
   - Kontakt bei Problemen

### Einfache Bedienungsanleitung für Empfänger:

**Neue Bilder hinzufügen (Windows):**
1. Windows Explorer öffnen
2. In Adressleiste eingeben: `\\photoframe.local\Pictures`
3. Benutzername: `pi`, Passwort: [Ihr Passwort]
4. Bilder in den Ordner ziehen
5. Fertig! Bilder erscheinen automatisch

## 🔧 Troubleshooting

### Programm startet nicht
```bash
sudo systemctl status photoframe.service
journalctl -u photoframe.service -f
```

### Keine Bilder sichtbar
- Prüfen Sie den Pfad in `config.json`
- Prüfen Sie Berechtigungen: `ls -la /home/pi/Pictures`
- Unterstützte Formate: JPG, PNG, GIF, BMP

### Display zeigt nichts
- HDMI-Kabel prüfen
- Display-Stromversorgung prüfen
- `/boot/config.txt` anpassen (siehe SETUP.md)

## 📝 Lizenz

Dieses Projekt ist Open Source und kann frei verwendet werden.

## 🤝 Beitragen

Verbesserungsvorschläge und Bug-Reports sind willkommen!

---

**Viel Freude mit Ihrem digitalen Bilderrahmen! 🖼️**
