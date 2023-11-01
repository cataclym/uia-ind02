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