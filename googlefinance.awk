BEGIN { FS = "[<>]" }

/Market cap/ {
	for (i=1; i<=NF; i++) {
		if ($i == "Market cap") {
			while ($i !~ /class="P6K39c"/ && i < NF) i++
			i++
			cap = $i
			break
			}
		}
	if (gsub(/ CAD/,"",cap) > 0) cap = "$" cap
	if (gsub(/ JPY/,"",cap) > 0) cap = "¥" cap
	if (gsub(/ USD/,"",cap) > 0) cap = "$" cap
	}

/h1 class=/ {
	for (i=1; i<=NF; i++) {
		if ($i ~ /h1 class=/) {
			i++
			name = $i
			while ($i !~ /class="YMlKec fxKbKc"/ && i < NF) i++
			i++
			price = $i
			break
			}
		}
	gsub(/&amp;/,"\\&",name)
	gsub(/[,$¥]/,"",price)
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
			while ($i !~ /class="P6K39c"/ && i < NF) i++
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
