# uia-progob 02 individuel
### Ole Hagberg
Lenke til repository: https://github.com/cataclym/uia-ind02
## Oppgave Progoblig 02 - Ind01
Fil: nordiske-flagg.arr

Her har jeg brukt bibliotekene color og tables, de ble brukt for å kunne manipulere tabeller og definere egne farger.
Videre har jeg brukt `sieve` for å filtrere ut tabellen for å finne riktig nasjon. Det ble brukt sammen med string-to-lower() for å gjøre argumentet til små bokstaver.

```arr
include color
include tables

fun lag-nordisk-flagg(nordisk-nasjon :: String):
  doc: "Tar en Nordisk nasjon som input og returnerer et bilde av nasjonen sitt flagg."
  
  #|Tabellen er fylt inn med data hentet fra forksjellige Wikipedia sider og prossesert til relevant informasjon.
    
    Fargene er hentet fra Wikipedia sidene til flaggene og konvertert fra hex-farger til RGBA. 
    Hvit farge bruker den innebyggde fargen i pyret.

    Proposjonene er hentet fra Wikipedia og står for lengde og bredde.

    Breddeforholdene er basert på lengden fra hjørne av flagget til korset.
    I listen er det 2 eller 3 tall
    Det første er lengden fra hjørne av flagget til korset i vertikal vinkel.
    Det andre er bredden på det første korset.
    Det tredje finnes bare på flagg som ikke har en kvadrat rektangel mellom korset på venstre side-
    og bestemmer hvor langt det er til korset fra venstre hjørne. 
  |#
  flagg-tabell = table: nasjon :: String, farger :: List<Color>, proposjoner :: List<Number>, breddeforhold :: List<Number>
    
    row: "norge", [list: color(186, 12, 47, 1), white, color(0, 32, 91, 1)], [list: 22, 16], [list: 6, 4]

    row: "sverige", [list: color(0, 106, 167, 1), color(254, 204, 2, 1)], [list: 16, 10], [list: 4, 2, 5]

    row: "danmark", [list: color(224, 024, 054, 1), white], [list: 37, 28], [list: 12, 4]

    row: "færøyene", [list: white, color(0, 94, 185, 1), color(239, 48, 62, 1)], [list: 22, 16], [list: 6, 4]

    row: "finland", [list: white, color(24, 68, 126, 1)], [list: 18, 11], [list: 4, 3, 5]

    row: "island", [list: color(2, 82, 156, 1), white, color(220, 30, 53, 1)], [list: 25, 18], [list: 7, 4]
  end

  # Filtrerer ut rader som ikke stemmer med argument
  flagg-rad-filtrert = sieve flagg-tabell using nasjon:
    # Converterer argument-tekst til "små bokstaver"
    # for å kunne samsvare med nasjon kolonnen.
    nasjon == string-to-lower(nordisk-nasjon)
  end

  if flagg-rad-filtrert.length() == 0:
    raise("Argumentet '" + nordisk-nasjon + "' stemmer ikke med en Nordisk nasjon!")
  else:
    flagg-rad = flagg-rad-filtrert.row-n(0)
    
    hoved-kors-bredde = flagg-rad["breddeforhold"].get(1)

    # Henter flaggets dimensjoner fra en liste
    flagg-lengde = flagg-rad["proposjoner"].get(0) * 10
    flagg-bredde = flagg-rad["proposjoner"].get(1) * 10

    hoved-kors = hoved-kors-bredde * 10

    andre-kors = (hoved-kors-bredde / 2) * 10

    hoved-plassering = flagg-rad["breddeforhold"].get(0) * -10

    # Her defineres bakgrunnen
    bakgrunn = rectangle(flagg-lengde, flagg-bredde, "solid", flagg-rad["farger"].get(0))

    # Definerer de hvite stripene
    hoved-kors-linje-horisontalt = rectangle(flagg-lengde, hoved-kors, "solid", flagg-rad["farger"].get(1))
    hoved-kors-linje-vertikalt = rectangle(hoved-kors, flagg-bredde, "solid", flagg-rad["farger"].get(1))

    # Tegner den horisontale kors-linjen på bakrunnen
    hovedkors-overlay = overlay-xy(hoved-kors-linje-horisontalt, 0, hoved-plassering, bakgrunn)

    # Lambda uttrykk for å plassere korset riktig i forhold til flaggets aktuelle dimensjoner
    konstruer-kors = lam():
      if flagg-rad["breddeforhold"].length() > 2:
        kors-avlangt-rektangel-plassering = flagg-rad["breddeforhold"].get(2) * -10

        overlay-xy(hoved-kors-linje-vertikalt, kors-avlangt-rektangel-plassering, 0, hovedkors-overlay)
      else:
        overlay-xy(hoved-kors-linje-vertikalt, hoved-plassering, 0, hovedkors-overlay)
      end
    end

    to-farget-flagg = konstruer-kors()

    # Hvis flagget har en tredje farge blir den lagt oppå her 
    if flagg-rad["farger"].length() > 2:
      andre-plassering = hoved-plassering + ((hoved-kors-bredde / 4) * -10)

      andre-kors-linje-horisontalt = rectangle(flagg-lengde, andre-kors, "solid", flagg-rad["farger"].get(2))
      andre-kors-linje-vertikalt = rectangle(andre-kors, flagg-bredde, "solid", flagg-rad["farger"].get(2))

      # Legger blå striper oppå flagget
      andre-kors-overlay = overlay-xy(andre-kors-linje-horisontalt, 0, andre-plassering, to-farget-flagg)
      tre-farget-flagg = overlay-xy(andre-kors-linje-vertikalt, andre-plassering, 0, andre-kors-overlay)
      
      # Returner resultatet
      tre-farget-flagg
    else:
      to-farget-flagg
    end
  end
end
```

## Oppgave Progoblig 02 - Ind02
Fil: Oppgave-Ind02.arr

### a) 
```arr
include gdrive-sheets
include data-source

ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer
  end

kWh-wealthy-consumer-data
```

### b)
```arr
include shared-gdrive(
  "dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")

fun energi-to-number(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
  end

where:
  energi-to-number("") is 0
  energi-to-number("48") is 48
end
```

### c)

```arr
include shared-gdrive(
  "dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")

include gdrive-sheets
include data-source

ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer
  end

fun energi-to-number(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
  end

where:
  energi-to-number("") is 0
  energi-to-number("48") is 48
end

transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number)

```

### d) 
Med utgangspunkt i en typisk Nordmann som kjører 37.6km hver dag så er det totale energiforbruket 186kWh/dag. 

```arr
include shared-gdrive(
  "dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")

include gdrive-sheets
include data-source
include tables

ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer
  end

fun energi-to-number(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
  end

where:
  energi-to-number("") is 0
  energi-to-number("48") is 48
end

transformert = transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number)
#transformert

sum(transformert, "energi")

fun bilforkbruk-energi(reise-avstand-per-dag):
  num-round((reise-avstand-per-dag / 12) * 10)
end


bil-energi = bilforkbruk-energi(37.6)

energi-kolonne = transformert
  .get-column("energi")
  .set(0, bil-energi)

ny-tabell = [table-from-columns:
  {"komponent"; transformert.get-column("komponent")},
  {"energi"; energi-kolonne}
]

total-energiforbruk = sum(ny-tabell, "energi")

"Totalt energiforbruk for en typisk Nordmann er " + num-to-string(total-energiforbruk) + "kWh/dag."
```

### e) 
I energi-to-number så kunne man returnert bil-energi istede for 0, men da hadde ikke funksjonen fungert riktig på andre tabeller.

![Tabell](https://nextcloud.libernets.org/s/emrxwesdFGqGRyY/download/Screenshot_20231104_211703.png "Title")


```arr
include shared-gdrive(
  "dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")

include gdrive-sheets
include data-source
include tables

ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer
  end

fun energi-to-number(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
  end

where:
  energi-to-number("") is 0
  energi-to-number("48") is 48
end

transformert = transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number)
#transformert

fun bilforkbruk-energi(reise-avstand-per-dag):
  num-round((reise-avstand-per-dag / 12) * 10)
end

# Nordmenn med 1 bil reiste 37.6km hver dag i gjennomsnitt i 2013/14
bil-energi = bilforkbruk-energi(37.6)

energi-kolonne = transformert
  .get-column("energi")
  .set(0, bil-energi)

ny-tabell = [table-from-columns:
  {"komponent"; transformert.get-column("komponent")},
  {"energi"; energi-kolonne}
]

total-energiforbruk = sum(ny-tabell, "energi")

"Totalt energiforbruk for en typisk Nordmann er " + num-to-string(total-energiforbruk) + "kWh/dag."

bar-chart(ny-tabell, "komponent", "energi")
```

