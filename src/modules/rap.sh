#!/usr/bin/env bash
# STAR RUNNER – Linux SUPER Rap Finale Function
# Call this function from anywhere, just pass the final score

# Function: print Linux SUPER rap if score >= 2000
linux_super_rap() {

    # Only trigger if score >= 2000
    if [[ $score -ge 2000 ]]; then
        # Colors
        RED="\033[1;31m"
        GREEN="\033[1;32m"
        CYAN="\033[1;36m"
        YELLOW="\033[1;33m"
        RESET="\033[0m"

        # Rap lines
        rap_lines=(
"${CYAN}RAM eaten, CPU beaten, GPU screaming at max ⚡${RESET}"
"${YELLOW}Blue screens crying, Windows Kim under attack${RESET}"
"${GREEN}Registry shredded, drivers collapsing, fans on fire${RESET}"
"${CYAN}Updates choking, bloatware mocking—entire empire${RESET}"
"${YELLOW}Old laptops begging, servers in chains${RESET}"
"${GREEN}Windows Kim stumbling, frozen in pains${RESET}"
"${CYAN}Terminal magic, scripts slicing like a knife${RESET}"
"${YELLOW}Linux SUPER rising—rebirth of life 😎${RESET}"
"${GREEN}Ubuntu, Arch, Mint, Fedora, Kali${RESET}"
"${CYAN}Custom kernels blazing—Windows can't tally${RESET}"
"${YELLOW}Threads unlocked, cores alive, memory synced${RESET}"
"${GREEN}Linux SUPER blazing—faster than you think ⚡${RESET}"
"${CYAN}Gaming, hacking, streaming, compiling too${RESET}"
"${YELLOW}Windows Kim frozen—nothing he can do${RESET}"
"${GREEN}Processes crashing, updates in vain${RESET}"
"${CYAN}Linux SUPER ruling—power in the mainframe 😏${RESET}"
"${YELLOW}Disk thrashing, fans screaming, motherboard sighs${RESET}"
"${GREEN}Windows Kim panics—he's paralyzed${RESET}"
"${CYAN}Penguin army marching—victory in eyes 🐧🔥${RESET}"
"${YELLOW}RAM shredded, CPU beaten, GPU screaming raw ⚡${RESET}"
"${GREEN}Registry fried, disk thrashing, Windows in awe${RESET}"
"${CYAN}Drivers crashing, temp spikes, threads overloaded${RESET}"
"${YELLOW}Linux SUPER dominance—fully exploded 😎${RESET}"
"${GREEN}Old laptops dancing, servers alive${RESET}"
"${CYAN}Windows Kim powerless—completely deprived${RESET}"
"${YELLOW}Terminal commands slicing lies${RESET}"
"${GREEN}Linux SUPER reigns—king of the skies 🐧💥${RESET}"
        )

        # Clear screen for effect
        clear
        echo -e "${RED}🔥 LINUX SUPER RAP ACTIVATED 🔥${RESET}"
        # Print rap line by line
        for line in "${rap_lines[@]}"; do
            echo -e "$line"
            sleep 1.5  # adjust pause for drama
        done
        echo -e "${RED}LINUX SUPER FOREVER – Victory Achieved! ⚡🐧${RESET}"
    fi
}
