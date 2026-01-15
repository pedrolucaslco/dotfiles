#!/bin/bash

# Força locale para usar ponto decimal
export LC_NUMERIC=C

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Função para formatar bytes em formato legível
format_bytes() {
    local bytes=$1
    # Verifica se é número válido
    if ! [[ "$bytes" =~ ^[0-9]+$ ]]; then
        echo "0K"
        return
    fi
    
    if [ $bytes -lt 1024 ]; then
        echo "${bytes}K"
    elif [ $bytes -lt 1048576 ]; then
        echo "$(awk "BEGIN {printf \"%.1f\", $bytes/1024}")M"
    else
        echo "$(awk "BEGIN {printf \"%.1f\", $bytes/1024/1024}")G"
    fi
}

# Função para obter informações totais do sistema
get_system_info() {
    local total_mem=$(free -k | awk '/^Mem:/ {print $2}')
    local used_mem=$(free -k | awk '/^Mem:/ {print $3}')
    local free_mem=$(free -k | awk '/^Mem:/ {print $4}')
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed 's/,/./g' | awk '{print $2}' | cut -d'%' -f1)
    
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}    Monitor de Processos - $(date '+%H:%M:%S')${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}CPU:${NC} ${cpu_usage}% | ${YELLOW}RAM Total:${NC} $(format_bytes $total_mem) | ${YELLOW}Usada:${NC} $(format_bytes $used_mem) | ${YELLOW}Livre:${NC} $(format_bytes $free_mem)"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# Função principal para listar processos agrupados
list_processes() {
    printf "${BOLD}%-25s %10s %8s %8s${NC}\n" "PROGRAMA" "RAM TOTAL" "PROC" "CPU%"
    echo -e "${CYAN}───────────────────────────────────────────────────────────────${NC}"
    
    # Coleta dados de todos os processos e agrupa por nome
    ps aux --no-headers | awk '{
        cmd = $11
        # Remove o caminho completo, pega só o nome do executável
        gsub(/^.*\//, "", cmd)
        # Remove argumentos
        gsub(/ .*/, "", cmd)
        
        ram[cmd] += $6  # RSS em KB
        count[cmd]++
        cpu[cmd] += $3
    }
    END {
        for (c in ram) {
            printf "%s|%.0f|%d|%.1f\n", c, ram[c], count[c], cpu[c]
        }
    }' | sort -t'|' -k2 -nr | head -n 20 | while IFS='|' read -r name ram cnt cpup; do
        
        # Garante que ram é um número válido
        if ! [[ "$ram" =~ ^[0-9]+$ ]]; then
            ram=0
        fi
        
        # Define cor baseada no uso de RAM
        if [ $ram -gt 1048576 ]; then
            color=$RED
        elif [ $ram -gt 524288 ]; then
            color=$YELLOW
        else
            color=$GREEN
        fi
        
        printf "${color}%-25s${NC} %10s %8s %7.1f%%\n" \
            "${name:0:25}" \
            "$(format_bytes $ram)" \
            "$cnt" \
            "$cpup"
    done
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

sleep=1

# Loop principal
while true; do
    clear
    get_system_info
    list_processes
    echo -e "\n${BLUE}Pressione Ctrl+C para sair | Atualizando em $sleep s...${NC}"
    sleep $sleep
done
