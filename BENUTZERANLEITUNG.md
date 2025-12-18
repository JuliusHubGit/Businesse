# Bedienungsanleitung für Digitalen Bilderrahmen

## Für den Empfänger (z.B. Ihre Mutter)

### 🖼️ Was ist das?

Dies ist ein digitaler Bilderrahmen, der automatisch Ihre Fotos anzeigt. Alle 30 Sekunden wechselt das Bild automatisch.

### 🔌 Ein- und Ausschalten

**Einschalten:**
1. Stecker in die Steckdose
2. Der Bilderrahmen startet automatisch (ca. 30-60 Sekunden)
3. Bilder werden automatisch angezeigt

**Ausschalten:**
1. Stecker aus der Steckdose ziehen
2. Fertig!

### 📸 Neue Bilder hinzufügen (Windows)

#### Methode 1: Über Netzwerk (empfohlen)

1. **Windows Explorer** öffnen (Ordner-Symbol in der Taskleiste)

2. Oben in die Adressleiste klicken und eingeben:
   ```
   \\photoframe.local\Pictures
   ```
   oder (falls das nicht funktioniert):
   ```
   \\192.168.XXX.XXX\Pictures
   ```
   *(Die genaue Adresse steht auf einem Zettel beim Bilderrahmen)*

3. Wenn nach **Benutzername und Passwort** gefragt wird:
   - Benutzername: `pi`
   - Passwort: *(steht auf einem Zettel beim Bilderrahmen)*

4. Jetzt sehen Sie den Bilder-Ordner!
   - Einfach Fotos vom Computer hierher ziehen
   - Die neuen Bilder erscheinen automatisch im Bilderrahmen

5. **Tipp:** Netzlaufwerk verbinden
   - Rechtsklick auf den Ordner
   - "Netzlaufwerk verbinden" wählen
   - Buchstaben wählen (z.B. "P:")
   - Jetzt erscheint der Ordner immer in "Dieser PC"

#### Methode 2: Mit USB-Stick (falls Netzwerk nicht funktioniert)

1. Bilder auf USB-Stick kopieren
2. Bilderrahmen ausschalten
3. microSD-Karte aus dem Raspberry Pi nehmen
4. microSD-Karte in Computer stecken (evtl. Adapter nötig)
5. Zum Ordner `/home/pi/Pictures` navigieren
6. Bilder kopieren
7. microSD-Karte sicher entfernen und zurück in Raspberry Pi
8. Bilderrahmen einschalten

### 🎨 Bilder löschen oder umbenennen

1. Über Netzwerk verbinden (siehe oben)
2. Bilder wie auf dem eigenen Computer löschen/umbenennen
3. Änderungen werden automatisch übernommen

### ⚙️ Einstellungen ändern (Fortgeschritten)

Falls Sie die Zeit zwischen Bildwechseln ändern möchten:

1. Über Netzwerk verbinden
2. Datei `config.json` mit Editor öffnen
3. `interval_seconds` ändern (z.B. 60 für 1 Minute)
4. Speichern
5. Bilderrahmen neu starten (Stecker ziehen und wieder einstecken)

### ❓ Probleme lösen

#### Keine Bilder werden angezeigt
- Sind überhaupt Bilder im Ordner?
- Bildformat prüfen (nur JPG, PNG, GIF, BMP werden unterstützt)
- Bilderrahmen neu starten (Stecker ziehen, 10 Sekunden warten, wieder einstecken)

#### Netzwerkverbindung funktioniert nicht
- Ist der Bilderrahmen mit dem WLAN verbunden?
- Sind Sie im gleichen WLAN?
- Versuchen Sie die IP-Adresse statt `photoframe.local`

#### Bildschirm bleibt schwarz
- Ist der Bildschirm eingeschaltet? (Oft kleiner Knopf am Bildschirm)
- HDMI-Kabel richtig eingesteckt?
- Stromversorgung prüfen

#### Bilder werden nicht aktualisiert
- Nach dem Kopieren neuer Bilder: 
  - Warten Sie bis zu 10 Minuten (Bilderrahmen scannt alle paar Bilder)
  - Oder: Bilderrahmen neu starten

### 📞 Kontakt bei Problemen

Bei Problemen kontaktieren Sie:
- **Name:** ________________
- **Telefon:** ________________
- **E-Mail:** ________________

### 💡 Tipps

- **Bildgröße:** Große Bilder (mehrere MB) können langsam laden. Für beste Performance Bilder auf 2-3 MB verkleinern.

- **Bildformat:** Querformat (16:9 oder 4:3) nutzt den Bildschirm am besten aus.

- **Bildanzahl:** Bei vielen Bildern (100+) kann es länger dauern, bis neue Bilder angezeigt werden.

- **Organisation:** Erstellen Sie Unterordner für verschiedene Themen (Urlaub, Familie, etc.) - aber beachten Sie, dass der Bilderrahmen nur den Hauptordner zeigt. Bilder müssen im Hauptordner sein!

- **Backup:** Bewahren Sie Kopien Ihrer Bilder auch auf dem Computer auf!

### 🎁 Viel Freude!

Genießen Sie Ihre schönen Erinnerungen auf dem digitalen Bilderrahmen!

---

*Diese Anleitung wurde erstellt für das Businesse Photo Frame Projekt*
