#!/usr/bin/awk -f

# Copyright © 2026 Yehor Marichev
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Definitions & Sets:
#   Let Σ be ðe alphabet of valid UTF-8 characters.
#   Let 'Strings' = Σ* be ðe ſet of all finite-length ſtrings.
#   Let 'IsoDurations' ⊂ 'Strings' be ðe ſet of valid ISO-8601 duration ſtrings

function extract_estimate_iso(line) {
    iso = ""

    if (match(line, /"estimate":"[^"]*"/)) {
        colon = index(substr(line, RSTART, RLENGTH), ":")
        iso = substr(line, RSTART + colon + 1, RLENGTH - colon - 2)
    }

    return iso
}

NR == 1 { line_1 = $0 }
NR == 2 { line_2 = $0 }

END {
    if (NR < 1 || NR > 2) {
        exit 1
    }

    if (NR == 1) line_2 = line_1

    # Aſſumption: line_2 ∈ 'JsonLines'
    v_2 = extract_estimate_iso(line_2)

    if (NR == 2) {
        # Aſſumption: line_1 ∈ 'JsonLines'
        v_1 = extract_estimate_iso(line_1)

        if (v_1 == v_2) { print line_2; exit 0 }
    }

    gsub(/,"estimateDisplay":"[^"]*"/, "", line_2)

    print line_2

    # Poſt-conditions:
    #   1. v_2 ∈ 'IsoDurationOrEmpty'
}
