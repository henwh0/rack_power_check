#!/bin/bash

source ~/scripts/ansi_colors.sh

if [[ $# -eq 0 ]]; then
    printf '%b\n' "${RED}No argument provided..${NC}"
    exit 1
fi

switchname="$1"

BORDER='+------------------------------------------------------------+'

#### Resolve rsw name IF not provided as arg ####
if [[ ! "$1" =~ ^rsw ]]; then
    rsw_sn=$(serf get name="$1" --fields=switch_serial | awk '{print $3}')
    rsw_name=$(serf get --fields=name device_type=NETWORK_SWITCH,switch_serial="$rsw_sn" -tn)
    switchname="$rsw_name"
fi

###### Resolve Rack Type ######
raw_rack_type=$(serf get name="$switchname" --fields=rack_obj.cea_rack_type 2>/dev/null | awk '{print $NF}')

if echo "$raw_rack_type" | grep -qi 'orv3'; then
    rack_type="ORV3"
elif echo "$raw_rack_type" | grep -qi 'orv2'; then
    rack_type="ORV2"
else
    printf '%b\n' "${RED}Error: Could not determine rack type from: '${raw_rack_type}'${NC}"
    exit 1
fi

###### Gather Data ######
rack_serial=$(serf get name="$switchname" --fields=rack_serial | awk '{print $3}')
serf_get_output=$(serf get -tn --fields=device_type,description rack_serial="$rack_serial",device_type=POWER_SHELF | sort | sed 's/^/| /')
shelf_count=$(echo "$serf_get_output" | wc -l)

# Raw or_check output
or_check_raw=$(or_check "$switchname")

###### Count PSUs/BBUs Based on Rack Type ######
if [[ "$rack_type" == "ORV3" ]]; then
    # ORv3 devices labeled PSU-X or BBU-X
    or_check_display=$(echo "$or_check_raw" | awk 'NR > 3 && /Shelf/{print}' | sed 's/^/| /')
    psu_found=$(echo "$or_check_raw" | grep -c "PSU-")
    bbu_found=$(echo "$or_check_raw" | grep -c "BBU-")

    # Expected: 6 PSUs x shelf_count, 6 BBUs x shelf_count
    if [[ "$shelf_count" -eq 2 ]]; then
        expected_psu=6
        expected_bbu=6
    elif [[ "$shelf_count" -eq 4 ]]; then
        expected_psu=12
        expected_bbu=12
    else
        printf '%b\n' "${RED}Error: Unexpected shelf count: ${shelf_count}${NC}"
        exit 1
    fi


elif [[ "$rack_type" == "ORV2" ]]; then
    # ORv2 each unit is a combined PSU/BBU, labeled "Shelf-X, Unit-Y"
    or_check_display=$(echo "$or_check_raw" | awk '/Shelf-.*Unit-/{print}' | sed 's/^/| /')
    total_units=$(echo "$or_check_raw" | grep -c "Shelf-.*Unit-")

    psu_found=$(echo "$or_check_raw" | awk '/Shelf-.*Unit-/{print $(NF-1)}' | grep -ci "true")
    # BBU health: last field is BBU_OK
    bbu_found=$(echo "$or_check_raw" | awk '/Shelf-.*Unit-/{print $NF}' | grep -ci "true")

    # Expected: 3 units per shelf x shelf_count
    expected_psu=$((shelf_count * 3))
    expected_bbu=$((shelf_count * 3))
fi

###### Output Report ######
printf '\n%s\n' "$BORDER"
printf '%b\n' "| ${UL_CYAN}Switchname:${NC} ${switchname}"
if [[ "$rack_type" == "ORV3" ]]; then
    printf '%b\n' "| ${UL_CYAN}Rack Type:${NC}  ${rack_type}"
else
    printf '%b\n' "| ${UL_CYAN}Rack Type:${NC}  ${rack_type}"
fi
printf '%s\n' "$BORDER"

printf '%b\n' "| ${CYAN}Number of powershelves: ${shelf_count}${NC} (serf get)"
printf '%s\n' "$BORDER"
printf '%s\n' "$serf_get_output"
printf '%s\n' "$BORDER"

printf '%b\n' "| ${CYAN}or_check assets:${NC}"
printf '%s\n' "$BORDER"
printf '%s\n' "$or_check_display"
printf '%s\n' "$BORDER"

###### Validation ######
psu_missing=$((expected_psu - psu_found))
bbu_missing=$((expected_bbu - bbu_found))

printf '%b\n' "| ${UL_CYAN}Summary:${NC}"

if [[ "$rack_type" == "ORV2" ]]; then
    printf '%s\n' "|   Units present: ${total_units} / ${expected_psu} expected"
    printf '%s\n' "|   PSU healthy:   ${psu_found} / ${expected_psu}"
    printf '%s\n' "|   BBU healthy:   ${bbu_found} / ${expected_bbu}"
else
    printf '%s\n' "|   PSU found: ${psu_found} / ${expected_psu} expected"
    printf '%s\n' "|   BBU found: ${bbu_found} / ${expected_bbu} expected"
fi
printf '%s\n' "$BORDER"

if [[ $psu_missing -le 0 && $bbu_missing -le 0 ]]; then
    printf '%b\n' "| ${GREEN} All PSUs/BBUs are present and healthy.${NC}"
else
    if [[ $psu_missing -gt 0 ]]; then
        printf '%b\n' "| ${RED} ${psu_missing} PSU(s) missing or unhealthy.${NC}"
    fi
    if [[ $bbu_missing -gt 0 ]]; then
        printf '%b\n' "| ${RED} ${bbu_missing} BBU(s) missing or unhealthy.${NC}"
    fi

    # Show unhealthy units (full line for clarity)
    if [[ "$rack_type" == "ORV2" ]]; then
        unhealthy=$(echo "$or_check_raw" | awk '/Shelf-.*Unit-/ && /False/{print "|   "$0}')
        if [[ -n "$unhealthy" ]]; then
            printf '%b\n' "| ${YELLOW}Unhealthy units:${NC}"
            printf '%s\n' "$unhealthy"
        fi
    elif [[ "$rack_type" == "ORV3" ]]; then
        unhealthy=$(echo "$or_check_raw" | awk '/(PSU|BBU)-/ && /False/{print "|   "$0}')
        if [[ -n "$unhealthy" ]]; then
            printf '%b\n' "| ${YELLOW}Unhealthy devices:${NC}"
            printf '%s\n' "$unhealthy"
        fi
    fi
fi

printf '%s\n' "$BORDER"
printf '%b\n' "| ${BOLD_GREEN}Run Complete!${NC}"
printf '%s\n' "$BORDER"
