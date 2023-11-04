# uia-ind02
### Ole Hagberg
## Oppgave Progoblig 02 - Ind02

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

