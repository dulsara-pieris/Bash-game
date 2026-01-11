#!/usr/bin/env bash

# STAR RUNNER - Shop Module
# Hangar (ship selection/purchase) and skin shop

# Show hangar - ship selection and purchase
show_hangar() {
  clear
  printf "${COLOR_CYAN}╔═══════════════════════════════════════════════════════╗${COLOR_NEUTRAL}\n"
  printf "${COLOR_CYAN}║${COLOR_NEUTRAL}                    HANGAR - SHIP SELECTION            ${COLOR_CYAN}║${COLOR_NEUTRAL}\n"
  printf "${COLOR_CYAN}╚═══════════════════════════════════════════════════════╝${COLOR_NEUTRAL}\n\n"
  printf "  ${COLOR_YELLOW}Crystal Bank: ${crystal_bank}💎${COLOR_NEUTRAL}\n\n"
  
  i=1
  while [ $i -le 5 ]; do
    ship_name=$(get_ship_name $i)
    ship_icon=$(get_ship_icon $i)
    ship_speed=$(get_ship_speed $i)
    ship_ammo=$(get_ship_ammo $i)
    ship_price=$(get_ship_price $i)
    
    if check_ownership "$i" "$owned_ships"; then
      if [ "$current_ship" = "$i" ]; then
        status="${COLOR_YELLOW}[EQUIPPED]${COLOR_NEUTRAL}"
      else
        status="${COLOR_GREEN}[OWNED]${COLOR_NEUTRAL}"
      fi
    else
      status="${COLOR_RED}[LOCKED - ${ship_price}💎]${COLOR_NEUTRAL}"
    fi
    
    printf "  ${COLOR_CYAN}[$i]${COLOR_NEUTRAL} $ship_icon $ship_name - Speed:$ship_speed Ammo:$ship_ammo $status\n"
    i=$((i + 1))
  done
  
  printf "\n  ${COLOR_GREEN}[E]${COLOR_NEUTRAL} Equip Ship | ${COLOR_YELLOW}[B]${COLOR_NEUTRAL} Buy Ship | ${COLOR_MAGENTA}[S]${COLOR_NEUTRAL} Skins | ${COLOR_WHITE}[R]${COLOR_NEUTRAL} Return\n"
  printf "\n  Select option: "
  
  read -r hangar_choice
  
  case $hangar_choice in
    [1-5])
      if check_ownership "$hangar_choice" "$owned_ships"; then
        current_ship=$hangar_choice
        save_profile
        printf "\n  ${COLOR_GREEN}✓ Ship equipped!${COLOR_NEUTRAL}\n"
        sleep 1
        show_hangar
      else
        printf "\n  ${COLOR_RED}✗ You don't own this ship!${COLOR_NEUTRAL}\n"
        sleep 2
        show_hangar
      fi
      ;;
    [Bb])
      printf "\n  Enter ship number to buy (1-5): "
      read -r buy_ship
      case $buy_ship in
        [1-5])
          if check_ownership "$buy_ship" "$owned_ships"; then
            printf "\n  ${COLOR_YELLOW}You already own this ship!${COLOR_NEUTRAL}\n"
            sleep 2
          else
            ship_price=$(get_ship_price "$buy_ship")
            ship_name=$(get_ship_name "$buy_ship")
            if [ "$crystal_bank" -ge "$ship_price" ]; then
              crystal_bank=$((crystal_bank - ship_price))
              owned_ships=$(add_to_owned "$buy_ship" "$owned_ships")
              current_ship=$buy_ship
              save_profile
              printf "\n  ${COLOR_GREEN}✓ Purchased and equipped $ship_name!${COLOR_NEUTRAL}\n"
              sleep 2
            else
              printf "\n  ${COLOR_RED}✗ Not enough crystals! Need: $ship_price, Have: $crystal_bank${COLOR_NEUTRAL}\n"
              sleep 2
            fi
          fi
          ;;
      esac
      show_hangar
      ;;
    [Ss])
      show_skin_shop
      ;;
    [Ee])
      printf "\n  Enter ship number to equip (1-5): "
      read -r equip_ship
      case $equip_ship in
        [1-5])
          if check_ownership "$equip_ship" "$owned_ships"; then
            current_ship=$equip_ship
            save_profile
            printf "\n  ${COLOR_GREEN}✓ Ship equipped!${COLOR_NEUTRAL}\n"
            sleep 1
          else
            printf "\n  ${COLOR_RED}✗ You don't own this ship!${COLOR_NEUTRAL}\n"
            sleep 2
          fi
          ;;
      esac
      show_hangar
      ;;
    [Rr])
      return
      ;;
    *)
      show_hangar
      ;;
  esac
}

# Show skin shop - skin customization
show_skin_shop() {
  clear
  printf "${COLOR_MAGENTA}╔═══════════════════════════════════════════════════════╗${COLOR_NEUTRAL}\n"
  printf "${COLOR_MAGENTA}║${COLOR_NEUTRAL}                    SKIN CUSTOMIZATION                 ${COLOR_MAGENTA}║${COLOR_NEUTRAL}\n"
  printf "${COLOR_MAGENTA}╚═══════════════════════════════════════════════════════╝${COLOR_NEUTRAL}\n\n"
  printf "  ${COLOR_YELLOW}Crystal Bank: ${crystal_bank}💎${COLOR_NEUTRAL}\n\n"
  
  i=1
  while [ $i -le 5 ]; do
    skin_name=$(get_skin_name $i)
    skin_color=$(get_skin_color $i)
    skin_price=$(get_skin_price $i)
    ship_icon=$(get_ship_icon "$current_ship")
    
    if check_ownership "$i" "$owned_skins"; then
      if [ "$current_skin" = "$i" ]; then
        status="${COLOR_YELLOW}[ACTIVE]${COLOR_NEUTRAL}"
      else
        status="${COLOR_GREEN}[OWNED]${COLOR_NEUTRAL}"
      fi
    else
      status="${COLOR_RED}[LOCKED - ${skin_price}💎]${COLOR_NEUTRAL}"
    fi
    
    printf "  ${COLOR_CYAN}[$i]${COLOR_NEUTRAL} ${skin_color}${ship_icon}${COLOR_NEUTRAL} $skin_name $status\n"
    i=$((i + 1))
  done
  
  printf "\n  ${COLOR_GREEN}[A]${COLOR_NEUTRAL} Apply Skin | ${COLOR_YELLOW}[B]${COLOR_NEUTRAL} Buy Skin | ${COLOR_WHITE}[R]${COLOR_NEUTRAL} Return\n"
  printf "\n  Select option: "
  
  read -r skin_choice
  
  case $skin_choice in
    [1-5])
      if check_ownership "$skin_choice" "$owned_skins"; then
        current_skin=$skin_choice
        save_profile
        printf "\n  ${COLOR_GREEN}✓ Skin applied!${COLOR_NEUTRAL}\n"
        sleep 1
        show_skin_shop
      else
        printf "\n  ${COLOR_RED}✗ You don't own this skin!${COLOR_NEUTRAL}\n"
        sleep 2
        show_skin_shop
      fi
      ;;
    [Bb])
      printf "\n  Enter skin number to buy (1-5): "
      read -r buy_skin
      case $buy_skin in
        [1-5])
          if check_ownership "$buy_skin" "$owned_skins"; then
            printf "\n  ${COLOR_YELLOW}You already own this skin!${COLOR_NEUTRAL}\n"
            sleep 2
          else
            skin_price=$(get_skin_price "$buy_skin")
            skin_name=$(get_skin_name "$buy_skin")
            if [ "$crystal_bank" -ge "$skin_price" ]; then
              crystal_bank=$((crystal_bank - skin_price))
              owned_skins=$(add_to_owned "$buy_skin" "$owned_skins")
              current_skin=$buy_skin
              save_profile
              printf "\n  ${COLOR_GREEN}✓ Purchased and applied $skin_name skin!${COLOR_NEUTRAL}\n"
              sleep 2
            else
              printf "\n  ${COLOR_RED}✗ Not enough crystals! Need: $skin_price, Have: $crystal_bank${COLOR_NEUTRAL}\n"
              sleep 2
            fi
          fi
          ;;
      esac
      show_skin_shop
      ;;
    [Aa])
      printf "\n  Enter skin number to apply (1-5): "
      read -r apply_skin
      case $apply_skin in
        [1-5])
          if check_ownership "$apply_skin" "$owned_skins"; then
            current_skin=$apply_skin
            save_profile
            printf "\n  ${COLOR_GREEN}✓ Skin applied!${COLOR_NEUTRAL}\n"
            sleep 1
          else
            printf "\n  ${COLOR_RED}✗ You don't own this skin!${COLOR_NEUTRAL}\n"
            sleep 2
          fi
          ;;
      esac
      show_skin_shop
      ;;
    [Rr])
      show_hangar
      ;;
    *)
      show_skin_shop
      ;;
  esac
}