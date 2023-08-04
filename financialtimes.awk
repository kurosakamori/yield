BEGIN { FS = "[<>]" }

/Market cap/ {
	for (i=1; i<=NF; i++) {
		if ($i == "Market cap") {
			cap = toupper($(i+4))
			break
			}
		}
	gsub(/[^0-9.BMT]/,"",cap)
	}

/--large/ {
	for (i=1; i<=NF; i++) {
		if ($i ~ /--large/) {
			name = $(i+1)
			break
			}
		}
	gsub(/&amp;/,"\\&",name)
	gsub(/&#39;/,"'",name)
	}

/Price \(/ {
	for (i=1; i<=NF; i++) {
		if ($i ~ /^Price \(/) {
			curr = substr($i,8,3)
			price = $(i+4)
			break
			}
		}
	gsub(/[^0-9.]/,"",price)
	}

/EPS / {
	for (i=1; i<=NF; i++) {
		if ($i == "EPS ") {
			eps = $(i+8)
			break
			}
		}
	gsub(/[^0-9.]/,"",eps)
	}

/Annual div / {
	for (i=1; i<=NF; i++) {
		if ($i == "Annual div ") {
			div = $(i+8)
			break
			}
		}
	gsub(/[^0-9.]/,"",div)
	}

END {
	if (NR == 0)
		{
		site = "https://markets.ft.com/data/equities/tearsheet/summary?s="
		symbol = toupper(symbol)
		if (tolower(exchange) ~ /^bi/)
			print site symbol ":MIL"
		if (tolower(exchange) ~ /^bm/)
			print site symbol ":MCE"
		if (tolower(exchange) ~ /^e.*a(m(s(t(e(r(d(am?)?)?)?)??)?)?)?$/)
			print site symbol ":AEX"
		if (tolower(exchange) ~ /^e.*b(r(u(s(s(e(ls?)?)?)??)?)?)?$/)
			print site symbol ":BRU"
		if (tolower(exchange) ~ /^e.*p(a(r(is?)?)?)?$/)
			print site symbol ":PAR"
		if (tolower(exchange) ~ /^f|^x/)
			print site symbol ":FRA"
		if (tolower(exchange) ~ /^l/)
			print site symbol ":LSE"
		if (tolower(exchange) ~ /^na/)
			print site symbol ":NSQ"
		if (tolower(exchange) ~ /^ny/)
			print site symbol ":NYQ"
		if (tolower(exchange) ~ /^tse|^ty/)
			print site symbol ":TYO"
		if (tolower(exchange) ~ /^tsx/)
			print site symbol ":TOR"
		}
	else
		{
		if (curr == "CAD") cap = "$" cap
		if (curr == "EUR") cap = "€" cap
		if (curr == "GBX") cap = "£" cap
		if (curr == "JPY") cap = "¥" cap
		if (curr == "USD") cap = "$" cap
		print ":" cap ":" name ":" price ":" eps ":" div
		}
	}
