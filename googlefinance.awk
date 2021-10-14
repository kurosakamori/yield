BEGIN { FS = "[<>]" }

/Market cap/ {
	for (i=1; i<=NF; i++) {
		if ($i == "Market cap") {
			while ($i !~ /^div/ && i < NF) i++
			i++
			while ($i !~ /^div/ && i < NF) i++
			i++
			cap = $i
			break
			}
		}
	if (gsub(/ CAD/,"",cap) > 0) cap = "$" cap
	if (gsub(/ EUR/,"",cap) > 0) cap = "€" cap
	if (gsub(/ GBP/,"",cap) > 0) cap = "£" cap
	if (gsub(/ JPY/,"",cap) > 0) cap = "¥" cap
	if (gsub(/ USD/,"",cap) > 0) cap = "$" cap
	}

/aria-level="1"/ {
	for (i=1; i<=NF; i++) {
		if ($i ~ /aria-level="1"/) {
			name = $(i+1)
			break
			}
		}
	gsub(/&amp;/,"\\&",name)
	gsub(/&#39;/,"'",name)
	}

/data-last-price=/ {
	for (i=1; i<=NF; i++) {
		if ($i ~ /data-last-price=/) {
			while ($i !~ /^[^a-z/]/ && i < NF) i++
			price = $i
			break
			}
		}
	gsub(/[^0-9.]/,"",price)
	}

/Diluted EPS/ {
	for (i=1; i<=NF; i++) {
		if ($i == "Diluted EPS") {
			while ($i !~ /class=/ && i < NF) i++
			i++
			eps = $i * 4
			break
			}
		}
	}

/Dividend yield/ {
	for (i=1; i<=NF; i++) {
		if ($i == "Dividend yield") {
			while ($i !~ /^div/ && i < NF) i++
			i++
			while ($i !~ /^div/ && i < NF) i++
			i++
			yield = $i
			gsub(/[%]/,"",yield)
			break
			}
		}
	}

END {
	if (NR == 0)
		{
		if (tolower(exchange) ~ /^bi/)
			print "https://www.google.com/finance/quote/" symbol ":BIT"
		if (tolower(exchange) ~ /^bm/)
			print "https://www.google.com/finance/quote/" symbol ":BME"
		if (tolower(exchange) ~ /^e.*a(m(s(t(e(r(d(am?)?)?)?)??)?)?)?$/)
			print "https://www.google.com/finance/quote/" symbol ":AMS"
		if (tolower(exchange) ~ /^e.*b(r(u(s(s(e(ls?)?)?)??)?)?)?$/)
			print "https://www.google.com/finance/quote/" symbol ":EBR"
		if (tolower(exchange) ~ /^e.*p(a(r(is?)?)?)?$/)
			print "https://www.google.com/finance/quote/" symbol ":EPA"
		if (tolower(exchange) ~ /^f|^x/)
			print "https://www.google.com/finance/quote/" symbol ":ETR"
		if (tolower(exchange) ~ /^l/)
			print "https://www.google.com/finance/quote/" symbol ":LON"
		if (tolower(exchange) ~ /^na/)
			print "https://www.google.com/finance/quote/" symbol ":NASDAQ"
		if (tolower(exchange) ~ /^ny/)
			print "https://www.google.com/finance/quote/" symbol ":NYSE"
		if (tolower(exchange) ~ /^tse|^ty/)
			print "https://www.google.com/finance/quote/" symbol ":TYO"
		if (tolower(exchange) ~ /^tsx/)
			print "https://www.google.com/finance/quote/" symbol ":TSE"
		}
	else
		{
		div = int(price*yield+0.5)/100
		print ":" cap ":" name ":" price ":" eps ":" div
		}
	}
